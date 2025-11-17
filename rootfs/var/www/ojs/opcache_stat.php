<?php

if (!str_starts_with($_SERVER['REMOTE_ADDR'], '128.180.')) {
    http_response_code(403);
    die('Access denied');
}

header('Content-Type: application/json');
$status=opcache_get_status(FALSE);
echo json_encode($status, JSON_PRETTY_PRINT);
