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
                            <div class="col-3">
                                <a href="">
                                    <div class="card border-0 zoom-in bg-light-subtle shadow-none">
                                        <div class="card-body">
                                            <div class="text-center">
                                                <img src="./assets/images/svgs/icon-speech-bubble.svg" width="50" height="50" class="mb-3" alt="modernize-img">
                                                <p class="fw-semibold fs-3 text-success mb-1">Administration</p> 
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
            include_once('view/_customizer.php');
            include_once('view/_error_modal.php');
            include_once('view/_global_js.php');
        ?>
    </body>
</html>
