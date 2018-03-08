"use strict";
var CASEW = 1050;
var LAST_BET = 0;
var MAX_BET = 0;
var HIDEG = false;
var USER = "";
var RANK = 0;
var ROUND = 0;
var HOST = "92.222.85.209:8080";
var SOCKET = null;
var showbets = true;

function todongers(x) {
	if ($("#settings_dongers").is(":checked")) {
		return (x / 1000);
	}
	return x;
}

function todongersb(x) {
	if ($("#settings_dongers").is(":checked")) {
		return (x / 1000).toFixed(3);
	}
	return x;
}
var snapX = 0;
var R = 0.999;
var S = 0.01;
var tf = 0;
var vi = 0;
var animStart = 0;
var isMoving = false;
var LOGR = Math.log(R);
var $CASE = null;
var $BANNER = null;
var $CHATAREA = null;
var SCROLL = true;
var LANG = 1;
var IGNORE = [];
var sounds_rolling = new Audio('/template/sounds/rolling.wav');
sounds_rolling.volume = 0.5;
var sounds_tone = new Audio('/template/sounds/tone.wav');
sounds_tone.volume = 0.75;

function play_sound(x) {
	var conf = $("#settings_sounds").is(":checked");
	if (conf) {
		if (x == "roll") {
			sounds_rolling.play();
		} else if (x == "finish") {
			sounds_tone.play();
		}
	}
}

function snapRender(x, wobble) {
    CASEW = $("#case").width();
    if (isMoving) return;
    else if (typeof x === 'undefined') view(snapX);
    else {
        var order = [1, 14, 2, 13, 3, 12, 4, 0, 11, 5, 10, 6, 9, 7, 8];
        var index = 0;
        for (var i = 0; i < order.length; i++) {
            if (x == order[i]) {
                index = i;
                break
            }
        }
        var max = 32;
        var min = -32;
        var w = Math.floor(wobble * (max - min + 1) + min);
        var dist = index * 70 + 36 + w;
        dist += 1050 * 5;
        snapX = dist;
        view(snapX)
    }
}

function spin(m) {
    var x = m.roll;
    play_sound("roll");
    var order = [1, 14, 2, 13, 3, 12, 4, 0, 11, 5, 10, 6, 9, 7, 8];
    var index = 0;
    for (var i = 0; i < order.length; i++) {
        if (x == order[i]) {
            index = i;
            break
        }
    }
    var max = 32;
    var min = -32;
    var w = Math.floor(m.wobble * (max - min + 1) + min);
    var dist = index * 70 + 36 + w;
    dist += 1050 * 5;
    animStart = new Date().getTime();
    vi = getVi(dist);
    tf = getTf(vi);
    isMoving = true;
    setTimeout(function() {
        finishRoll(m, tf)
    }, tf);
    render()
}

function d_mod(vi, t) {
	return vi * (Math.pow(R, t) - 1) / LOGR;
}

function getTf(vi) {
	return (Math.log(S) - Math.log(vi)) / LOGR;
}

function getVi(df) {
	return S - df * LOGR;
}

function v(vi, t) {
	return vi * Math.pow(R, t);
}

function render() {
	var t = new Date().getTime() - animStart;
	if (t > tf)
		t = tf;
	var deg = d_mod(vi, t);
	view(deg);
	if (t < tf) {
		requestAnimationFrame(render);
	} else {
		snapX = deg;
		isMoving = false;
	}
}

function view(offset) {
	offset = -((offset + 1050 - CASEW / 2) % 1050);
	$CASE.css("background-position", offset + "px 0px");
}
jQuery.fn.extend({
	countTo: function(x, opts) {
		opts = opts || {};
		var dpf = "";
		var dolls = $("#settings_dongers").is(":checked");
		if (dolls) {
			dpf = "$";
			x = x / 1000;
		}
		var $this = $(this);
		var start = parseFloat($this.html());
		var delta = x - start;
		if (opts.color) {
			if (delta > 0) {
				$this.addClass("text-success");
			} else if (delta < 0) {
				$this.addClass("text-danger");
			}
		}
		var prefix = "";
		if (opts.keep && delta > 0) {
			prefix = "+";
		}
		var durd = delta;
		if (dolls) {
			durd *= 1000;
		}
		var dur = Math.min(400, Math.round(Math.abs(durd) / 500 * 400));
		$({
			count: start
		}).animate({
			count: x
		}, {
			duration: dur,
			step: function(val) {
				var vts = 0;
				if (dolls) {
					vts = val.toFixed(3);
				} else {
					vts = Math.floor(val);
				}
				$this.html("" + prefix + (vts));
			},
			complete: function() {
				if (!opts.keep) {
					$this.removeClass("text-success text-danger");
				}
				if (opts.callback) {
					opts.callback();
				}
			}
		});
	}
});

function cd(ms, cb) {
	$("#counter").finish().css("width", "100%");
	$("#counter").animate({
		width: "0%"
	}, {
		"duration": ms * 1000,
		"easing": "linear",
		progress: function(a, p, r) {
			var c = (r / 1000).toFixed(2);
			$BANNER.html("Rolling in " + c + "...");
		},
		complete: cb
	});
}

function send(msg) {
	if (SOCKET) {
		SOCKET.emit('mes', msg);
	}
}

function finishRoll(m, tf) {
	$BANNER.html("Rolled number " + m.roll + "!");
	addHist(m.roll, m.rollid);
	play_sound("finish");
	for (var i = 0; i < m.nets.length; i++) {
		$("#panel" + m.nets[i].lower + "-" + m.nets[i].upper).find(".total").countTo(m.nets[i].swon > 0 ? m.nets[i].swon : -m.nets[i].samount, {
			"color": true,
			"keep": true
		});
	}
	var cats = [
		[0, 0],
		[1, 7],
		[8, 14]
	];
	for (var i = 0; i < cats.length; i++) {
		var $mytotal = $("#panel" + cats[i][0] + "-" + cats[i][1]).find(".mytotal");
		if (m.roll >= cats[i][0] && m.roll <= cats[i][1]) {
			$mytotal.countTo(m.won, {
				"color": true,
				"keep": true
			});
		} else {
			var curr = parseFloat($mytotal.html());
			if ($("#settings_dongers").is(":checked")) {
				curr *= 1000;
			}
			$mytotal.countTo(-curr, {
				"color": true,
				"keep": true
			});
		}
	}
	if (m.balance != null) {
		$("#balance").countTo(m.balance, {
			"color": true
		});
		checkplus(m.balance);
	}
	setTimeout(function() {
		cd(m.count);
		$(".total,.mytotal").removeClass("text-success text-danger").html(0);
		$(".betlist li").remove();
		snapRender();
		$(".betButton").prop("disabled", false);
		showbets = true;
	}, m.wait * 1000 - tf);
}

function checkplus(balance) {
	if(balance < 20) {
		$('#oneplusbutton').show();
	} else {
		$('#oneplusbutton').hide();
	}
}

function addHist(roll, rollid) {
	var count = $("#past .ball").length;
	if (count >= 10) {
		$("#past .ball").first().remove();
	}
	if (roll == 0) {
		$("#past").append("<div data-rollid='" + rollid + "'class='ball ball-0'>" + roll + "</div>");
	} else if (roll <= 7) {
		$("#past").append("<div data-rollid='" + rollid + "'class='ball ball-1'>" + roll + "</div>");
	} else {
		$("#past").append("<div data-rollid='" + rollid + "'class='ball ball-8'>" + roll + "</div>");
	}
}

function onMessage(msg) {
	var m = msg;
	console.log(msg);
	if (m.type == "preroll") {
			$("#counter").finish();
			$("#banner").html("Confirming " + m.totalbets + "/" + (m.totalbets + m.inprog) + " total bets...");
            $("#panel0-0-t .total").countTo(m.sums[0]);
            $("#panel1-7-t .total").countTo(m.sums[1]);
            $("#panel8-14-t .total").countTo(m.sums[2]);
		try {
			tinysort("#panel1-7-t .betlist>li", {
				data: "amount",
				order: "desc"
			});
		} catch (e) {}
		try {
			tinysort("#panel8-14-t .betlist>li", {
				data: "amount",
				order: "desc"
			});
		} catch (e) {}
		try {
			tinysort("#panel0-0-t .betlist>li", {
				data: "amount",
				order: "desc"
			});
		} catch (e) {}
	} else if (m.type == "roll") {
		$(".betButton").prop("disabled", true);
		$("#counter").finish();
		$("#banner").html("***ROLLING***");
		ROUND = m.rollid;
		showbets = false;
		spin(m);
	} else if (m.type == "chat") {
		chat("player", m.msg, m.name, m.icon, m.user, m.rank, m.lang, m.hide);
	} else if (m.type == "hello") {
		cd(m.count);
		USER = m.user; // steamid
		RANK = m.rank; // rank admin
		$("#balance").countTo(m.balance);
		checkplus(m.balance);
		var last = 0;
		for (var i = 0; i < m.rolls.length; i++) {
			addHist(m.rolls[i].roll, m.rolls[i].rollid);
			last = m.rolls[i].roll;
			ROUND = m.rolls[i].rollid;
		}
		snapRender(last, m.last_wobble);
		MAX_BET = m.maxbet;
		chat("alert", "Minimum bet: " + m.minbet + " coins, " + "Maximum bet: " + formatNum(MAX_BET) + " coins, " + " Bets per round: " + m.br + ", Round time : " + m.accept + " sec, " + " Chat delay: " + m.chat + " sec. ");
        } else if (m.type == "bet") {
            if (showbets) {
                addBet(m.bet);
                $("#panel0-0-t .total").countTo(m.sums[0]);
                $("#panel1-7-t .total").countTo(m.sums[1]);
                $("#panel8-14-t .total").countTo(m.sums[2])
            }
	} else if (m.type == "betconfirm") {
		$("#panel" + m.bet.lower + "-" + m.bet.upper + "-m .mytotal").countTo(m.bet.amount);
		$("#balance").countTo(m.balance, {
			"color": true
		});
		checkplus(m.balance);
		$(".betButton").prop("disabled", false);
		chat("alert", "Bet #" + m.bet.betid + " confirmed " + m.mybr + "/" + m.br + " (" + (m.exec / 1000) + " sec) ");
	} else if (m.type == "error") {
		chat("error", m.error);
		if (m.enable) {
			$(".betButton").prop("disabled", false);
		}
	} else if (m.type == "alert") {
		chat("alert", m.alert);
		if (m.maxbet) {
			MAX_BET = m.maxbet;
		}
		if (!isNaN(m.balance)) {
			console.log("setting balance = %s", m.balance);
			$("#balance").countTo(m.balance, {
				"color": true
			});
			checkplus(m.balance);
		}
	} else if (m.type == "logins") {
		$("#isonline").html(m.count);
	} else if (m.type == "balance") {
		$("#balance").fadeOut(100).html(todongersb(m.balance)).fadeIn(100);
		checkplus(m.balance);
	}
}

function addBet(bet) {
	var betid = bet.user + "-" + bet.lower;
	var pid = "#panel" + bet.lower + "-" + bet.upper;
	var $panel = $(pid);
	$panel.find("#" + betid).remove();
	var f = "<li class='list-group-item' id='{0}' data-amount='{1}'>";
	f += "<div style='overflow: hidden;line-height:32px'>";
	f += "<div class='pull-left'><img class='rounded' src='https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars{2}'> <b>{3}</b></div>";
	f += "<div class='amount pull-right'>{4}</div>";
	f += "</div></li>";
	var $li = $(f.format(betid, bet.amount, bet.icon, bet.name, todongersb(bet.amount)));
	$li.hide().prependTo($panel.find(".betlist")).slideDown("fast", function() {
		snapRender();
	});
}

function connect() {
	if(!SOCKET) {
		chat("italic", "Generating token...");
		var hash = getCookie('hash');
		if(!hash) {
			chat("italic", "Please, sing through steam.");
		} else {
			chat("italic", "Connecting...");
			SOCKET = io(HOST);
			SOCKET.on('connect', function(msg) {
				chat("italic", "Connected!");
				SOCKET.emit('hash', hash);
			});
			SOCKET.on('connect_error', function(msg) {
				chat("italic", "Conection lost...");
			});
			SOCKET.on('message', function(msg) {
				onMessage(msg);
			});
		}
	} else {
		console.log("Error: connection already exists.");
	}
}

function emotes(str) {
	var a = ["deIlluminati", "KappaRoss", "KappaPride", "BibleThump", "Kappa", "Keepo", "Kreygasm", "PJSalt", "PogChamp", "SMOrc", "CO", "CA", "Tb", "offFire", "Fire", "rip", "lovegreen", "heart", "FailFish"];
	for (var i = 0; i < a.length; i++) {
		str = str.replace(new RegExp(a[i] + "( |$)", "g"), "<img src='/template/img/twitch/" + a[i] + ".png'> ");
	}
	return str;
}

function chat(x, msg, name, icon, steamid, rank, lang, hide) {
	if (IGNORE.indexOf(String(steamid)) > -1) {
		console.log("ignored:" + msg);
		return;
	}
	if (lang == LANG || x == "italic" || x == "error" || x == "alert") {
		var ele = document.getElementById("chatArea");
		msg = msg.replace(/(<|>)/g, '');
		msg = emotes(msg);
		var toChat = "";
        if (x == "italic") toChat = "<div class='chat-msg'><img class='chat-img rounded' data-steamid='0' data-name='System' src='https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb.jpg'><div><span>System</span></div> <div>" + msg + "</div></div>";
        else if (x == "error") toChat = "<div class='chat-msg'><img class='chat-img rounded' data-steamid='0' data-name='System' src='https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb.jpg'><div><span>Error</span></div> <div class='text-danger'>" + msg + "</div></div>";
        else if (x == "alert") toChat = "<div class='chat-msg'><img class='chat-img rounded' data-steamid='0' data-name='System' src='https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb.jpg'><div><span>Alert</span></div> <div class='text-success'>" + msg + "</div></div>";
        else if (x == "player") {
			var aclass = "chat-link";
			if (rank == 100) {
				aclass = "chat-link-mod";
				name = "[Owner] " + name;
			} else if (rank == 1) {
				aclass = "chat-link-pmod";
				name = "[Mod] " + name;
			} else if (rank == -1) {
				aclass = "chat-link-streamer";
				name = "[Streamer] " + name;
			} else if (rank == -2) {
				aclass = "chat-link-vet";
				name = "[Veteran] " + name;
			} else if (rank == -3) {
				aclass = "chat-link-pro";
				name = "[Pro] " + name;
			} else if (rank == -4) {
				aclass = "chat-link-yt";
				name = "[Youtuber] " + name;
			} else if (rank == -5) {
				aclass = "chat-link-mod";
				name = "[Coder] " + name;
			}

			var link = "http://steamcommunity.com/profiles/" + steamid;
			toChat = "<div class='chat-msg'><img class='chat-img rounded' data-steamid='" + steamid + "' data-name='" + name + "' src='https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars" + icon + "'>";
			if (hide) {
				toChat += "<div><span class='" + aclass + "'>" + name + "</span></div><div>" + msg + "</div>";
			} else {
				toChat += "<div><a href='" + link + "' target='_blank'><span class='" + aclass + "'>" + name + "</span></a></div><div>" + msg + "</div>";
			}
		}
		$CHATAREA.append(toChat);
		if (SCROLL) {
			var curr = $CHATAREA.children().length;
			if (curr > 75) {
				var rem = curr - 75;
				$CHATAREA.children().slice(0, rem).remove();
			}
			$CHATAREA.scrollTop($CHATAREA[0].scrollHeight);
		}
		if (SCROLL && !$(".side-icon[data-tab='1']").hasClass("active")) {
			var curr = parseInt($("#newMsg").html()) || 0;
			$("#newMsg").html(curr + 1);
		}
	}
}
$(document).ready(function() {
	$CASE = $("#case");
	$BANNER = $("#banner");
	$CHATAREA = $("#chatArea");
	connect();
	if ($("#settings_dongers").is(":checked")) {
		$("#dongers").html("$");
	}
	$("#lang").on("change", function() {
		LANG = $(this).val();
		chat("alert", "You moved to room: " + $(this).find("option:selected").text());
	});
	$("#scroll").on("change", function() {
		SCROLL = !$(this).is(":checked");
	});
	$(window).resize(function() {
		snapRender();
	});
	$("#chatForm").on("submit", function() {
		var msg = $("#chatMessage").val();
		if (msg) {
			var res = null;
			if (res = /^\/send ([0-9]*) ([0-9]*)/.exec(msg)) {
				bootbox.confirm("You are going to send " + res[2] + " to the Steam ID " + res[1] + " - are you sure?", function(result) {
					if (result) {
						send({
							"type": "chat",
							"msg": msg,
							"lang": LANG
						});
						$("#chatMessage").val("");
					}
				});
			} else {
				var hideme = $("#settings_hideme").is(":checked");
				send({
					"type": "chat",
					"msg": msg,
					"lang": LANG,
					"hide": hideme,
				});
				$("#chatMessage").val("");
			}
		}
		return false;
	});
	$(document).on("click", ".ball", function() {
		var rollid = $(this).data("rollid");
	});
	$(".betButton").on("click", function() {
		var lower = $(this).data("lower");
		var upper = $(this).data("upper");
		var amount = str2int($("#betAmount").val());
		if ($("#settings_dongers").is(":checked")) {
			amount = amount * 1000;
		}
		amount = Math.floor(amount);
		var conf = $("#settings_confirm").is(":checked");
		if (conf && amount > 10000) {
			var pressed = false;
			bootbox.confirm("Are you sure you want to bet " + formatNum(amount) + " credits?<br><br><i>You can disable this in settings.</i>", function(result) {
				if (result && !pressed) {
					pressed = true;
					send({
						"type": "bet",
						"amount": amount,
						"lower": lower,
						"upper": upper,
						"round": ROUND
					});
					LAST_BET = amount;
					$(this).prop("disabled", true);
				}
			});
		} else {
			send({
				"type": "bet",
				"amount": amount,
				"lower": lower,
				"upper": upper,
				"round": ROUND
			});
			LAST_BET = amount;
			$(this).prop("disabled", true);
		}
		return false;
	});
	$('#oneplusbutton').on("click", function() {
		console.log('+1');
		send({
			"type": "plus"
		});
	});
	$(document).on("click", ".betshort", function() {
		var bet_amount = str2int($("#betAmount").val());
		var action = $(this).data("action");
		if (action == "clear") {
			bet_amount = 0;
		} else if (action == "double") {
			bet_amount *= 2;
		} else if (action == "half") {
			bet_amount /= 2;
		} else if (action == "max") {
			var MX = MAX_BET;
			if ($("#settings_dongers").is(":checked")) {
				MX = MAX_BET / 1000;
			}
			bet_amount = Math.min(str2int($("#balance").html()), MX);
		} else if (action == "last") {
			bet_amount = 0;
		} else {
			bet_amount += parseInt(action);
		}
		$("#betAmount").val(bet_amount);
	});
	$("#getbal").on("click", function() {
		send({
			"type": "balance"
		});
	});
	$("button.close").on("click", function() {
		$(this).parent().addClass("hidden");
	});
	$(document).on("contextmenu", ".chat-img", function(e) {
		if (e.ctrlKey) return;
		$("#contextMenu [data-act=1]").hide();
		$("#contextMenu [data-act=2]").hide();
		if (RANK == 100) {
			$("#contextMenu [data-act=1]").show();
			$("#contextMenu [data-act=2]").show();
		} else if (RANK == 1) {
			$("#contextMenu [data-act=1]").show();
		}
		e.preventDefault();
		var steamid = $(this).data("steamid");
		var name = $(this).data("name");
		$("#contextMenu [data-act=0]").html(name);
		var $menu = $("#contextMenu");
		$menu.show().css({
			position: "absolute",
			left: getMenuPosition(e.clientX, 'width', 'scrollLeft'),
			top: getMenuPosition(e.clientY, 'height', 'scrollTop')
		}).off("click").on("click", "a", function(e) {
			var act = $(this).data("act");
			e.preventDefault();
			$menu.hide();
			if (act == 0) {
				var curr = $("#chatMessage").val(steamid);
			} else if (act == 1) {
				var curr = $("#chatMessage").val("/mute " + steamid + " ");
			} else if (act == 2) {
				var curr = $("#chatMessage").val("/kick " + steamid + " ");
			} else if (act == 3) {
				var curr = $("#chatMessage").val("/send " + steamid + " ");
			} else if (act == 4) {
				IGNORE.push(String(steamid));
				chat("alert", steamid + " Ignored.");
			}
			$("#chatMessage").focus();
		});
	});
	$(document).on("click", function() {
		$("#contextMenu").hide();
	});
	$(".side-icon").on("click", function(e) {
		e.preventDefault();
		var tab = $(this).data("tab");
		if ($(this).hasClass("active")) {
			$(".side-icon").removeClass("active");
			$(".tab-group").addClass("hidden");
			$("#mainpage").css("margin-left", "50px");
			$("#pullout").addClass("hidden");
		} else {
			$(".side-icon").removeClass("active");
			$(".tab-group").addClass("hidden");
			$(this).addClass("active");
			$("#tab" + tab).removeClass("hidden");
			$("#mainpage").css("margin-left", "450px");
			$("#pullout").removeClass("hidden");
			if (tab == 1) {
				$("#newMsg").html("");
			}
		}
		snapRender();
		return false;
	});
    $(".smiles li img").on("click", function() {
        $("#chatMessage").val($("#chatMessage").val() + $(this).data("smile") + " ")
    });
    $('.clearChat').on("click", function() {
        $('#chatArea').html("<div><b class='text-success'>Chat cleared!</b></div>")
    });
    $(document).on("click", ".deleteMsg", function(e) {
        var t = $(this).data("id");
        send({
            type: "delmsg",
            id: t
        })
    });
    $(".side-icon[data-tab='1']").trigger("click")
});

function getAbscentPhrases(msg) {
    var phrases = ["hello", 1, "simba"];
    for (var i = 0; i < phrases.length; i++) {
        if (msg.toLowerCase().indexOf(phrases[i]) + 1) {
            return 1
        }
    }
    return 0
}

function changeLang(id) {
    LANG = $(this).val();
    $(".lang-select").html($(".language > li").eq(id - 1).find("a").html());
    chat("alert", "Changed to the room: " + $(".language > li").eq(id - 1).find("a").html())
}

function getMenuPosition(mouse, direction, scrollDir) {
	var win = $(window)[direction](),
		scroll = $(window)[scrollDir](),
		menu = $("#contextMenu")[direction](),
		position = mouse + scroll;
	if (mouse + menu > win && menu < mouse)
		position -= menu;
	return position;
}

function str2int(s) {
	s = s.replace(/,/g, "");
	s = s.toLowerCase();
	var i = parseFloat(s);
	if (isNaN(i)) {
		return 0;
	} else if (s.charAt(s.length - 1) == "k") {
		i *= 1000;
	} else if (s.charAt(s.length - 1) == "m") {
		i *= 1000000;
	} else if (s.charAt(s.length - 1) == "b") {
		i *= 1000000000;
	}
	return i;
}