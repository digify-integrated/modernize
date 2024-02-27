<?php
    $pageTitle = 'CGMI Digital Solutions';
?>
<!DOCTYPE html>
<html lang="en" dir="ltr" data-bs-theme="light" data-color-theme="Blue_Theme" data-layout="vertical">
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
                                <h2 class="mb-1 fs-7 fw-bolder">Welcome to <span class="text-primary">Modernize</span></h2>
                                <p class="mb-7">Your Admin Dashboard</p>
                                <form id="signin-form" method="post" action="#">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">Username</label>
                                        <input type="text" class="form-control" id="username" name="username"  autocomplete="off">
                                    </div>
                                    <div class="mb-4">
                                        <label for="exampleInputPassword1" class="form-label">Password</label>
                                        <input type="password" class="form-control" id="password" name="password">
                                    </div>
                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                        <div class="form-check">
                                            <input class="form-check-input primary" type="checkbox" value="" id="flexCheckChecked">
                                            <label class="form-check-label text-dark fs-3" for="flexCheckChecked">Remember me?</label>
                                        </div>
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
    <script src="./assets/js/pages/index.js?v=<?php echo rand(); ?>"></script>
</body>
</html>