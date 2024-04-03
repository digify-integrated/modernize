<?php
session_start();

# -------------------------------------------------------------
#
# Function: UserAccountController
# Description: 
# The UserAccountController class handles user account related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class UserAccountController {
    private $userAccountModel;
    private $roleModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided RoleModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for role related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param UserAccountModel $userAccountModel     The UserAccountModel instance for user account related operations.
    # - @param RoleModel $roleModel     The RoleModel instance for role related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(UserAccountModel $userAccountModel, RoleModel $roleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->userAccountModel = $userAccountModel;
        $this->roleModel = $roleModel;
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
            $userID = $_SESSION['user_id'];
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
            
            if ($sessionToken != $sessionToken && $0 == 'No') {
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
                case 'add user account':
                    $this->addUserAccount();
                    break;
                case 'update user account':
                    $this->updateUserAccount();
                    break;
                case 'get user account details':
                    $this->getUserAccountDetails();
                    break;
                case 'delete user account':
                    $this->deleteUserAccount();
                    break;
                case 'delete multiple user account':
                    $this->deleteMultipleUserAccount();
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
    # Function: addUserAccount
    # Description: 
    # Inserts a user account.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['file_as']) && !empty($_POST['file_as']) && isset($_POST['email']) && !empty($_POST['email']) && isset($_POST['password']) && !empty($_POST['password'])) {
            $userID = $_SESSION['user_id'];
            $fileAs = htmlspecialchars($_POST['file_as'], ENT_QUOTES, 'UTF-8');
            $email = htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8');
            $password = $this->securityModel->encryptData($_POST['password']);
        
            $userAccountID = $this->userAccountModel->insertUserAccount($fileAs, $email, $password, $userID);
    
            $response = [
                'success' => true,
                'userAccountID' => $this->securityModel->encryptData($userAccountID),
                'title' => 'Insert User Account Success',
                'message' => 'The user account has been inserted successfully.',
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
    # Function: updateUserAccount
    # Description: 
    # Updates the user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id']) && isset($_POST['file_as']) && !empty($_POST['file_as']) && isset($_POST['email']) && !empty($_POST['email']) && isset($_POST['password'])) {
            $userID = $_SESSION['user_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
            $fileAs = htmlspecialchars($_POST['file_as'], ENT_QUOTES, 'UTF-8');
            $email = htmlspecialchars($_POST['email'], ENT_QUOTES, 'UTF-8');
            $password = !empty($_POST['password']) ? $this->securityModel->encryptData($_POST['password']) : null;
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update User Account Error',
                    'message' => 'The user account has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->updateUserAccount($userAccountID, $fileAs, $email, $password, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update User Account Success',
                'message' => 'The user account has been updated successfully.',
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
    # Function: deleteUserAccount
    # Description: 
    # Delete the user account if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');
        
            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete User Account Error',
                    'message' => 'The user account has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->userAccountModel->deleteUserAccount($userAccountID);
                
            $response = [
                'success' => true,
                'title' => 'Delete User Account Success',
                'message' => 'The user account has been deleted successfully.',
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
    # Function: deleteMultipleUserAccount
    # Description: 
    # Delete the selected user accounts if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleUserAccount() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userAccountIDs = $_POST['user_account_id'];
    
            foreach($userAccountIDs as $userAccountID){
                $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
                $total = $checkUserAccountExist['total'] ?? 0;

                if($total > 0){
                    $this->userAccountModel->deleteUserAccount($userAccountID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple User Account Success',
                'message' => 'The selected user accounts have been deleted successfully.',
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
    # Function: getUserAccountDetails
    # Description: 
    # Handles the retrieval of user account details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getUserAccountDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['user_account_id']) && !empty($_POST['user_account_id'])) {
            $userID = $_SESSION['user_id'];
            $userAccountID = htmlspecialchars($_POST['user_account_id'], ENT_QUOTES, 'UTF-8');

            $checkUserAccountExist = $this->userAccountModel->checkUserAccountExist($userAccountID);
            $total = $checkUserAccountExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get User Account Details Error',
                    'message' => 'The user account has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $userAccountDetails = $this->userAccountModel->getUserAccount($userAccountID, null);

            $response = [
                'success' => true,
                'fileAs' => $userAccountDetails['file_as'] ?? null,
                'email' => $userAccountDetails['email'] ?? null
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
require_once '../../user-account/model/user-account-model.php';
require_once '../../role/model/role-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new UserAccountController(new UserAccountModel(new DatabaseModel), new RoleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>