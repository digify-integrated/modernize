<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/security-model.php');
    require('components/authentication/model/authentication-model.php');

    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();
    $authenticationModel = new AuthenticationModel($databaseModel);

    $pageTitle = 'Password Reset';

    if (isset($_GET['id']) && !empty($_GET['id']) && isset($_GET['token']) && !empty($_GET['token'])) {
        $id = $_GET['id'];
        $token = $_GET['token'];
        $userID = $securityModel->decryptData($id);
        $token = $securityModel->decryptData($token);

        $loginCredentialsDetails = $authenticationModel->getLoginCredentials($userID, null);
        $resetToken =  $securityModel->decryptData($loginCredentialsDetails['reset_token']);
        $resetTokenExpiryDate = $loginCredentialsDetails['reset_token_expiry_date'];

        if($token != $resetToken || strtotime(date('Y-m-d H:i:s')) > strtotime($resetTokenExpiryDate)){
            header('location: 404.php');
            exit;
        }
    }
    else{
        header('location: index.php');
        exit;
    }

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
                                <h2 class="mb-1 fs-7 fw-bolder">Password <span class="text-primary">Reset</span></h2>
                                <p class="mb-7">Enter your new password</p>
                                <form id="password-reset-form" method="post" action="#">
                                    <input type="hidden" id="user_id" name="user_id" value="<?php echo $userID; ?>">
                                    <div class="mb-4">
                                        <label for="new_password" class="form-label">New Password</label>
                                        <div class="input-group mb-3">
                                            <input type="password" class="form-control" id="new_password" name="new_password">
                                            <button class="btn bg-info-subtle text-info  rounded-end d-flex align-items-center password-addon" type="button">
                                                <i class="ti ti-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <label for="confirm_password" class="form-label">Confirm Password</label>
                                        <div class="input-group mb-3">
                                            <input type="password" class="form-control" id="confirm_password" name="confirm_password">
                                            <button class="btn bg-info-subtle text-info  rounded-end d-flex align-items-center password-addon" type="button">
                                                <i class="ti ti-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <button id="reset" type="submit" class="btn btn-primary w-100 py-8 mb-4 rounded-2">Reset Password</button>
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
        include_once('view/_error_modal.php');
        include_once('view/_global_js.php');
    ?>
    <script src="./components/authentication/js/password-reset.js?v=<?php echo rand(); ?>"></script>
</body>
</html>