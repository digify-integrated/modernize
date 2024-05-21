<?php
    require('view/_required_php_files.php');
    require('view/_check_user_status.php');
    require('view/_page_details.php');

    $uploadSettingReadAccess = $globalModel->checkAccessRights($userID, $pageID, 'read');
    $uploadSettingCreateAccess = $globalModel->checkAccessRights($userID, $pageID, 'create');
    $uploadSettingWriteAccess = $globalModel->checkAccessRights($userID, $pageID, 'write');
    $uploadSettingDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');
    $addFileExtensionAccess = $globalModel->checkSystemActionAccessRights($userID, 13);
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
    <head>
        <?php include_once('view/_head.php'); ?>
        <link rel="stylesheet" href="./assets/libs/datatables.net-bs5/css/dataTables.bootstrap5.min.css" />
        <link rel="stylesheet" href="./assets/libs/bootstrap-duallistbox/dist/bootstrap-duallistbox.min.css">
        <link rel="stylesheet" href="./assets/libs/select2/dist/css/select2.min.css">
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
                                                                echo '<li class="breadcrumb-item" id="upload-setting-id">'. $detailID .'</li>';
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
                                require_once('components/upload-setting/view/_upload_setting_new.php');
                            }
                            else if(!empty($detailID)){
                                require_once('components/upload-setting/view/_upload_setting_details.php');
                            }
                            else{
                                require_once('components/upload-setting/view/_upload_setting.php');
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
        <script src="./assets/libs/select2/dist/js/select2.full.min.js"></script>
        <script src="./assets/libs/select2/dist/js/select2.min.js"></script>
        <script src="./assets/libs/bootstrap-duallistbox/dist/jquery.bootstrap-duallistbox.min.js"></script>

        <?php 
            if($newRecord){
                $scriptLink = 'upload-setting-new.js';
            }
            else if(!empty($detailID)){
                $scriptLink = 'upload-setting-details.js';
            }
            else{
                $scriptLink = 'upload-setting.js';
            }

            echo '<script src="./components/upload-setting/js/'. $scriptLink .'?v=' . rand() .'"></script>';
        ?>
    </body>
</html>
