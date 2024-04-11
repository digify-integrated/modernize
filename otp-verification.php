<?php
    require('components/global/config/config.php');
    require('components/global/model/database-model.php');
    require('components/global/model/security-model.php');
    require('components/authentication/model/authentication-model.php');

    $databaseModel = new DatabaseModel();
    $securityModel = new SecurityModel();
    $authenticationModel = new AuthenticationModel($databaseModel);
    
    $pageTitle = 'OTP Verification';

    if (isset($_GET['id']) && !empty($_GET['id'])) {
        $id = $_GET['id'];
        $userID = $securityModel->decryptData($id);

        $checkLoginCredentialsExist = $authenticationModel->checkLoginCredentialsExist($userID, null);
        $total = $checkLoginCredentialsExist['total'] ?? 0;

        if($total > 0){
            $loginCredentialsDetails = $authenticationModel->getLoginCredentials($userID, null);
            $emailObscure = $securityModel->obscureEmail($loginCredentialsDetails['email']);
        }
        else{
            header('location: 404.php');
            exit;
        }
    }
    else {
        header('location: 404.php');
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
                                <div class="mb-5">
                                    <h2 class="mb-1 fs-7 fw-bolder">Two Step <span class="text-primary">Verification</span></h2>
                                    <p class="mb-7">We've sent a verification code to your email address. Please check your inbox and enter the code below.</p>
                                    <h6 class="fw-bolder"><?php echo $emailObscure; ?></h6>
                                </div>
                                <form id="otp-form" method="post" action="#">
                                    <input type="hidden" id="user_account_id" name="user_account_id" value="<?php echo $userID; ?>">
                                    <div class="mb-3">
                                        <label class="form-label fw-semibold">Type your 6 digit security code</label>
                                        <div class="d-flex align-items-center gap-2 gap-sm-3">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_1" name="otp_code_1" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_2" name="otp_code_2" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_3" name="otp_code_3" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_4" name="otp_code_4" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_5" name="otp_code_5" autocomplete="off" maxlength="1">
                                            <input type="text" class="form-control text-center otp-input" id="otp_code_6" name="otp_code_6" autocomplete="off" maxlength="1">
                                        </div>
                                    </div>
                                    <button id="verify" type="submit" class="btn btn-primary w-100 py-8 mb-4 rounded-2">Verify</button>
                                </form>
                                <div class="row">
                                    <div class="col-6 mb-2 mb-sm-0">
                                        <p class="text-dark">Didn't get the code?</p>
                                    </div>
                                    <div class="col-6 text-end">
                                        <p id="countdown" class="d-none">Resend code in <span id="timer">60</span> seconds</p>
                                        <a href="Javascript:void(0);" id="resend-link" class="text-primary fw-medium ms-2">Resend Code</a>
                                    </div>
                                </div>
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
    <script src="./components/authentication/js/otp-verification.js?v=<?php echo rand(); ?>"></script>
</body>
</html>