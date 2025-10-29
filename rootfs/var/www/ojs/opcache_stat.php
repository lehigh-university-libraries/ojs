<?php

if ($_SERVER['REMOTE_ADDR'] !== '127.0.0.1') {
    http_response_code(403);
    die('Access denied');
}

header('Content-Type: application/json');
$status=opcache_get_status();
echo json_encode($status);
