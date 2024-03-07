<?php

require('session.php');
require('components/global/config/config.php');
require('components/global/model/database-model.php');
require('components/authentication/model/authentication-model.php');
require('components/global/model/security-model.php');
require('components/global/model/system-model.php');

$databaseModel = new DatabaseModel();
$authenticationModel = new AuthenticationModel($databaseModel);
$securityModel = new SecurityModel();
$systemModel = new SystemModel();

?>