<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    
    $databaseModel = new DatabaseModel();

    $pageTitle = 'CGMI Digital Solutions';

    require('session-check.php');
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="dark" data-color-theme="Blue_Theme" data-layout="vertical">
<head>
    <?php include_once('view/_head.php'); ?>
</head>

<body>
    <?php include_once('view/_preloader.php'); ?>
    <div id="main-wrapper">
        <div class="position-relative overflow-hidden radial-gradient min-vh-100 w-100">
            <div class="position-relative z-index-5">
                <div class="row">
                    <div class="col-xl-7 col-xxl-8">
                        <a href="index.php" class="text-nowrap logo-img d-block px-4 py-9 w-100">
                            <img src="./assets/images/logos/dark-logo.svg" class="dark-logo" alt="Logo-Dark" />
                            <img src="./assets/images/logos/light-logo.svg" class="light-logo" alt="Logo-light" />
                        </a>
                        <div class="d-none d-xl-flex align-items-center justify-content-center h-n80">
                            <img src="./assets/images/backgrounds/login-security.svg" alt="" class="img-fluid" width="500">
                        </div>
                    </div>
                    <div class="col-xl-5 col-xxl-4">
                        <div class="authentication-login min-vh-100 bg-body row justify-content-center align-items-center p-0">
                            <div class="auth-max-width col-sm-8 col-md-6 col-xl-7 px-0">
                                <h2 class="mb-1 fs-7 fw-bolder">Welcome to <span class="text-primary">CGMI Digital Solutions</span></h2>
                                <p class="mb-7">Empowering Futures, Crafting Digital Excellence</p>
                                <form id="signin-form" method="post" action="#">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" name="email" autocomplete="off">
                                    </div>
                                    <div class="mb-4">
                                        <label for="password" class="form-label">Password</label>
                                        <div class="input-group mb-3">
                                            <input type="password" class="form-control" id="password" name="password">
                                            <button class="btn bg-info-subtle text-info  rounded-end d-flex align-items-center password-addon" type="button">
                                                <i class="ti ti-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="text-end mb-4">
                                        <a class="text-primary fw-medium fs-3" href="forgot-password.php">Forgot Password ?</a>
                                    </div>
                                    <button id="signin" type="submit" class="btn btn-primary w-100 py-8 mb-4 rounded-2">Login</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="dark-transparent sidebartoggler"></div>
    <?php 
        include_once('view/_customizer.php');
        include_once('view/_global_js.php');
        include_once('view/_error_modal.php');
    ?>
    <script src="./components/authentication/js/index.js?v=<?php echo rand(); ?>"></script>
</body>
</html>