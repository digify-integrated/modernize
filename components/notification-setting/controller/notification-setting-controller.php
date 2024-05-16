<?php
session_start();

# -------------------------------------------------------------
#
# Function: NotificationSettingController
# Description: 
# The NotificationSettingController class handles notification setting related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class NotificationSettingController {
    private $notificationSettingModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided notificationSettingModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for notification setting related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param notificationSettingModel $notificationSettingModel     The notificationSettingModel instance for notification setting related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(NotificationSettingModel $notificationSettingModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->notificationSettingModel = $notificationSettingModel;
        $this->authenticationModel = $authenticationModel;
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
            $userID = $_SESSION['user_account_id'];
            $sessionToken = $_SESSION['session_token'];

            $checkLoginCredentialsExist = $this->authenticationModel->checkLoginCredentialsExist($userID, null);
            $total = $checkLoginCredentialsExist['total'] ?? 0;

            if ($total === 0) {
                $response = [
                    'success' => false,
                    'userNotExist' => true,
                    'title' => 'User Account Not Exist',
                    'message' => 'The user account specified does not exist. Please contact the administrator for assistance.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $loginCredentialsDetails = $this->authenticationModel->getLoginCredentials($userID, null);
            $active = $loginCredentialsDetails['active'];
            $locked = $loginCredentialsDetails['locked'];
            $multipleSession = $loginCredentialsDetails['multiple_session'];
            $sessionToken = $this->securityModel->decryptData($loginCredentialsDetails['session_token']);

            if ($active === 'No') {
                $response = [
                    'success' => false,
                    'userInactive' => true,
                    'title' => 'User Account Inactive',
                    'message' => 'Your account is currently inactive. Kindly reach out to the administrator for further assistance.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
        
            if ($locked === 'Yes') {
                $response = [
                    'success' => false,
                    'userLocked' => true,
                    'title' => 'User Account Locked',
                    'message' => 'Your account is currently locked. Kindly reach out to the administrator for assistance in unlocking it.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
            
            if ($sessionToken != $sessionToken && $multipleSession == 'No') {
                $response = [
                    'success' => false,
                    'sessionExpired' => true,
                    'title' => 'Session Expired',
                    'message' => 'Your session has expired. Please log in again to continue',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $transaction = isset($_POST['transaction']) ? $_POST['transaction'] : null;

            switch ($transaction) {
                case 'add notification setting':
                    $this->addNotificationSetting();
                    break;
                case 'update notification setting':
                    $this->updateNotificationSetting();
                    break;
                case 'get notification setting details':
                    $this->getNotificationSettingDetails();
                    break;
                case 'delete notification setting':
                    $this->deleteNotificationSetting();
                    break;
                case 'delete multiple notification setting':
                    $this->deleteMultipleNotificationSetting();
                    break;
                case 'enable system notification channel':
                    $this->enableSystemNotificationChannel();
                    break;
                case 'disable system notification channel':
                    $this->disableSystemNotificationChannel();
                    break;
                case 'enable email notification channel':
                    $this->enableEmailNotificationChannel();
                    break;
                case 'disable email notification channel':
                    $this->disableEmailNotificationChannel();
                    break;
                case 'enable sms notification channel':
                    $this->enableSMSNotificationChannel();
                    break;
                case 'disable sms notification channel':
                    $this->disableSMSNotificationChannel();
                    break;
                default:
                    $response = [
                        'success' => false,
                        'title' => 'Transaction Error',
                        'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                        'messageType' => 'error'
                    ];
                    
                    echo json_encode($response);
                    break;
            }
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Add methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: addNotificationSetting
    # Description: 
    # Inserts a notification setting.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addNotificationSetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['notification_setting_name']) && !empty($_POST['notification_setting_name']) && isset($_POST['notification_setting_description']) && !empty($_POST['notification_setting_description'])) {
            $userID = $_SESSION['user_account_id'];
            $notificationSettingName = htmlspecialchars($_POST['notification_setting_name'], ENT_QUOTES, 'UTF-8');
            $notificationSettingDescription = htmlspecialchars($_POST['notification_setting_description'], ENT_QUOTES, 'UTF-8');
        
            $notificationSettingID = $this->notificationSettingModel->insertNotificationSetting($notificationSettingName, $notificationSettingDescription, $userID);
    
            $response = [
                'success' => true,
                'notificationSettingID' => $this->securityModel->encryptData($notificationSettingID),
                'title' => 'Insert Notification Setting Success',
                'message' => 'The notification setting has been inserted successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateNotificationSetting
    # Description: 
    # Updates the notification setting if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateNotificationSetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id']) && isset($_POST['notification_setting_name']) && !empty($_POST['notification_setting_name']) && isset($_POST['notification_setting_description']) && !empty($_POST['notification_setting_description'])) {
            $userID = $_SESSION['user_account_id'];
            $notificationSettingID = htmlspecialchars($_POST['notification_setting_id'], ENT_QUOTES, 'UTF-8');
            $notificationSettingName = htmlspecialchars($_POST['notification_setting_name'], ENT_QUOTES, 'UTF-8');
            $notificationSettingDescription = htmlspecialchars($_POST['notification_setting_description'], ENT_QUOTES, 'UTF-8');
        
            $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
            $total = $checkNotificationSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Notification Setting Error',
                    'message' => 'The notification setting has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->notificationSettingModel->updateNotificationSetting($notificationSettingID, $notificationSettingName, $notificationSettingDescription, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Notification Setting Success',
                'message' => 'The notification setting has been updated successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Enable methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: enableSystemNotificationChannel
    # Description: 
    # Enable the notification setting system notification channel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function enableSystemNotificationChannel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id'])) {
            $userID = $_SESSION['user_account_id'];
            $notificationSettingID = htmlspecialchars($_POST['notification_setting_id'], ENT_QUOTES, 'UTF-8');
        
            $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
            $total = $checkNotificationSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Enable System Notification Channel Error',
                    'message' => 'The notification setting has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->notificationSettingModel->updateSystemNotificationChannelStatus($notificationSettingID, 1, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Enable System Notification Channel Success',
                'message' => 'The system notification channel has been enabled successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: enableEmailNotificationChannel
    # Description: 
    # Enable the notification setting email notification channel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function enableEmailNotificationChannel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id'])) {
            $userID = $_SESSION['user_account_id'];
            $notificationSettingID = htmlspecialchars($_POST['notification_setting_id'], ENT_QUOTES, 'UTF-8');
        
            $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
            $total = $checkNotificationSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Enable Email Notification Channel Error',
                    'message' => 'The notification setting has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->notificationSettingModel->updateEmailNotificationChannelStatus($notificationSettingID, 1, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Enable Email Notification Channel Success',
                'message' => 'The email notification channel has been enabled successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: enableSMSNotificationChannel
    # Description: 
    # Enable the notification setting SMS notification channel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function enableSMSNotificationChannel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id'])) {
            $userID = $_SESSION['user_account_id'];
            $notificationSettingID = htmlspecialchars($_POST['notification_setting_id'], ENT_QUOTES, 'UTF-8');
        
            $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
            $total = $checkNotificationSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Enable SMS Notification Channel Error',
                    'message' => 'The notification setting has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->notificationSettingModel->updateSMSNotificationChannelStatus($notificationSettingID, 1, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Enable SMS Notification Channel Success',
                'message' => 'The SMS notification channel has been enabled successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Disable methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: disableSystemNotificationChannel
    # Description: 
    # Enable the notification setting system notification channel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function disableSystemNotificationChannel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id'])) {
            $userID = $_SESSION['user_account_id'];
            $notificationSettingID = htmlspecialchars($_POST['notification_setting_id'], ENT_QUOTES, 'UTF-8');
        
            $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
            $total = $checkNotificationSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Disable System Notification Channel Error',
                    'message' => 'The notification setting has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->notificationSettingModel->updateSystemNotificationChannelStatus($notificationSettingID, 0, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Disable System Notification Channel Success',
                'message' => 'The system notification channel has been disabled successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: disableEmailNotificationChannel
    # Description: 
    # Enable the notification setting email notification channel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function disableEmailNotificationChannel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id'])) {
            $userID = $_SESSION['user_account_id'];
            $notificationSettingID = htmlspecialchars($_POST['notification_setting_id'], ENT_QUOTES, 'UTF-8');
        
            $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
            $total = $checkNotificationSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Disable Email Notification Channel Error',
                    'message' => 'The notification setting has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->notificationSettingModel->updateEmailNotificationChannelStatus($notificationSettingID, 0, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Disable Email Notification Channel Success',
                'message' => 'The email notification channel has been disabled successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: disableSMSNotificationChannel
    # Description: 
    # Enable the notification setting SMS notification channel if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function disableSMSNotificationChannel() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id'])) {
            $userID = $_SESSION['user_account_id'];
            $notificationSettingID = htmlspecialchars($_POST['notification_setting_id'], ENT_QUOTES, 'UTF-8');
        
            $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
            $total = $checkNotificationSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Disable SMS Notification Channel Error',
                    'message' => 'The notification setting has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->notificationSettingModel->updateSMSNotificationChannelStatus($notificationSettingID, 0, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Disable SMS Notification Channel Success',
                'message' => 'The SMS notification channel has been disabled successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteNotificationSetting
    # Description: 
    # Delete the notification setting if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteNotificationSetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id'])) {
            $notificationSettingID = htmlspecialchars($_POST['notification_setting_id'], ENT_QUOTES, 'UTF-8');
        
            $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
            $total = $checkNotificationSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Notification Setting Error',
                    'message' => 'The notification setting has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->notificationSettingModel->deleteNotificationSetting($notificationSettingID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Notification Setting Success',
                'message' => 'The notification setting has been deleted successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteMultipleNotificationSetting
    # Description: 
    # Delete the selected notification settings if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleNotificationSetting() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id'])) {
            $notificationSettingIDs = $_POST['notification_setting_id'];
    
            foreach($notificationSettingIDs as $notificationSettingID){
                $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
                $total = $checkNotificationSettingExist['total'] ?? 0;

                if($total > 0){
                    $this->notificationSettingModel->deleteNotificationSetting($notificationSettingID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Notification Setting Success',
                'message' => 'The selected notification settings have been deleted successfully.',
                'messageType' => 'success'
            ];
            
            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get details methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getNotificationSettingDetails
    # Description: 
    # Handles the retrieval of notification setting details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getNotificationSettingDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['notification_setting_id']) && !empty($_POST['notification_setting_id'])) {
            $userID = $_SESSION['user_account_id'];
            $notificationSettingID = htmlspecialchars($_POST['notification_setting_id'], ENT_QUOTES, 'UTF-8');

            $checkNotificationSettingExist = $this->notificationSettingModel->checkNotificationSettingExist($notificationSettingID);
            $total = $checkNotificationSettingExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get notification setting Details Error',
                    'message' => 'The notification setting has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $notificationSettingDetails = $this->notificationSettingModel->getNotificationSetting($notificationSettingID);
            $smtpAutoTLS = $notificationSettingDetails['smtp_auto_tls'] ?? null;
            $smtpAuth = $notificationSettingDetails['smtp_auth'] ?? null;
            
            $smtpAutoTLSSummary = ($smtpAutoTLS == 1) ? 'Yes' : 'No';
            $smtpAuthSummary = ($smtpAuth == 1) ? 'Yes' : 'No';

            $response = [
                'success' => true,
                'notificationSettingName' => $notificationSettingDetails['notification_setting_name'] ?? null,
                'notificationSettingDescription' => $notificationSettingDetails['notification_setting_description'] ?? null,
                'systemNotification' => $notificationSettingDetails['system_notification'] ?? null,
                'emailNotification' => $notificationSettingDetails['email_notification'] ?? null,
                'smsNotification' => $notificationSettingDetails['sms_notification'] ?? null
            ];

            echo json_encode($response);
            exit;
        }
        else{
            $response = [
                'success' => false,
                'title' => 'Transaction Error',
                'message' => 'Something went wrong. Please try again later. If the issue persists, please contact support for assistance.',
                'messageType' => 'error'
            ];
            
            echo json_encode($response);
            exit;
        }
    }
    # -------------------------------------------------------------
}
# -------------------------------------------------------------

require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/system-model.php';
require_once '../../notification-setting/model/notification-setting-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new NotificationSettingController(new notificationSettingModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>