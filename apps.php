<?php
    require('view/_required_php_files.php');
    require('view/_check_user_status.php');

    $pageTitle = 'Apps';
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
    <head>
        <?php include_once('view/_head.php'); ?>
    </head>

    <body>
        <?php include_once('view/_preloader.php'); ?>
        <div class="o_home_menu_background" id="main-wrapper">
            <div class="app-page-wrapper">
                <div class="body-wrapper">
                    <div class="container-fluid">
                        <div class="row">
                            <?php
                                $apps = '';
                            
                                $sql = $databaseModel->getConnection()->prepare('CALL buildAppModule(:userID)');
                                $sql->bindValue(':userID', $userID, PDO::PARAM_INT);
                                $sql->execute();
                                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                                $sql->closeCursor();
                        
                                foreach ($options as $row) {
                                    $appModuleID = $row['app_module_id'];
                                    $appModuleName = $row['app_module_name'];
                                    $appVersion = $row['app_version'];
                                    $appLogo = $systemModel->checkImage($row['app_logo'], 'app module logo');
                                    
                                    $apps .= '<div class="col-lg-3">
                                                <a href="navigation.php?id='. $securityModel->encryptData($appModuleID) .'">
                                                    <div class="card border-0 zoom-in bg-light-subtle shadow-none">
                                                        <div class="card-body">
                                                            <div class="text-center">
                                                                <img src="'. $appLogo .'" width="50" height="50" class="mb-3" alt="app-logo">
                                                                <p class="fw-semibold fs-3 text-dark mb-1">'. $appModuleName .'</p> 
                                                            </div>
                                                        </div>
                                                    </div>
                                                 </a>
                                            </div>';
                                }
                        
                                echo $apps;
                            ?>
                            <div class="col-lg-3">
                                <a href="setting.php">
                                    <div class="card border-0 zoom-in bg-light-subtle shadow-none">
                                        <div class="card-body">
                                            <div class="text-center">
                                                <img src="./components/app-module/image/logo/global/setting.png" width="50" height="50" class="mb-3" alt="app-logo">
                                                <p class="fw-semibold fs-3 text-dark mb-1">Settings</p> 
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="dark-transparent sidebartoggler"></div>
        <?php 
            include_once('view/_error_modal.php');
            include_once('view/_global_js.php');
        ?>
    </body>
</html>