var mysql = require('mysql');
var log4js = require('log4js');
var io = require('socket.io')(8000);
var request = require('request');
var fs = require('fs');
var md5 = require('md5');
var sha256 = require('sha256');
var math = require('mathjs');

log4js.configure({
	appenders: [
		{ type: 'console' },
		{ type: 'file', filename: 'logs/site.log' }
	]
});
var logger = log4js.getLogger();

var pool  = mysql.createPool({
	connectionLimit : 10,
	database: 'csgo',
	host: 'localhost',
	user: 'root',
	password: 'Tomelloso123'
});

process.on('uncaughtException', function (err) {
 logger.trace('Strange error');
 logger.debug(err);
});

/* */
var accept = 30;
var wait = 10; 
var br = 3; 
var chat = 2; 
var chatb = 2000000; 
var maxbet = 5000000; 
var minbet = 1; 
var q1 = 2; 
var q2 = 14; 
var timer = -1; 
var users = {}; 
var roll = 0; 
var currentBets = [];
var historyRolls = []; 
var usersBr = {};
var usersAmount = {}; 
var currentSums = {
	'0-0': 0,
	'1-7': 0,
	'8-14': 0
};
var currentRollid = 0;
var pause = false;
var hash = ''; 
var last_message = {};
/* */

load();

var prices;
request('http://backpack.tf/api/IGetMarketPrices/v1/?key=56fce4a5c4404545131c8fcf&compress=1&appid=730', function(error, response, body) {
	prices = JSON.parse(body);
	if(prices.response.success == 0) {
        logger.warn('Loaded fresh prices');
        if(fs.existsSync(__dirname + '/prices.txt')){
            prices = JSON.parse(fs.readFileSync(__dirname + '/prices.txt'));
            logger.warn('Prices loaded from cache');
        } else {
        	logger.error('No prices in cache');
            process.exit(0);
        }
    } else {
        fs.writeFileSync('prices.txt', body);
        logger.trace('New prices loaded');
    }
});

updateHash();
function updateHash() {
	query('SELECT * FROM `hash` ORDER BY `id` DESC LIMIT 1', function(err, row) {
		if(err) {
			logger.error('Cant get the hash, stopping');
			logger.debug(err);
			process.exit(0);
			return;
		}
		if(row.length == 0) {
			logger.error('Wrong hash found, stopping');
			process.exit(0);
		} else {
			if(hash != row[0].hash) logger.warn('Loaded hash'+row[0].hash);
			hash = row[0].hash;
		}
	});
}

io.on('connection', function(socket) {
	var user = false;
	socket.on('hash', function(hash) {
		query('SELECT * FROM `users` WHERE `hash` = '+pool.escape(hash), function(err, row) {
			if((err) || (!row.length)) return socket.disconnect();
			user = row[0];
			users[user.steamid] = {
				socket: socket.id,
				balance: parseInt(row[0].balance)
			}
			socket.emit('message', {
				accept: accept,
				balance: row[0].balance,
				br: br,
				chat: chat,
				chatb: chatb,
				count: timer-wait,
				icon: row[0].avatar,
				maxbet: maxbet,
				minbet: minbet,
				name: row[0].name,
				rank: row[0].rank,
				rolls: historyRolls,
				type: 'hello',
				user: row[0].steamid
			});
			socket.emit('message', {
				type: 'logins',
				count: Object.size(io.sockets.connected)
			});
			currentBets.forEach(function(itm) {
				socket.emit('message', {
					type: 'bet',
					bet: {
						amount: itm.amount,
						betid: itm.betid,
						icon: itm.icon,
						lower: itm.lower,
						name: itm.name,
						rollid: itm.rollid,
						upper: itm.upper,
						user: itm.user,
						won: null
					},
					sums: {
						0: currentSums['0-0'],
						1: currentSums['1-7'],
						2: currentSums['8-14'],
					}
				});
			});
		});
	});
	socket.on('mes', function(m) {
		if(!user) return;
		logger.debug(m);
		if(m.type == "bet") return setBet(m, user, socket);
		if(m.type == "balance") return getBalance(user, socket);
		if(m.type == "chat") return ch(m, user, socket);
		if(m.type == "plus") return plus(user, socket);
	});
	socket.on('disconnect', function() {
		io.sockets.emit('message', {
			type: 'logins',
			count: Object.size(io.sockets.connected)
		});
		delete users[user.steamid];
	})
});

function plus(user, socket) {
	query('SELECT * FROM `users` WHERE `steamid` = '+pool.escape(user.steamid), function(err, row) {
		if(err) return;
		if(time() > row[0].plus) {
			query('UPDATE `users` SET `plus` = '+pool.escape(time()+10*60)+', `balance` = `balance` + 1 WHERE `steamid` = '+user.steamid);
			socket.emit('message', {
				type: 'alert',
				alert: 'Confirmed'
			});
			getBalance(user, socket);
		} else {
			socket.emit('message', {
				type: 'alert',
				alert: 'You have '+(row[0].plus-time())+' to accept'
			});			
		}
	});
}

function ch(m, user, socket) {
	if(m.msg) {
		if(last_message[user.steamid]+1 >= time()) {
			console.log('Too fast');
			return;
		} else {
			last_message[user.steamid] = time();
		}
		var res = null;
		if (res = /^\/send ([0-9]*) ([0-9]*)/.exec(m.msg)) {
			logger.trace('We need to send coins from '+res[2]+' to '+res[1]);
			query('SELECT `balance` FROM `users` WHERE `steamid` = '+pool.escape(user.steamid), function(err, row) {
				if((err) || (!row.length)) {
					logger.error('Failed to get the person in the database');
					logger.debug(err);
					socket.emit('message', {
						type: 'error',
						enable: false,
						error: 'Error: User not in DB.'
					});
					return;
				}
				if(row[0].balance < res[2]) {
					socket.emit('message', {
						type: 'error',
						enable: false,
						error: 'Error: Insufficient funds.'
					});
				} else if(res[2] <= 0) {
					socket.emit('message', {
						type: 'error',
						enable: false,
						error: 'Error: Amount must be greater than 0.'
					});
				} else {
					query('SELECT `name` FROM `users` WHERE `steamid` = '+pool.escape(res[1]), function(err2, row2) {
						if((err) || (!row.length)) {
							logger.error('Failed to get the STEAMID');
							logger.debug(err);
							socket.emit('message', {
								type: 'error',
								enable: false,
								error: 'Error: Unknown receiver.'
							});
							return;
						}
						query('UPDATE `users` SET `balance` = `balance` - '+res[2]+' WHERE `steamid` = '+pool.escape(user.steamid));
						query('UPDATE `users` SET `balance` = `balance` + '+res[2]+' WHERE `steamid` = '+pool.escape(res[1]));
						query('INSERT INTO `transfers` SET `from1` = '+pool.escape(user.steamid)+', `to1` = '+pool.escape(res[1])+', `amount` = '+pool.escape(res[2])+', `time` = '+pool.escape(time()));
						socket.emit('message', {
							type: 'alert',
							alert: 'You sent '+res[2]+' coins to '+row2[0].name+'.'
						});
						getBalance(user, socket);
					});
				}
			});
		} else if (res = /^\/mute ([0-9]*) ([0-9]*)/.exec(m.msg)) {
			if(user.rank > 0) {
				var t = time();
				query('UPDATE `users` SET `mute` = '+pool.escape(parseInt(t)+parseInt(res[2]))+' WHERE `steamid` = '+pool.escape(res[1]));
				socket.emit('message', {
					type: 'alert',
					alert: 'You mute '+res[1]+' to '+res[2]
				});
			}
		} else {

			query('SELECT `mute` FROM `users` WHERE `steamid` = '+pool.escape(user.steamid), function(err, row) {
				if(err) return;
				if(row[0].mute > time()) {
					socket.emit('message', {
						type: 'alert',
						alert: 'You are muted '+(row[0].mute-time())
					});
					return;
				}
				io.sockets.emit('message', {
					type: 'chat',
					msg: safe_tags_replace(m.msg),
					name: user.name,
					icon: user.avatar,
					user: user.steamid,
					rank: user.rank,
					lang: m.lang,
					hide: m.hide
				});
			});
		}
	}
}

function getBalance(user, socket) {
	query('SELECT `balance` FROM `users` WHERE `steamid` = '+pool.escape(user.steamid), function(err, row) {
		if((err) || (!row.length)) {
			logger.error('Failed to load your balance');
			logger.debug(err);
			socket.emit('message', {
				type: 'error',
				enable: true,
				error: 'Error: You are not DB.'
			});
			return;
		}
		socket.emit('message', {
			type: 'balance',
			balance: row[0].balance
		});
		if(user.steamid) users[user.steamid].balance = parseInt(row[0].balance);
	})
}

function setBet(m, user, socket) {
	if((usersBr[user.steamid] !== undefined) && (usersBr[user.steamid] == br)) {
		socket.emit('message', {
			type: 'error',
			enable: true,
			error: 'You\'ve already placed '+usersBr[user.steamid]+'/'+br+' bets this roll.'
		});
		return;
	}
	if((m.amount < minbet) || (m.amount > maxbet)) {
		socket.emit('message', {
			type: 'error',
			enable: true,
			error: 'Invalid bet amount.'

		});
		return;
	}
	if(pause) {
		socket.emit('message', {
			type: 'error',
			enable: false,
			error: 'Betting for this round is closed.'
		});
		return;
	}
	    if(m.upper - m.lower > 6){
            logger.warn("User tried to place an invalid bid!! (Might be hacking)");
            return;
        } else {
            if(m.lower != 0 && m.lower != 1 && m.lower != 8){
                logger.warn("User is trying some weird offset!! (Might be hacking)");
                return;
            }
            if(m.lower == 0){
                m.upper = 0;
            } else {
                m.upper = m.lower + 6;
            }
        }
	var start_time = new Date();
	query('SELECT `balance` FROM `users` WHERE `steamid` = '+pool.escape(user.steamid), function(err, row) {
		if((err) || (!row.length)) {
			logger.error('Failed to find DB');
			logger.debug(err);
			socket.emit('message', {
				type: 'error',
				enable: true,
				error: 'You are not DB'
			});
			return;
		}
		if(row[0].balance >= m.amount) {
			query('UPDATE `users` SET `balance` = `balance` - '+parseInt(m.amount)+' WHERE `steamid` = '+pool.escape(user.steamid), function(err2, row2) {
				if(err2) {
					logger.error('Error in withdraw');
					logger.debug(err);
					socket.emit('message', {
						type: 'error',
						enable: true,
						error: 'You dont have enough points'
					});
					return;
				}
				query('INSERT INTO `bets` SET `user` = '+pool.escape(user.steamid)+', `amount` = '+pool.escape(m.amount)+', `lower` = '+pool.escape(m.lower)+', `upper` = '+pool.escape(m.upper), function(err3, row3) {
					if(err3) {
						logger.error('Error in DB');
						logger.debug(err);
						return;
					}
					var end = new Date();
					if(usersBr[user.steamid] === undefined) {
						usersBr[user.steamid] = 1;
					} else {
						usersBr[user.steamid]++;
					}
					if(usersAmount[user.steamid] === undefined) {
						usersAmount[user.steamid] = {
							'0-0': 0,
							'1-7': 0,
							'8-14': 0
						};
					}
					usersAmount[user.steamid][m.lower+'-'+m.upper] += parseInt(m.amount);
					currentSums[m.lower+'-'+m.upper] += m.amount;
					socket.emit('message', {
						type: 'betconfirm',
						bet: {
							betid: row3.insertId,
							lower: m.lower,
							upper: m.upper,
							amount: usersAmount[user.steamid][m.lower+'-'+m.upper]
						},
						balance: row[0].balance-m.amount,
						mybr: usersBr[user.steamid],
						br: br,
						exec: (end.getTime()-start_time.getTime()).toFixed(3)
					});
					users[user.steamid].balance = row[0].balance-m.amount;
					io.sockets.emit('message', {
						type: 'bet',
						bet: {
							amount: usersAmount[user.steamid][m.lower+'-'+m.upper],
							betid: row3.insertId,
							icon: user.avatar,
							lower: m.lower,
							name: user.name,
							rollid: currentRollid,
							upper: m.upper,
							user: user.steamid,
							won: null
						},
						sums: {
							0: currentSums['0-0'],
							1: currentSums['1-7'],
							2: currentSums['8-14'],
						}
					});
					currentBets.push({
						amount: m.amount,
						betid: row3.insertId,
						icon: user.avatar,
						lower: m.lower,
						name: user.name,
						rollid: currentRollid,
						upper: m.upper,
						user: user.steamid,
					});
					logger.debug('Bet #'+row3.insertId+' Ammount: '+m.amount);
					checkTimer();
				})
			});
		} else {
			socket.emit('message', {
				type: 'error',
				enable: true,
				error: 'You dont have any money'
			});
		}
	});
}

function checkTimer() {
	if((currentBets.length > 0) && (timer == -1) && (!pause)) {
		logger.trace('Timer starting');
		timer = accept+wait;
		timerID = setInterval(function() {
			logger.trace('Timer: '+timer+' Site timer: '+(timer-wait));
			if (timer == wait) {
				pause = true;
				logger.trace('Pause included');
				var inprog = getRandomInt(0, (currentBets.length/4).toFixed(0));
				io.sockets.emit('message', {
					type: 'preroll',
					totalbets: currentBets.length-inprog,
					inprog: inprog,
					sums: {
						0: currentSums['0-0'],
						1: currentSums['1-7'],
						2: currentSums['8-14'],
					}
				});
			}
			if (timer == wait-2) {
				logger.trace('Timer: ');
				toWin(); // Выбираем победителя
			}
			if(timer == 0) {
				logger.trace('Reset');
				timer = accept+wait;
				currentBets = [];
				historyRolls.push({id: currentRollid, roll: roll});
				if(historyRolls.length > 10) historyRolls.slice(1);
				usersBr = {}; // сколько пользователи внесли
				usersAmount = {}; // сколько пользователи внесли монеток
				currentSums = {
					'0-0': 0,
					'1-7': 0,
					'8-14': 0
				};
				currentRollid = currentRollid+1;
				pause = false;
			}
			timer--;
		}, 1000);
	}
}

function toWin() {
	var sh = sha256(hash+'-'+currentRollid);
	roll = sh.substr(0, 8);
	roll = parseInt(roll, 16);
	roll = math.abs(roll) % 15;
	logger.trace('Rolled '+roll);
	var r = '';
	var s = q1;
	var wins = {
		'0-0': 0,
		'1-7': 0,
		'8-14': 0
	}
	if(roll == 0) { r = '0-0'; s = q2; wins['0-0'] = currentSums['0-0']*s; }
	if((roll > 0) && (roll < 8)) { r = '1-7'; wins['1-7'] = currentSums['1-7']*s; }
	if((roll > 7) && (roll < 15)) { r = '8-14'; wins['8-14'] = currentSums['8-14']*s; }
	logger.debug(currentBets);
	logger.debug(usersBr);
	logger.debug(usersAmount);
	logger.debug(currentSums);
	for(key in users) {
		if(usersAmount[key] === undefined) {
			var balance = null;
			var won = 0;
		} else {
			var balance = parseInt(users[key].balance)+usersAmount[key][r]*s;
			var won = usersAmount[key][r]*s;
		}
		if (io.sockets.connected[users[key].socket]) io.sockets.connected[users[key].socket].emit('message', {
			balance: balance,
			count: accept,
			nets: [{
					lower: 0,
					samount: currentSums['0-0'],
					swon: wins['0-0'],
					upper: 0
				}, {
					lower: 1,
					samount: currentSums['1-7'],
					swon: wins['1-7'],
					upper: 7
				}, {
					lower: 8,
					samount: currentSums['8-14'],
					swon: wins['8-14'],
					upper: 14
				}
			],
			roll: roll,
			rollid: currentRollid+1,
			type: "roll",
			wait: wait-2,
			wobble: getRandomArbitary(0, 1),
			won: won
		});
	}
	currentBets.forEach(function(itm) {
		if((roll >= itm.lower) && (roll <= itm.upper)) {
			logger.debug('Rate #'+itm.betid+' sum '+itm.amount+' win '+(itm.amount*s));
			query('UPDATE `users` SET `balance` = `balance` + '+itm.amount*s+' WHERE `steamid` = '+pool.escape(itm.user));
		}
	});
	query('UPDATE `rolls` SET `roll` = '+pool.escape(roll)+', `hash` = '+pool.escape(hash)+', `time` = '+pool.escape(time())+' WHERE `id` = '+pool.escape(currentRollid));
	query('INSERT INTO `rolls` SET `roll` = -1');
	updateHash();
}









/* */
var tagsToReplace = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;'
};

function replaceTag(tag) {
    return tagsToReplace[tag] || tag;
}

function safe_tags_replace(str) {
    return str.replace(/[&<>]/g, replaceTag);
}
Object.size = function(obj) {
	var size = 0,
		key;
	for (key in obj) {
		if (obj.hasOwnProperty(key)) size++;
	}
	return size;
};
function getRandomInt(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;
}
function getRandomArbitary(min, max) {
	return Math.random() * (max - min) + min;
}

function query(sql, callback) {
	if (typeof callback === 'undefined') {
		callback = function() {};
	}
	pool.getConnection(function(err, connection) {
		if(err) return callback(err);
		logger.info('DB Connection ID: '+connection.threadId);
		connection.query(sql, function(err, rows) {
			if(err) return callback(err);
			connection.release();
			return callback(null, rows);
		});
	});
}
function load() {
	query('SET NAMES utf8');
	query('SELECT `id` FROM `rolls` ORDER BY `id` DESC LIMIT 1', function(err, row) {
		if((err) || (!row.length)) {
			logger.error('Cant get number from the last game');
			logger.debug(err);
			process.exit(0);
			return;
		}
		currentRollid = row[0].id;
		logger.trace('Roll '+currentRollid);
	});
	loadHistory();
	setTimeout(function() { io.listen(8080); }, 3000);
}
function loadHistory() {
	query('SELECT * FROM `rolls` ORDER BY `id` LIMIT 10', function(err, row) {
		if(err) {
			logger.error('Cant load betting history');
			logger.debug(err);
			process.exit(0);
		}
		logger.trace('Sucesfully updated history');
		row.forEach(function(itm) {
			if(itm.roll != -1) historyRolls.push(itm);
		});
	});
}

function time() {
	return parseInt(new Date().getTime()/1000)
}