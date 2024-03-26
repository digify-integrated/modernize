<?php
session_start();

# -------------------------------------------------------------
#
# Function: RoleController
# Description: 
# The RoleController class handles role related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class RoleController {
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
    # - @param RoleModel $roleModel     The RoleModel instance for role related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(RoleModel $roleModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
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
                case 'add role':
                    $this->addRole();
                    break;
                case 'assign role permission':
                    $this->assignRolePermission();
                    break;
                case 'update role':
                    $this->updateRole();
                    break;
                case 'get role details':
                    $this->getRoleDetails();
                    break;
                case 'delete role':
                    $this->deleteRole();
                    break;
                case 'delete multiple role':
                    $this->deleteMultipleRole();
                    break;
                case 'duplicate role':
                    $this->duplicateRole();
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
    # Function: addRole
    # Description: 
    # Inserts a role.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_name']) && !empty($_POST['role_name']) && isset($_POST['role_description']) && !empty($_POST['role_description'])) {
            $userID = $_SESSION['user_id'];
            $roleName = htmlspecialchars($_POST['role_name'], ENT_QUOTES, 'UTF-8');
            $roleDescription = htmlspecialchars($_POST['role_description'], ENT_QUOTES, 'UTF-8');
        
            $roleID = $this->roleModel->insertRole($roleName, $roleDescription, $userID);
    
            $response = [
                'success' => true,
                'roleID' => $this->securityModel->encryptData($roleID),
                'title' => 'Insert Role Success',
                'message' => 'The role has been inserted successfully.',
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
    # Function: updateRole
    # Description: 
    # Updates the role if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['role_id']) && !empty($_POST['role_id']) && isset($_POST['role_name']) && !empty($_POST['role_name']) && isset($_POST['role_description']) && !empty($_POST['role_description'])) {
            $userID = $_SESSION['user_id'];
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
            $roleName = htmlspecialchars($_POST['role_name'], ENT_QUOTES, 'UTF-8');
            $roleDescription = htmlspecialchars($_POST['role_description'], ENT_QUOTES, 'UTF-8');
        
            $checkRoleExist = $this->roleModel->checkRoleExist($roleID);
            $total = $checkRoleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Role Error',
                    'message' => 'The role has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->updateRole($roleID, $roleName, $roleDescription, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Role Success',
                'message' => 'The role has been updated successfully.',
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
    #   Assign methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: assignRolePermission
    # Description: 
    # Assigns a role permission.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function assignRolePermission() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            if(!isset($_POST['menu_item_id']) || empty($_POST['menu_item_id'])){
                $response = [
                    'success' => false,
                    'title' => 'Permission Selection Required',
                    'message' => 'Please select the permission(s) you wish to assign to the role.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $userID = $_SESSION['user_id'];
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
            $menuItemIDs = $_POST['menu_item_id'];

            foreach ($menuItemIDs as $menuItemID) {
                $this->roleModel->insertRolePermission($roleID, $menuItemID, $userID);
            }
    
            $response = [
                'success' => true,
                'title' => 'Assign Role Permission Success',
                'message' => 'The role permission has been assigned successfully.',
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
    # Function: deleteRole
    # Description: 
    # Delete the role if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
        
            $checkRoleExist = $this->roleModel->checkRoleExist($roleID);
            $total = $checkRoleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Role Error',
                    'message' => 'The role has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->roleModel->deleteRole($roleID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Role Success',
                'message' => 'The role has been deleted successfully.',
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
    # Function: deleteMultipleRole
    # Description: 
    # Delete the selected roles if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleRole() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            $roleIDs = $_POST['role_id'];
    
            foreach($roleIDs as $roleID){
                $checkRoleExist = $this->roleModel->checkRoleExist($roleID);
                $total = $checkRoleExist['total'] ?? 0;

                if($total > 0){
                    $this->roleModel->deleteRole($roleID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Role Success',
                'message' => 'The selected roles have been deleted successfully.',
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
    # Function: getRoleDetails
    # Description: 
    # Handles the retrieval of role details such as role name, order sequence, etc.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getRoleDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['role_id']) && !empty($_POST['role_id'])) {
            $userID = $_SESSION['user_id'];
            $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');

            $checkRoleExist = $this->roleModel->checkRoleExist($roleID);
            $total = $checkRoleExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get Role Details Error',
                    'message' => 'The role has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $roleDetails = $this->roleModel->getRole($roleID);

            $response = [
                'success' => true,
                'roleName' => $roleDetails['role_name'] ?? null,
                'roleDescription' => $roleDetails['role_description'] ?? null
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
require_once '../../role/model/role-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new RoleController(new RoleModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>