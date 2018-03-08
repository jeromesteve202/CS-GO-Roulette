<?php
if (!isset($_GET['page'])) {
	header('Location: /main');
	exit();
}

ini_set('display_errors','Off');
try {
	$db = new PDO('mysql:host=localhost;dbname=csgo', 'root', 'Tome', array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
} catch (PDOException $e) {
	exit($e->getMessage());
}

if (isset($_COOKIE['hash'])) {
	$sql = $db->query("SELECT * FROM `users` WHERE `hash` = " . $db->quote($_COOKIE['hash']));
	if ($sql->rowCount() != 0) {
		$row = $sql->fetch();
		$user = $row;
	}
}

$min = 150;
$ip = 'localhost';
$referal_summa = 20;

switch ($_GET['page']) {
	case 'main':
		$page = getTemplate('main.tpl', array('user'=>$user));
		echo $page;
		break;

	case 'deposit':
		$page = getTemplate('deposit.tpl', array('user'=>$user));
		echo $page;
		break;

	case 'tos':
		$page = getTemplate('tos.tpl', array('user'=>$user));
		echo $page;
		break;

	case 'support':
		$sql = $db->query('SELECT * FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` = 0');
		$row = $sql->fetch();
		$ticket = $row;
		if(count($ticket) > 0) {
			$sql = $db->query('SELECT * FROM `messages` WHERE `ticket` = '.$db->quote($ticket['id']));
			$row = $sql->fetchAll();
			$ticket['messages'] = $row;
		}
		$sql = $db->query('SELECT COUNT(`id`) FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` > 0');
		$row = $sql->fetch();
		$closed = $row['COUNT(`id`)'];
		$tickets = array();
		$sql = $db->query('SELECT * FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` > 0');
		while ($row = $sql->fetch()) {
			$s = $db->query('SELECT `message`, `user` FROM `messages` WHERE `ticket` = '.$db->quote($row['id']));
			$r = $s->fetchAll();
			$tickets[] = array('title'=>$row['title'],'messages'=>$r);
		}
		$page = getTemplate('support.tpl', array('user'=>$user,'ticket'=>$ticket,'open'=>(count($ticket) > 1)?1:0,'closed'=>$closed,'tickets'=>$tickets));
		echo $page;
		break;

	case 'support_new':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the support.')));
		$tid = $_POST['tid'];
		$title = $_POST['title'];
		$body = $_POST['reply'];
		$close = $_POST['close'];
		$cat = $_POST['cat'];
		$flag = $_POST['flag'];
		$lmao = $_POST['lmao'];
		if($tid == 0) {
			if((strlen($title) < 0) || (strlen($title) > 256)) exit(json_encode(array('success'=>false, 'error'=>'Title < 0 or > 256.')));
			if(($cat < 0) || ($cat > 4)) exit(json_encode(array('success'=>false, 'error'=>'Department cannot be left blank.')));
			if((strlen($body) < 0) || (strlen($body) > 2056)) exit(json_encode(array('success'=>false, 'error'=>'Description cannot be left blank.')));
			$sql = $db->query('SELECT COUNT(`id`) FROM `tickets` WHERE `user` = '.$db->quote($user['steamid']).' AND `status` = 0');
			$row = $sql->fetch();
			$count = $row['COUNT(`id`)'];
			if($count != 0) exit(json_encode(array('success'=>false, 'error'=>'You already have a pending support ticket.')));
			$db->exec('INSERT INTO `tickets` SET `time` = '.$db->quote(time()).', `user` = '.$db->quote($user['steamid']).', `cat` = '.$db->quote($cat).', `title` = '.$db->quote($title));
			$id = $db->lastInsertId();
			$db->exec('INSERT INTO `messages` SET `ticket` = '.$db->quote($id).', `message` = '.$db->quote($body).', `user` = '.$db->quote($user['steamid']).', `time` = '.$db->quote(time()));
			exit(json_encode(array('success'=>true,'msg'=>'Thank you - your ticket has been submitted ('.$id.')')));
		} else {
			$sql = $db->query('SELECT * FROM `tickets` WHERE `id` = '.$db->quote($tid).' AND `user` = '.$db->quote($user['steamid']));
			if($sql->rowCount() > 0) {
				$row = $sql->fetch();
				if($close == 1) {
					$db->exec('UPDATE `tickets` SET `status` = 1 WHERE `id` = '.$db->quote($tid));
					exit(json_encode(array('success'=>true,'msg'=>'[CLOSED]')));
				}
				$db->exec('INSERT INTO `messages` SET `ticket` = '.$db->quote($tid).', `message` = '.$db->quote($body).', `user` = '.$db->quote($user['steamid']).', `time` = '.$db->quote(time()));
				exit(json_encode(array('success'=>true,'msg'=>'Response added.')));
			}
		}
		break;

	case 'rolls':
		if(isset($_GET['id'])) {
			$id = $_GET['id'];
			if(!preg_match('/^[0-9]+$/', $id)) exit();
			$sql = $db->query('SELECT * FROM `hash` WHERE `id` = '.$db->quote($id));
			$row = $sql->fetch();
			$sql = $db->query('SELECT * FROM `rolls` WHERE `hash` = '.$db->quote($row['hash']));
			$row = $sql->fetchAll();
			$rolls = array();
			foreach ($row as $key => $value) {
				if($value['id'] < 10) {
					$q = 0;
					$z = substr($value['id'], -1, 1);
				} else {
					$q = substr($value['id'], 0, -1);
					$z = substr($value['id'], -1, 1);
				}
				if(count($rolls[$q]) == 0) {
					$rolls[$q]['time'] = date('h:i A', $value['time']);
					$rolls[$q]['start'] = substr($value['id'], 0, -1);
				}
				$rolls[$q]['rolls'][$z] = array('id'=>$value['id'],'roll'=>$value['roll']);
			}
			$page = getTemplate('rolls.tpl', array('user'=>$user,'rolls'=>$rolls));
		} else {
			$sql = $db->query('SELECT * FROM `hash` ORDER BY `id` DESC');
			$row = $sql->fetchAll();
			$rolls = array();
			foreach ($row as $key => $value) {
				$s = $db->query('SELECT MIN(`id`) AS min, MAX(`id`) AS max FROM `rolls` WHERE `hash` = '.$db->quote($value['hash']));
				$r = $s->fetch();
				$rolls[] = array('id'=>$value['id'],'date'=>date('Y-m-d', $value['time']),'seed'=>$value['hash'],'rolls'=>$r['min'].'-'.$r['max'],'time'=>$value['time']);
			}
			$page = getTemplate('rolls.tpl', array('user'=>$user,'rolls'=>$rolls));
		}
		echo $page;
		break;

	case 'faq':
		$page = getTemplate('faq.tpl', array('user'=>$user));
		echo $page;
		break;

	case 'affiliates':
		$affiliates = array();
		$sql = $db->query('SELECT `code` FROM `codes` WHERE `user` = '.$db->quote($user['steamid']));
		if($sql->rowCount() == 0) {
			$affiliates = array(
				'visitors' => 0,
				'total_bet' => 0,
				'lifetime_earnings' => 0,
				'available' => 0,
				'level' => "<b style='color:#965A38'><i class='fa fa-star'></i> Bronze</b> (1 coin per 300 bet)",
				'depositors' => "0/50 to silver",
				'code' => '(You dont have promocode)'
				);
		} else {
			$row = $sql->fetch();
			$affiliates['code'] = $row['code'];
			$sql = $db->query('SELECT * FROM `users` WHERE `referral` = '.$db->quote($user['steamid']));
			$reffersN = $sql->fetchAll();
			$reffers = array();
			$affiliates['visitors'] = 0;
			$count = 0;
			$affiliates['total_bet'] = 0;
			foreach ($reffersN as $key => $value) {
				$sql = $db->query('SELECT SUM(`amount`) AS amount FROM `bets` WHERE `user` = '.$db->quote($value['steamid']));
				$row = $sql->fetch();
				if($row['amount'] == 0)
					$affiliates['visitors']++;
				else
					$count++;
				$affiliates['total_bet'] += $row['amount'];
				$s = $db->query('SELECT SUM(`amount`) AS amount FROM `bets` WHERE `user` = '.$db->quote($value['steamid']).' AND `collect` = 0');
				$r = $s->fetch();
				$reffers[] = array('player'=>substr_replace($value['steamid'], '*************', 0, 13),'total_bet'=>$row['amount'],'collect_coins'=>$r['amount'],'comission'=>0);
			}
			if($count < 50) {
				$affiliates['level'] = "<b style='color:#965A38'><i class='fa fa-star'></i> Silver IV</b> (1 coin per 300 bet)";
				$affiliates['depositors'] = $count."/50 to Legendary Eagle";
				$s = 300;
			} elseif($count > 50) {
				$affiliates['level'] = "<b style='color:#A9A9A9'><i class='fa fa-star'></i> Legendary Eagle</b> (1 coin per 200 bet)";
				$affiliates['depositors'] = $count."/200 to Global elite";
				$s = 200;
			} elseif($count > 200) {
				$affiliates['level'] = "<b style='color:#FFD700'><i class='fa fa-star'></i> Global elite</b> (1 coin per 100 bet)";
				$affiliates['depositors'] = $count."/∞ to ∞";
				$s = 100;
			}
			$affiliates['available'] = 0;
			$affiliates['lifetime_earnings'] = 0;
			foreach ($reffers as $key => $value) {
				$reffers[$key]['comission'] = round($value['total_bet']/$s, 0);
				$affiliates['available'] += round($value['collect_coins']/$s, 0);
				$affiliates['lifetime_earnings'] += round($value['total_bet']/$s, 0)-round($value['collect_coins']/$s, 0);
			}
			$affiliates['reffers'] = $reffers;
		}
		$page = getTemplate('affiliates.tpl', array('user'=>$user, 'affiliates'=>$affiliates));
		echo $page;
		break;

	case 'changecode':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the changecode.')));
		$code = $_POST['code'];
		if(!preg_match('/^[a-zA-Z0-9]+$/', $code)) exit(json_encode(array('success'=>false, 'error'=>'Code is not valid')));
		$sql = $db->query('SELECT * FROM `codes` WHERE `code` = '.$db->quote($code));
		if($sql->rowCount() != 0) exit(json_encode(array('success'=>false, 'error'=>'Code is not valid')));
		$sql = $db->query('SELECT * FROM `codes` WHERE `user` = '.$db->quote($user['steamid']));
		if($sql->rowCount() == 0) {
			$db->exec('INSERT INTO `codes` SET `code` = '.$db->quote($code).', `user` = '.$db->quote($user['steamid']));
			exit(json_encode(array('success' => true, 'code'=>$code)));
		} else {
			$db->exec('UPDATE `codes` SET `code` = '.$db->quote($code).' WHERE `user` = '.$db->quote($user['steamid']));
			exit(json_encode(array('success' => true, 'code'=>$code)));
		}
		break;

	case 'collect':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the collect.')));
		$sql = $db->query('SELECT * FROM `users` WHERE `referral` = '.$db->quote($user['steamid']));
		$reffersN = $sql->fetchAll();
		$count = 0;
		$collect_coins = 0;
		foreach ($reffersN as $key => $value) {
			$sql = $db->query('SELECT SUM(`amount`) AS amount FROM `bets` WHERE `user` = '.$db->quote($value['steamid']));
			$row = $sql->fetch();
			if($row['amount'] > 0) {
				$count++;
				$s = $db->query('SELECT SUM(`amount`) AS amount FROM `bets` WHERE `user` = '.$db->quote($value['steamid']).' AND `collect` = 0');
				$r = $s->fetch();
				$db->exec('UPDATE `bets` SET `collect` = 1 WHERE `user` = '.$db->quote($value['steamid']));
				$collect_coins += $r['amount'];
			}
		}
		if($count < 50) {
			$s = 300;
		} elseif($count > 50) {
			$s = 200;
		} elseif($count > 200) {
			$s = 100;
		}
		$collect_coins = round($collect_coins/$s, 0);
		$db->exec('UPDATE `users` SET `balance` = `balance` + '.$collect_coins.' WHERE `steamid` = '.$db->quote($user['steamid']));
		exit(json_encode(array('success'=>true, 'collected'=>$collect_coins)));
		break;

	case 'redeem':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the redeem.')));
		if($user['referral'] != '0') exit(json_encode(array('success'=>false, 'error'=>'You have already redeemed a code. Only 1 code allowed per account.', 'code'=>$user['referral'])));
		$out = curl('http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=C59002C6AF973D43E01CF7A4EC5EF3D9&steamid='.$user['steamid'].'&format=json');
		$out = json_decode($out, true);
		if(!$out['response']) exit(json_encode(array('success'=>false, 'error'=>'You profile is private')));
		$csgo = false;
		foreach ($out['response']['games'] as $key => $value) {
			if($value['appid'] == 730) $csgo = true;
		}
		if(!$csgo) exit(json_encode(array('success'=>false, 'error'=>'You dont have CS:GO.')));
		$code = $_GET['code'];
		if(!preg_match('/^[a-zA-Z0-9]+$/', $code)) {
			exit(json_encode(array('success'=>false, 'error'=>'Code is not valid')));
		} else {
			$sql = $db->query('SELECT * FROM `codes` WHERE `code` = '.$db->quote($code));
			if($sql->rowCount() != 0) {
				$row = $sql->fetch();
				if($row['user'] == $user['steamid']) exit(json_encode(array('success'=>false, 'error'=>'This is you referal code')));
				$db->exec('UPDATE `users` SET `referral` = '.$db->quote($row['user']).', `balance` = `balance` + '.$referal_summa.' WHERE `steamid` = '.$db->quote($user['steamid']));
				exit(json_encode(array('success'=>true, 'credits'=>$referal_summa)));
			} else {
				exit(json_encode(array('success'=>false, 'error'=>'Code not found')));
			}
		}
		break;

	case 'withdraw':
		$sql = $db->query('SELECT `id` FROM `bots`');
		$ids = array();
		while ($row = $sql->fetch()) {
			$ids[] = $row['id'];
		}
		$page = getTemplate('withdraw.tpl', array('user'=>$user,'bots'=>$ids));
		echo $page;
		break;

	case 'transfers':
		$sql = $db->query('SELECT * FROM `transfers` WHERE `to1` = '.$db->quote($user['steamid']).' OR `from1` = '.$db->quote($user['steamid']));
		$row = $sql->fetchAll(PDO::FETCH_ASSOC);
		$page = getTemplate('transfers.tpl', array('user'=>$user,'transfers'=>$row));
		echo $page;
		break;

	case 'offers':
		$sql = $db->query('SELECT * FROM `trades` WHERE `user` = '.$db->quote($user['steamid']));
		$row = $sql->fetchAll(PDO::FETCH_ASSOC);
		$page = getTemplate('offers.tpl', array('user'=>$user,'offers'=>$row));
		echo $page;
		break;

	case 'login':
		include 'openid.php';
		try
		{
			$openid = new LightOpenID('http://'.$_SERVER['SERVER_NAME'].'/');
			if (!$openid->mode) {
				$openid->identity = 'http://steamcommunity.com/openid/?l=russian';
				header('Location: ' . str_replace("csgobananas", "csgorebel", $openid->authUrl()));
			} elseif ($openid->mode == 'cancel') {
				echo '';
			} else {
				if ($openid->validate()) {

					$id = $openid->identity;
					$ptn = "/^http:\/\/steamcommunity\.com\/openid\/id\/(7[0-9]{15,25}+)$/";
					preg_match($ptn, $id, $matches);

					$url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=C59002C6AF973D43E01CF7A4EC5EF3D9&steamids=$matches[1]";
					$json_object = file_get_contents($url);
					$json_decoded = json_decode($json_object);
					foreach ($json_decoded->response->players as $player) {
						$steamid = $player->steamid;
						$name = $player->personaname;
						$avatar = $player->avatar;
					}

					$hash = md5($steamid . time() . rand(1, 50));
					$sql = $db->query("SELECT * FROM `users` WHERE `steamid` = '" . $steamid . "'");
					$row = $sql->fetchAll(PDO::FETCH_ASSOC);
					if (count($row) == 0) {
						$db->exec("INSERT INTO `users` (`hash`, `steamid`, `name`, `avatar`) VALUES ('" . $hash . "', '" . $steamid . "', " . $db->quote($name) . ", '" . $avatar . "')");
					} else {
						$db->exec("UPDATE `users` SET `hash` = '" . $hash . "', `name` = " . $db->quote($name) . ", `avatar` = '" . $avatar . "' WHERE `steamid` = '" . $steamid . "'");
					}
					setcookie('hash', $hash, time() + 3600 * 24 * 7, '/');
					header('Location: http://www.csgobananas.com/sets.php?id=' . $hash);
				}
			}
		} catch (ErrorException $e) {
			exit($e->getMessage());
		}
		break;

	case 'get_inv':
	if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the deposit.')));
		if((file_exists('cache/'.$user['steamid'].'.txt')) && (!isset($_GET['nocache']))) {
			$array = file_get_contents('cache/'.$user['steamid'].'.txt');
			$array = unserialize($array);
			$array['fromcache'] = true;
			if(isset($_COOKIE['tid'])) {
				$sql = $db->query('SELECT * FROM `trades` WHERE `id` = '.$db->quote($_COOKIE['tid']).' AND `status` = 0');
				if($sql->rowCount() != 0) {
					$row = $sql->fetch();
					$array['code'] = $row['code'];
					$array['amount'] = $row['summa'];
					$array['tid'] = $row['id'];
					$array['bot'] = "Bot #".$row['bot_id'];
				} else {
					setcookie("tid", "", time() - 3600, '/');
				}
			}
			exit(json_encode($array));
		}
		$prices = file_get_contents('prices.txt');
		$prices = json_decode($prices, true);
		$inv = curl('https://steamcommunity.com/profiles/'.$user['steamid'].'/inventory/json/730/2/');
		$inv = json_decode($inv, true);
		if($inv['success'] != 1) {
			exit(json_encode(array('error'=>'Your profile is private. Please <a href="http://steamcommunity.com/my/edit/settings" target="_blank">set your inventory to public</a> and <a href="javascript:loadLeft(\'nocache\')">try again</a>.')));
		}
		$items = array();
		foreach ($inv['rgInventory'] as $key => $value) {
			$id = $value['classid'].'_'.$value['instanceid'];
			$trade = $inv['rgDescriptions'][$id]['tradable'];
			if(!$trade) continue;
			$name = $inv['rgDescriptions'][$id]['market_hash_name'];
			$price = $prices['response']['items'][$name]['value']*10;
			$img = 'http://steamcommunity-a.akamaihd.net/economy/image/'.$inv['rgDescriptions'][$id]['icon_url'];
			if((preg_match('/(Souvenir)/', $name)) || ($price < $min)) {
				$price = 0;
				$reject = 'Junk';
			} else {
				$reject = 'unknown item';
			}
			$items[] = array(
				'assetid' => $value['id'],
				'bt_price' => "0.00",
				'img' => $img,
				'name' => $name,
				'price' => $price,
				'reject' => $reject,
				'sa_price' => $price,
				'steamid' => $user['steamid']);
		}

		$array = array(
			'error' => 'none',
			'fromcache' => false,
			'items' => $items,
			'success' => true);
		if(isset($_COOKIE['tid'])) {
			$sql = $db->query('SELECT * FROM `trades` WHERE `id` = '.$db->quote($_COOKIE['tid']).' AND `status` = 0');
			if($sql->rowCount() != 0) {
				$row = $sql->fetch();
				$array['code'] = $row['code'];
				$array['amount'] = $row['summa'];
				$array['tid'] = $row['id'];
				$array['bot'] = "Bot #".$row['bot_id'];
			} else {
				setcookie("tid", "", time() - 3600, '/');
			}
		}
		file_put_contents('cache/'.$user['steamid'].'.txt', serialize($array), LOCK_EX);
		exit(json_encode($array));
		break;

	case 'deposit_js1':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the deposit.')));
		if($_COOKIE['tid']) {
			exit(json_encode(array('success'=>false, 'error'=>'You isset active tradeoffer.')));
		}
		$sql = $db->query('SELECT `id`,`name` FROM `bots` ORDER BY rand() LIMIT 1');
		$row = $sql->fetch();
		$bot = $row['id'];
		$partner = extract_partner($_GET['tradeurl']);
		$token = extract_token($_GET['tradeurl']);
		setcookie('tradeurl', $_GET['tradeurl'], time() + 3600 * 24 * 7, '/');
		$out = curl('http://'.$ip.':'.(3000+$bot).'/sendTrade/?assetids='.$_GET['assetids'].'&partner='.$partner.'&token='.$token.'&checksum='.$_GET['checksum'].'&steamid='.$user['steamid']);
		$out = json_decode($out, true);
		$out['bot'] = $row['name'];
		if($out['success'] == true) {
			$db->exec('INSERT INTO `trades` SET `id` = '.$db->quote($out['tid']).', `bot_id` = '.$db->quote($bot).', `code` = '.$db->quote($out['code']).', `status` = 0, `user` = '.$db->quote($user['steamid']).', `summa` = '.$db->quote($_GET['checksum']).', `time` = '.$db->quote(time()));
			foreach ($out['items'] as $key => $value) {
				$db->exec('INSERT INTO `items` SET `trade` = '.$db->quote($out['tid']).', `market_hash_name` = '.$db->quote($value['market_hash_name']).', `img` = '.$db->quote($value['icon_url']).', `botid` = '.$db->quote($bot).', `time` = '.$db->quote(time()));
			}
			setcookie('tid', $out['tid'], time() + 3600 * 24 * 7, '/');
		}
		exit(json_encode($out));
		break;

	case 'deposit_js':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the deposit.')));
		if($_COOKIE['tid']) {
			exit(json_encode(array('success'=>false, 'error'=>'You isset active tradeoffer.')));
		}
		$sql = $db->query('SELECT `id`,`name` FROM `bots` ORDER BY rand() LIMIT 1');
		$row = $sql->fetch();
		$bot = $row['id'];
		$partner = extract_partner($_GET['tradeurl']);
		$token = extract_token($_GET['tradeurl']);
		setcookie('tradeurl', $_GET['tradeurl'], time() + 3600 * 24 * 7, '/');
		$checksum = intval($_GET['checksum']);
		$prices = file_get_contents('prices.txt');
		$prices = json_decode($prices, true);
		$out = curl('http://'.$ip.':'.(3000+$bot).'/sendTrade/?assetids='.$_GET['assetids'].'&partner='.$partner.'&token='.$token.'&checksum='.$_GET['checksum'].'&steamid='.$user['steamid']);
		$out = json_decode($out, true);
		$out['bot'] = $row['name'];
		if($out['success'] == true) {
			$s = 0;
			foreach ($out['items'] as $key => $value) {
				$db->exec('INSERT INTO `items` SET `trade` = '.$db->quote($out['tid']).', `market_hash_name` = '.$db->quote($value['market_hash_name']).', `img` = '.$db->quote($value['icon_url']).', `botid` = '.$db->quote($bot).', `time` = '.$db->quote(time()));
				$s += $prices['response']['items'][$value['market_hash_name']]['value']*10;
			}
			$db->exec('INSERT INTO `trades` SET `id` = '.$db->quote($out['tid']).', `bot_id` = '.$db->quote($bot).', `code` = '.$db->quote($out['code']).', `status` = 0, `user` = '.$db->quote($user['steamid']).', `summa` = '.$db->quote($s).', `time` = '.$db->quote(time()));
			$out['amount'] = $s;
			setcookie('tid', $out['tid'], time() + 3600 * 24 * 7, '/');
		}
		exit(json_encode($out));
		break;

	case 'confirm':
	if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the confirm.')));
		$tid = (int)$_GET['tid'];
		$sql = $db->query('SELECT * FROM `trades` WHERE `id` = '.$db->quote($tid));
		$row = $sql->fetch();
		$out = curl('http://'.$ip.':'.(3000+$row['bot_id']).'/checkTrade?tid='.$row['id']);
		$out = json_decode($out, true);
		if(($out['success'] == true) && ($out['action'] == 'accept') && ($row['status'] != 1)) {
			if($row['summa'] > 0) $db->exec('UPDATE `users` SET `balance` = `balance` + '.$row['summa'].' WHERE `steamid` = '.$db->quote($user['steamid']));
			if($row['summa'] > 0) $db->exec('UPDATE `items` SET `status` = 1 WHERE `trade` = '.$db->quote($row['id']));
			if($row['summa'] > 0) $db->exec('UPDATE `trades` SET `status` = 1 WHERE `id` = '.$db->quote($row['id']));
			setcookie("tid", "", time() - 3600, '/');
		} elseif(($out['success'] == true) && ($out['action'] == 'cross')) {
			setcookie("tid", "", time() - 3600, '/');
			$db->exec('DELETE FROM `items` WHERE `trade` = '.$db->quote($row['id']));
			$db->exec('DELETE FROM `trades` WHERE `id` = '.$db->quote($row['id']));
		} else {
			exit(json_encode(array('success'=>false, 'error'=>'Trade is in procces or the coins are already credited')));
		}
		exit(json_encode($out));
		break;

	case 'get_bank_safe':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the widthdraw.')));
		//if(($user['steamid'] != "76561198092088938") || ($user['steamid'] != "76561198025678566")) exit();
		$g = curl('https://www.google.com/recaptcha/api/siteverify?secret=6LcFKx4TAAAAAA5RfMEEYHfSFj3met8MV_FWsZ2a&response='.$_GET['g-recaptcha-response']);
		$g = json_decode($g, true);
		if($g['success'] == true) {
			$array = array('balance'=>$user['balance'],'error'=>'none','items'=>array(),'success'=>true);
			$sql = $db->query('SELECT * FROM `items` WHERE `status` = 1');
			$prices = file_get_contents('prices.txt');
			$prices = json_decode($prices, true);
			while ($row = $sql->fetch()) {
				$array['items'][] = array('botid'=>$row['botid'],'img'=>'http://steamcommunity-a.akamaihd.net/economy/image/'.$row['img'],'name'=>$row['market_hash_name'],'assetid'=>$row['id'],'price'=>$prices['response']['items'][$row['market_hash_name']]['value']*10,'reject'=>'unknown items');
			}
			exit(json_encode($array));
		}
		break;

	case 'withdraw_js':
		if(!$user) exit(json_encode(array('success'=>false, 'error'=>'You must login to access the widthdraw.')));
		$items = array();
		$assetids = explode(',', $_GET['assetids']);
		$sum = 0;
		$prices = file_get_contents('prices.txt');
		$prices = json_decode($prices, true);
		$norm_itms = '';
		foreach ($assetids as $key) {
			if($key == "") continue;
			$sql = $db->query('SELECT * FROM `items` WHERE `id` = '.$db->quote($key));
			$row = $sql->fetch();
			$items[$row['botid']] = $row['market_hash_name'];
			$sum += $prices['response']['items'][$row['market_hash_name']]['value']*10;
			$norm_itms = $norm_itms.$row['market_hash_name'].',';
		}
		$out = array('success'=>false,'error'=>'');
		if(count($items) > 1) {
			$out = array('success'=>false,'error'=>'You choose more bots');
		} elseif($user['balance'] < $sum) {
			$out = array('success'=>false,'error'=>'You dont have coins!');
		} else {
			reset($items);
			$bot = key($items);
			$s = $db->query('SELECT `name` FROM `bots` WHERE `id` = '.$db->quote($bot));
			$r = $s->fetch();
			$db->exec('UPDATE `users` SET `balance` = `balance` - '.$sum.' WHERE `steamid` = '.$user['steamid']);
			$partner = extract_partner($_GET['tradeurl']);
			$token = extract_token($_GET['tradeurl']);
			$out = curl('http://'.$ip.':'.(3000+$bot).'/sendTradeMe/?names='.urlencode($norm_itms).'&partner='.$partner.'&token='.$token.'&checksum='.$_GET['checksum'].'&steamid='.$user['steamid']);
			$out = json_decode($out, true);
			if($out['success'] == false) {
				$db->exec('UPDATE `users` SET `balance` = `balance` + '.$sum.' WHERE `steamid` = '.$user['steamid']);
			} else {
				foreach ($assetids as $key) {
					$db->exec('DELETE FROM `items` WHERE `id` = '.$db->quote($key));
				}
				$out['bot'] = $r['name'];
				$db->exec('INSERT INTO `trades` SET `id` = '.$db->quote($out['tid']).', `bot_id` = '.$db->quote($bot).', `code` = '.$db->quote($out['code']).', `status` = 2, `user` = '.$db->quote($user['steamid']).', `summa` = '.'-'.$db->quote($_GET['checksum']).', `time` = '.$db->quote(time()));
			}
		}
		exit(json_encode($out));
		break;

	case 'exit':
		setcookie("hash", "", time() - 3600, '/');
		header('Location: /main');
		exit();
		break;
}

function getTemplate($name, $in = null) {
	extract($in);
	ob_start();
	include "template/" . $name;
	$text = ob_get_clean();
	return $text;
}

function curl($url) {
	$ch = curl_init();

	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
	curl_setopt($ch, CURLOPT_COOKIEFILE, 'cookies.txt');
	curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookies.txt');
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1); 

	$data = curl_exec($ch);
	curl_close($ch);

	return $data;
}

function extract_token($url) {
    parse_str(parse_url($url, PHP_URL_QUERY), $queryString);
    return isset($queryString['token']) ? $queryString['token'] : false;
}

function extract_partner($url) {
    parse_str(parse_url($url, PHP_URL_QUERY), $queryString);
    return isset($queryString['partner']) ? $queryString['partner'] : false;
}