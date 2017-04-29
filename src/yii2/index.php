<?php
$realUrl = "http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]".'web/';
header("Location: $realUrl");
exit();
?>
