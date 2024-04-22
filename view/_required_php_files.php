<?php

require('session.php');
require('components/global/config/config.php');
require('components/global/model/database-model.php');
require('components/authentication/model/authentication-model.php');
require('components/global/model/security-model.php');
require('components/global/model/system-model.php');
require('components/global/model/global-model.php');
require('components/menu-group/model/menu-group-model.php');
require('components/menu-item/model/menu-item-model.php');

$databaseModel = new DatabaseModel();
$authenticationModel = new AuthenticationModel($databaseModel);
$securityModel = new SecurityModel();
$systemModel = new SystemModel();
$globalModel = new GlobalModel($databaseModel, $securityModel);
$menuGroupModel = new MenuGroupModel($databaseModel);
$menuItemModel = new MenuItemModel($databaseModel);

?>