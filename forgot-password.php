<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');

    $databaseModel = new DatabaseModel();
    
    $pageTitle = 'Forgot Password';

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
                                <div class="mb-5">
                                    <h2 class="mb-1 fs-7 fw-bolder">Forgot <span class="text-primary">Password</span></h2>
                                    <p class="mb-7">Please enter the email address associated with your account and We will email you a link to reset your password.</p>
                                </div>
                                <form id="forgot-password-form" method="post" action="#">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" name="email" autocomplete="off">
                                    </div>
                                    <button id="forgot-password" type="submit" class="btn btn-primary w-100 py-8 mb-4 rounded-2">Forgot Password</button>
                                    <a href="index.php" class="btn bg-primary-subtle text-primary w-100 py-8">Back to Login</a>
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
    <script src="./components/authentication/js/forgot-password.js?v=<?php echo rand(); ?>"></script>
</body>
</html>