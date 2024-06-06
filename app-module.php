<?php
    require('view/_required_php_files.php');
    require('view/_check_user_status.php');
    require('view/_page_details.php');

    $appModuleReadAccess = $globalModel->checkAccessRights($userID, $pageID, 'read');
    $appModuleCreateAccess = $globalModel->checkAccessRights($userID, $pageID, 'create');
    $appModuleWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');
    $appModuleDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
    <head>
        <?php include_once('view/_head.php'); ?>
        <link rel="stylesheet" href="./assets/libs/datatables.net-bs5/css/dataTables.bootstrap5.min.css" />
    </head>

    <body>
        <?php include_once('view/_preloader.php'); ?>
        <div id="main-wrapper">
            <?php include_once('view/_menu.php'); ?>
            <div class="page-wrapper">
                <?php include_once('view/_navbar.php'); ?>
                <div class="body-wrapper">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-12">
                                <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
                                    <div class="card-body px-4 py-3">
                                        <div class="row align-items-center">
                                            <div class="col-9">
                                                <h4 class="fw-semibold mb-8"><?php echo $pageTitle; ?></h4>
                                                <nav aria-label="breadcrumb">
                                                    <ol class="breadcrumb fs-2">
                                                        <?php
                                                            require('view/_breadcrumb.php');

                                                            if(!$newRecord && !empty($detailID)){
                                                                echo '<li class="breadcrumb-item" id="app-module-id">'. $detailID .'</li>';
                                                            }

                                                            if($newRecord){
                                                                echo '<li class="breadcrumb-item">New</li>';
                                                            }
                                                        ?>
                                                    </ol>
                                                </nav>
                                            </div>
                                            <div class="col-3">
                                                <div class="text-center mb-n5">
                                                    <img src="./assets/images/breadcrumb/ChatBc.png" alt="" class="img-fluid mb-n4"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <?php
                            if($newRecord){
                                require_once('components/app-module/view/_app_module_new.php');
                            }
                            else if(!empty($detailID)){
                                require_once('components/app-module/view/_app_module_details.php');
                            }
                            else{
                                require_once('components/app-module/view/_app_module.php');
                            }
                        ?>
                    </div>
                </div>
            </div>
        </div>
        <div class="dark-transparent sidebartoggler"></div>
        <?php 
            include_once('view/_customizer.php');
            include_once('view/_error_modal.php');
            include_once('view/_global_js.php');
        ?>
        
        <script src="./assets/libs/max-length/bootstrap-maxlength.min.js"></script>
        <script src="./assets/libs/datatables.net/js/jquery.dataTables.min.js"></script>

        <?php 
            if($newRecord){
                $scriptLink = 'app-module-new.js';
            }
            else if(!empty($detailID)){
                $scriptLink = 'app-module-details.js';
            }
            else{
                $scriptLink = 'app-module.js';
            }

            echo '<script src="./components/app-module/js/'. $scriptLink .'?v=' . rand() .'"></script>';
        ?>
    </body>
</html>
