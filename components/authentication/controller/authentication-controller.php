<?php
session_start();

# -------------------------------------------------------------
#
# Function: AuthenticationController
# Description: 
# The AuthenticationController class handles authentication related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class AuthenticationController {
    private $authenticationModel;
    private $securitySettingModel;
    private $emailSettingModel;
    private $notificationSettingModel;
    private $systemModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided AuthenticationModel, SystemModel and SecurityModel instances.
    # These instances are used for address type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param AuthenticationModel $authenticationModel     The authenticationModel instance for authentication related operations.
    # - @param SecuritySettingModel $securitySettingModel     The securitySettingModel instance for security setting related operations.
    # - @param EmailSettingModel $emailSettingModel     The emailSettingModel instance for email setting related operations.
    # - @param NotificationSettingModel $notificationSettingModel     The notificationSettingModel instance for notification setting related operations.
    # - @param SystemModel $systemModel     The SystemModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(AuthenticationModel $authenticationModel, SecuritySettingModel $securitySettingModel, EmailSettingModel $emailSettingModel, NotificationSettingModel $notificationSettingModel, SystemModel $systemModel, SecurityModel $securityModel) {
        $this->authenticationModel = $authenticationModel;
        $this->securitySettingModel = $securitySettingModel;
        $this->emailSettingModel = $emailSettingModel;
        $this->notificationSettingModel = $notificationSettingModel;
        $this->systemModel = $systemModel;
        $this->securityModel = $securityModel;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: handleRequest
    # Description: 
    # This method checks the request method and dispatches the corresponding transaction based on the provided transaction parameter.
    # The transaction determines which action should be performed.
    #
    # Parameters:
    # - $transaction (string): The type of transaction.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function handleRequest(){
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $transaction = isset($_POST['transaction']) ? $_POST['transaction'] : null;

            switch ($transaction) {
                case 'authenticate':
                    $this->authenticate();
                    break; 
                case 'resend otp':
                    $this->resendOTP();
                    break; 
                default:
                    $response = [
                        'success' => false,
                        'title' => 'Authentication Error',
                        'message' => 'Invalid transaction.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    exit;
            }
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Authenticate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: authenticate
    # Description: 
    # Handles the login process, including two-factor authentication and account locking.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function authenticate() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        $email = htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8');
        $password = htmlspecialchars($_POST['password'], ENT_QUOTES, 'UTF-8');

        $checkLoginCredentialsExist = $this->authenticationModel->checkLoginCredentialsExist(null, $email);
        $total = $checkLoginCredentialsExist['total'] ?? 0;
    
        if ($total === 0) {
            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => 'The email or password you entered is invalid. Please double-check your credentials and try again.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $loginCredentialsDetails = $this->authenticationModel->getLoginCredentials(null, $email);
        $userID = $loginCredentialsDetails['user_id'];
        $active = $loginCredentialsDetails['active'];
        $userPassword = $this->securityModel->decryptData($loginCredentialsDetails['password']);
        $locked = $loginCredentialsDetails['locked'];
        $failedLoginAttempts = $loginCredentialsDetails['failed_login_attempts'];
        $passwordExpiryDate = $loginCredentialsDetails['password_expiry_date'];
        $accountLockDuration = $loginCredentialsDetails['account_lock_duration'];
        $lastFailedLoginAttempt = $loginCredentialsDetails['last_failed_login_attempt'];
        $twoFactorAuth = $loginCredentialsDetails['two_factor_auth'];
        $encryptedUserID = $this->securityModel->encryptData($userID);
    
        if ($password !== $userPassword) {
            $this->handleInvalidCredentials($userID, $failedLoginAttempts);
            return;
        }
    
        if ($active === 'No') {
            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => 'Your account is currently inactive. Please contact the administrator for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    
        if ($this->passwordHasExpired($passwordExpiryDate)) {
            $this->handlePasswordExpiration($user, $email, $encryptedUserID);
            exit;
        }
    
        if ($locked === 'Yes') {
            $this->handleAccountLock($userID, $accountLockDuration, $lastFailedLoginAttempt);
            exit;
        }
    
        $this->authenticationModel->updateLoginAttempt($userID, 0, null);
    
        if ($twoFactorAuth === 'Yes') {
            $this->handleTwoFactorAuth($userID, $email, $encryptedUserID);
            exit;
        }
        
        $_SESSION['user_id'] = $userID;

        $response = [
            'success' => true,
            'twoFactorAuth' => false
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Resend methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: resendOTP
    # Description: 
    # Handles the resending OTP code.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function resendOTP() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        $userID = htmlspecialchars($_POST['user_id'], ENT_QUOTES, 'UTF-8');

        $checkLoginCredentialsExist = $this->authenticationModel->checkLoginCredentialsExist($userID, null);
        $total = $checkLoginCredentialsExist['total'] ?? 0;
    
        if ($total === 0) {
            $response = [
                'success' => false,
                'notExist' => true,
                'title' => 'Authentication Error',
                'message' => 'The user account does not exist.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $loginCredentialsDetails = $this->authenticationModel->getLoginCredentials($userID, null);
        $email = $loginCredentialsDetails['email'];
        $active = $loginCredentialsDetails['active'];
        $locked = $loginCredentialsDetails['locked'];
    
        if ($active === 'No') {
            $response = [
                'success' => false,
                'notActive' => true,
                'title' => 'Authentication Error',
                'message' => 'Your account is currently inactive. Please contact the administrator for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    
        if ($locked === 'Yes') {
            $response = [
                'success' => false,
                'locked' => true,
                'title' => 'Authentication Error',
                'message' => 'Your account is currently locked. Please contact the administrator for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }

        $this->resendOTPCode($userID, $email);

        $response = [
            'success' => true
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: handleInvalidCredentials
    # Description:
    # Updates the failed login attempts and, if the maximum attempts are reached, locks the account.
    #
    # Parameters: 
    # - $loginCredentialsDetails (array): The login credentials details.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function handleInvalidCredentials($userID, $failedAttempts) {
        $failedAttempts = $failedAttempts + 1;
        $lastFailedLogin = date('Y-m-d H:i:s');
    
        $this->authenticationModel->updateLoginAttempt($userID, $failedAttempts, $lastFailedLogin);

        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(1);
        $maxFailedLoginAttempts = $securitySettingDetails['value'] ?? MAX_FAILED_LOGIN_ATTEMPTS;

        $userAccountLockDurationSettingDetails = $this->securitySettingModel->getSecuritySetting(8);
        $baseLockDuration = $userAccountLockDurationSettingDetails['value'] ?? BASE_USER_ACCOUNT_DURATION;

        if ($failedAttempts > $maxFailedLoginAttempts) {
            $lockDuration = pow(2, ($failedAttempts - $maxFailedLoginAttempts)) * 5;
            $this->authenticationModel->updateAccountLock($userID, 'Yes', $lockDuration);
            
            $durationParts = $this->formatDuration($lockDuration);
            
            $message = 'You have reached the maximum number of failed login attempts. Your account has been locked';
            
            if (count($durationParts) > 0) {
                $message .= ' for ' . implode(', ', $durationParts);
            }
            
            $message .= '.';

            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => $message, 
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
        else {
            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => 'The email or password you entered is invalid. Please double-check your credentials and try again.', 
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: handleAccountLock
    # Description:
    # Checks the account lock duration and displays the remaining lock time.
    # If the lock time has expired, unlocks the account.
    #
    # Parameters: 
    # - $userID (int): The user ID.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function handleAccountLock($userID, $accountLockDuration, $lastFailedLoginAttempt) {
        $unlockTime = strtotime('+'. $accountLockDuration .' minutes', strtotime($lastFailedLoginAttempt));
    
        if (time() < $unlockTime) {
            $durationParts = $this->formatDuration(round(($unlockTime - time()) / 60));

            $message = 'Your account has been locked. Please try again in ';

            if (count($durationParts) > 0) {
                $message .= implode(', ', $durationParts);
            }

            $message .= '.';

            $response = [
                'success' => false,
                'title' => 'Authentication Error',
                'message' => $message, 
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
        else {
            $this->authenticationModel->updateAccountLock($userID, 'No', null);
        }
    
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: handleTwoFactorAuth
    # Description:
    # Generates and encrypts an OTP, sets the OTP expiry date, and sends the OTP to the user's email.
    #
    # Parameters: 
    # - $userID (int): The user ID.
    # - $email (string): The email address of the user.
    # - $encryptedUserID (string): The encrypted user ID.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function handleTwoFactorAuth($userID, $email, $encryptedUserID) {
        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(6);
        $otpDuration = $securitySettingDetails['value'] ?? DEFAULT_OTP_DURATION;

        $otp = $this->generateToken(6, 6);
        $encryptedOTP = $this->securityModel->encryptData($otp);
        $otpExpiryDate = date('Y-m-d H:i:s', strtotime('+'. $otpDuration .' minutes'));
    
        $this->authenticationModel->updateOTP($userID, $encryptedOTP, $otpExpiryDate);
        $this->sendOTP($email, $otp);
    
        $response = [
            'success' => true,
            'twoFactorAuth' => true,
            'encryptedUserID' => $encryptedUserID
        ];
        
        echo json_encode($response);
        exit;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: resendOTPCode
    # Description:
    # Generates and encrypts an OTP, sets the OTP expiry date, and sends the OTP to the user's email.
    #
    # Parameters: 
    # - $userID (int): The user ID.
    # - $email (string): The email address of the user.
    # - $encryptedUserID (string): The encrypted user ID.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    private function resendOTPCode($userID, $email) {
        $securitySettingDetails = $this->securitySettingModel->getSecuritySetting(6);
        $otpDuration = $securitySettingDetails['value'] ?? DEFAULT_OTP_DURATION;

        $otp = $this->generateToken(6, 6);
        $encryptedOTP = $this->securityModel->encryptData($otp);
        $otpExpiryDate = date('Y-m-d H:i:s', strtotime('+'. $otpDuration .' minutes'));
    
        $this->authenticationModel->updateOTP($userID, $encryptedOTP, $otpExpiryDate);
        $this->sendOTP($email, $otp);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: formatDuration
    # Description:
    # Updates the failed login attempts and, if the maximum attempts are reached, locks the account.
    #
    # Parameters: 
    # - $lockDuration (int): The duration in seconds that needs to be formatted. This value represents the total duration that you want to convert into a human-readable format.
    #
    # Returns: 
    #  Returns a formatted string representing the duration in a human-readable format. 
    #  The format includes years, months, days, hours, and minutes, as applicable. 
    #  The function constructs this string based on the provided $lockDuration parameter.
    #
    # -------------------------------------------------------------
    private function formatDuration($lockDuration) {
        $durationParts = [];

        $timeUnits = [
            ['year', 60 * 60 * 24 * 30 * 12],
            ['month', 60 * 60 * 24 * 30],
            ['day', 60 * 60 * 24],
            ['hour', 60 * 60],
            ['minute', 60]
        ];

        foreach ($timeUnits as list($unit, $seconds)) {
            $value = floor($lockDuration / $seconds);
            $lockDuration %= $seconds;

            if ($value > 0) {
                $durationParts[] = number_format($value) . ' ' . $unit . ($value > 1 ? 's' : '');
            }
        }

        return $durationParts;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: passwordHasExpired
    # Description:
    # Checks if the user's password is expired.
    #
    # Parameters: 
    # - $userID (int): The user ID.
    #
    # Returns: Bool
    #
    # -------------------------------------------------------------
    private function passwordHasExpired($passwordExpiryDate) {
        $passwordExpiryDate = new DateTime($passwordExpiryDate);
        $currentDate = new DateTime();
        
        if ($currentDate > $passwordExpiryDate) {
            return true;
        }
        
        return false;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Generate methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: generateToken
    # Description: 
    # Generates a random token/OTP (One-Time Password) of specified length.
    #
    # Parameters: 
    # - $minLength (int): The minimum length of the generated token. Default is 4.
    # - $maxLength (int): The maximum length of the generated token. Default is 4.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function generateToken($minLength = 4, $maxLength = 4) {
        $length = mt_rand($minLength, $maxLength);
        $minValue = pow(10, $length - 1);
        $maxValue = pow(10, $length) - 1;
    
        $token = random_int($minValue, $maxValue);
        
        return (string) $token;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Send methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: sendOTP
    # Description: 
    # Sends an OTP (One-Time Password) to the user's email address.
    #
    # Parameters: 
    # - $email (string): The email address of the user.
    # - $otp (string): The OTP generated.
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function sendOTP($email, $otp) {
        $emailSetting = $this->emailSettingModel->getEmailSetting(1);
        $mailFromName = $emailSetting['mail_from_name'] ?? null;
        $mailFromEmail = $emailSetting['mail_from_email'] ?? null;

        $notificationSettingDetails = $this->notificationSettingModel->getNotificationSetting(1);
        $emailSubject = $notificationSettingDetails['email_notification_subject'] ?? null;
        $emailBody = $notificationSettingDetails['email_notification_body'] ?? null;
        $emailBody = str_replace('{OTP_CODE}', $otp, $emailBody);

        $message = file_get_contents('../../notification-setting/template/default-email.html');
        $message = str_replace('{EMAIL_SUBJECT}', $emailSubject, $message);
        $message = str_replace('{EMAIL_CONTENT}', $emailBody, $message);
    
        $mailer = new PHPMailer\PHPMailer\PHPMailer();
        $this->configureSMTP($mailer);
        
        $mailer->setFrom($mailFromEmail, $mailFromName);
        $mailer->addAddress($email);
        $mailer->Subject = $emailSubject;
        $mailer->Body = $message;
    
        if ($mailer->send()) {
            return true;
        }
        else {
            return 'Failed to send OTP. Error: ' . $mailer->ErrorInfo;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Configure methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: configureSMTP
    # Description: 
    # Sets the SMTP configuration
    #
    # Parameters: 
    # - $mailer (array): The PHP mailer.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    private function configureSMTP($mailer, $isHTML = true) {
        $emailSetting = $this->emailSettingModel->getEmailSetting(1);
        $mailHost = $emailSetting['mail_host'] ?? MAIL_HOST;
        $smtpAuth = empty($emailSetting['smtp_auth']) ? false : true;
        $mailUsername = $emailSetting['mail_username'] ?? MAIL_USERNAME;
        $mailPassword = !empty($password) ? $this->securityModel->decryptData($emailSetting['mail_password']) : MAIL_PASSWORD;
        $mailEncryption = $emailSetting['mail_encryption'] ?? MAIL_SMTP_SECURE;
        $port = $emailSetting['port'] ?? MAIL_PORT;
        
        $mailer->isSMTP();
        $mailer->isHTML(true);
        $mailer->Host = $mailHost;
        $mailer->SMTPAuth = $smtpAuth;
        $mailer->Username = $mailUsername;
        $mailer->Password = $mailPassword;
        $mailer->SMTPSecure = $mailEncryption;
        $mailer->Port = $port;
    }
    # -------------------------------------------------------------
}

require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/system-model.php';
require_once '../../authentication/model/authentication-model.php';
require_once '../../security-setting/model/security-setting-model.php';
require_once '../../email-setting/model/email-setting-model.php';
require_once '../../notification-setting/model/notification-setting-model.php';
require_once '../../../assets/libs/phpmailer/src/PHPMailer.php';
require_once '../../../assets/libs/phpmailer/src/Exception.php';
require_once '../../../assets/libs/phpmailer/src/SMTP.php';

$controller = new AuthenticationController(new AuthenticationModel(new DatabaseModel), new SecuritySettingModel(new DatabaseModel), new EmailSettingModel(new DatabaseModel), new NotificationSettingModel(new DatabaseModel), new SystemModel(), new SecurityModel());
$controller->handleRequest();
?>