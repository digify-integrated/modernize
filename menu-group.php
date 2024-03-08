<?php
    require('view/_required_php_files.php');
    require('view/_check_user_status.php');

    $pageTitle = 'Menu Group';

    if(isset($_GET['id'])){
        if(empty($_GET['id'])){
          header('location: menu-group.php');
          exit;
        }
    
        $menuGroupID = $securityModel->decryptData($_GET['id']);
      }
      else{
        $menuGroupID = null;
      }
    
      $newRecord = isset($_GET['new']);
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
                        <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
                            <div class="card-body px-4 py-3">
                                <div class="row align-items-center">
                                    <div class="col-9">
                                        <h4 class="fw-semibold mb-8"><?php echo $pageTitle; ?></h4>
                                        <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb fs-2">
                                            <li class="breadcrumb-item"><a class="text-muted text-decoration-none" href="dashboard.php">Home</a></li>
                                            <li class="breadcrumb-item">Technical</li>
                                            <li class="breadcrumb-item" aria-current="page"><?php echo $pageTitle; ?></li>
                                            <?php
                                                if(!$newRecord && !empty($menuGroupID)){
                                                    echo '<li class="breadcrumb-item" id="menu-group-id">'. $menuGroupID .'</li>';
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
                        <?php
                            if($newRecord){
                                require_once('components/menu-group/view/_menu_group_new.php');
                            }
                            else if(!empty($menuGroupID)){
                                require_once('components/menu-group/view/_menu_group_details.php');
                            }
                            else{
                                require_once('components/menu-group/view/_menu_group.php');
                            }
                        ?>
                    </div>
                </div>
            </div>
        </div>
        <div class="dark-transparent sidebartoggler"></div>
        <?php 
            include_once('view/_customizer.php');
            include_once('view/_global_js.php');
            include_once('view/_error_modal.php');
            include_once('view/_required_js_files.php');
        ?>
        
        <script src="./assets/libs/max-length/bootstrap-maxlength.min.js"></script>

        <?php 
            if($newRecord){
                $scriptLink = 'menu-group-new.js';
            }
            else if(!empty($menuGroupID)){
                $scriptLink = 'menu-group-details.js';
            }
            else{
                $scriptLink = 'menu-group.js';
            }

            echo '<script src="./components/menu-group/js/'. $scriptLink .'?v=' . rand() .'"></script>';
        ?>
    </body>
</html>
