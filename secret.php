#!/usr/bin/php -q
<?php
try {
	$db = new PDO('mysql:host=localhost;dbname=csgo', 'root', 'Tomelloso123', array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
} catch (PDOException $e) {
	exit($e->getMessage());
}

$time = rand(1000000000, 9999999999);
$no_hash = $time.rand(1,100).rand(1,10000).rand(1,10000000);
$hash = hash('sha256', $no_hash);
$db->exec('INSERT INTO `hash` SET `time` = '.$db->quote(time()).', `hash` = '.$db->quote($hash).', `no_hash` = '.$db->quote($no_hash));