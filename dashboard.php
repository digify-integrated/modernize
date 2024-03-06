<?php
    require('view/_required_php_files.php');

    $pageTitle = 'Dashboard';
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
    <head>
        <?php include_once('view/_head.php'); ?>
    </head>

    <body>
        <?php include_once('view/_preloader.php'); ?>
        <div id="main-wrapper">
            <?php include_once('view/_menu.php'); ?>
            <div class="page-wrapper">
                <?php include_once('view/_navbar.php'); ?>
                <div class="body-wrapper">
                    <div class="container-fluid">
                    
                    </div>
                </div>
            </div>
        </div>
        <div class="dark-transparent sidebartoggler"></div>
        <script>
        </script>
        <?php 
            include_once('view/_customizer.php');
            include_once('view/_global_js.php');
            include_once('view/_error_modal.php');
        ?>
        <script src="./assets/js/pages/index.js?v=<?php echo rand(); ?>"></script>
    </body>
</html>
