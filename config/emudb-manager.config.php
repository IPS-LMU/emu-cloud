<?php

// (c) 2018 Markus Jochim <markusjochim@phonetik.uni-muenchen.de>

$dataDirectory = '/var/emuDBs';
date_default_timezone_set('Europe/Berlin');

$openIdUserinfoEndpoint = 'http://example.com:8080/auth/realms/master/protocol/openid-connect/userinfo';

//////////
// Database configuration
//
$dbHost = 'database';
$dbDatabaseName = 'emu';
$dbUser = 'database-user';
$dbPassword = 'database-password';
$dbSSLMode = 'disable';
//
//////////
