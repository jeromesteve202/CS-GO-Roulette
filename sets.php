<?php

setcookie('hash', $_GET['id'], time() + 3600 * 24 * 7, '/');

header('location: /');

?>