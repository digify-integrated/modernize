<?php
session_start();

# -------------------------------------------------------------
#
# Function: AppModuleController
# Description: 
# The AppModuleController class handles app module related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class AppModuleController {
    private $appModuleModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided AppModuleModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for app module related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param AppModuleModel $appModuleModel     The AppModuleModel instance for app module related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(AppModuleModel $appModuleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->appModuleModel = $appModuleModel;
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
                case 'add app module':
                    $this->addAppModule();
                    break;
                case 'update app module':
                    $this->updateAppModule();
                    break;
                case 'get app module details':
                    $this->getAppModuleDetails();
                    break;
                case 'delete app module':
                    $this->deleteAppModule();
                    break;
                case 'delete multiple app module':
                    $this->deleteMultipleAppModule();
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
    # Function: addAppModule
    # Description: 
    # Inserts a app module.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addAppModule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['app_module_name']) && !empty($_POST['app_module_name']) && isset($_POST['app_module_description']) && !empty($_POST['app_module_description']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $appModuleName = $_POST['app_module_name'];
            $appModuleDescription = $_POST['app_module_description'];
            $orderSequence = htmlspecialchars($_POST['order_sequence'], ENT_QUOTES, 'UTF-8');
        
            $appModuleID = $this->appModuleModel->insertAppModule($appModuleName, $orderSequence, $userID);
    
            $response = [
                'success' => true,
                'appModuleID' => $this->securityModel->encryptData($appModuleID),
                'title' => 'Insert App Module Success',
                'message' => 'The app module has been inserted successfully.',
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
    # Function: updateAppModule
    # Description: 
    # Updates the app module if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateAppModule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['app_module_id']) && !empty($_POST['app_module_id']) && isset($_POST['app_module_name']) && !empty($_POST['app_module_name']) && isset($_POST['app_module_description']) && !empty($_POST['app_module_description']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence'])) {
            $userID = $_SESSION['user_account_id'];
            $appModuleID = htmlspecialchars($_POST['app_module_id'], ENT_QUOTES, 'UTF-8');
            $appModuleDescription = $_POST['app_module_description'];
            $orderSequence = htmlspecialchars($_POST['order_sequence'], ENT_QUOTES, 'UTF-8');
        
            $checkAppModuleExist = $this->appModuleModel->checkAppModuleExist($appModuleID);
            $total = $checkAppModuleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update App Module Error',
                    'message' => 'The app module does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->appModuleModel->updateAppModule($appModuleID, $appModuleName, $orderSequence, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update App Module Success',
                'message' => 'The app module has been updated successfully.',
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
    # Function: deleteAppModule
    # Description: 
    # Delete the app module if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteAppModule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['app_module_id']) && !empty($_POST['app_module_id'])) {
            $appModuleID = htmlspecialchars($_POST['app_module_id'], ENT_QUOTES, 'UTF-8');
        
            $checkAppModuleExist = $this->appModuleModel->checkAppModuleExist($appModuleID);
            $total = $checkAppModuleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete App Module Error',
                    'message' => 'The app module does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->appModuleModel->deleteAppModule($appModuleID);
                
            $response = [
                'success' => true,
                'title' => 'Delete App Module Success',
                'message' => 'The app module has been deleted successfully.',
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
    # Function: deleteMultipleAppModule
    # Description: 
    # Delete the selected app modules if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleAppModule() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['app_module_id']) && !empty($_POST['app_module_id'])) {
            $appModuleIDs = $_POST['app_module_id'];
    
            foreach($appModuleIDs as $appModuleID){
                $checkAppModuleExist = $this->appModuleModel->checkAppModuleExist($appModuleID);
                $total = $checkAppModuleExist['total'] ?? 0;

                if($total > 0){
                    $this->appModuleModel->deleteAppModule($appModuleID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple App Module Success',
                'message' => 'The selected app modules have been deleted successfully.',
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
    # Function: getAppModuleDetails
    # Description: 
    # Handles the retrieval of app module details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getAppModuleDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['app_module_id']) && !empty($_POST['app_module_id'])) {
            $userID = $_SESSION['user_account_id'];
            $appModuleID = htmlspecialchars($_POST['app_module_id'], ENT_QUOTES, 'UTF-8');

            $checkAppModuleExist = $this->appModuleModel->checkAppModuleExist($appModuleID);
            $total = $checkAppModuleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get App Module Details Error',
                    'message' => 'The app module does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $appModuleDetails = $this->appModuleModel->getAppModule($appModuleID);

            $response = [
                'success' => true,
                'appModuleName' => $appModuleDetails['app_module_name'] ?? null,
                'orderSequence' => $appModuleDetails['order_sequence'] ?? null
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
require_once '../../menu-group/model/menu-group-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new AppModuleController(new AppModuleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>