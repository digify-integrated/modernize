<?php
session_start();

# -------------------------------------------------------------
#
# Function: MenuItemController
# Description: 
# The MenuItemController class handles menu item related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class MenuItemController {
    private $menuItemModel;
    private $menuGroupModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided menuItemModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for menu item related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param menuItemModel $menuItemModel     The menuItemModel instance for menu item related operations.
    # - @param MenuGroupModel $menuGroupModel     The menuGroupModel instance for menu group related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(MenuItemModel $menuItemModel, MenuGroupModel $menuGroupModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->menuItemModel = $menuItemModel;
        $this->menuGroupModel = $menuGroupModel;
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
                case 'add menu item':
                    $this->addMenuItem();
                    break;
                case 'update menu item':
                    $this->updateMenuItem();
                    break;
                case 'get menu item details':
                    $this->getMenuItemDetails();
                    break;
                case 'delete menu item':
                    $this->deleteMenuItem();
                    break;
                case 'delete multiple menu item':
                    $this->deleteMultipleMenuItem();
                    break;
                case 'duplicate menu item':
                    $this->duplicateMenuItem();
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
    # Function: addMenuItem
    # Description: 
    # Inserts a menu item.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addMenuItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['menu_item_name']) && !empty($_POST['menu_item_name']) && isset($_POST['menu_group']) && !empty($_POST['menu_group']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence']) && isset($_POST['menu_item_url']) && isset($_POST['menu_item_icon'])) {
            $userID = $_SESSION['user_id'];
            $menuItemName = htmlspecialchars($_POST['menu_item_name'], ENT_QUOTES, 'UTF-8');
            $orderSequence = htmlspecialchars($_POST['order_sequence'], ENT_QUOTES, 'UTF-8');
            $menuGroup = htmlspecialchars($_POST['menu_group'], ENT_QUOTES, 'UTF-8');
            $parentID = isset($_POST['parent_id']) ? htmlspecialchars($_POST['parent_id'], ENT_QUOTES, 'UTF-8') : null;
            $menuItemURL = htmlspecialchars($_POST['menu_item_url'], ENT_QUOTES, 'UTF-8');
            $menuItemIcon = htmlspecialchars($_POST['menu_item_icon'], ENT_QUOTES, 'UTF-8');

            $menuGroupDetails = $this->menuGroupModel->getMenuGroup($menuGroup);
            $menuGroupName = $menuGroupDetails['menu_group_name'] ?? null;

            $parentMenuItemDetails = $this->menuItemModel->getMenuItem($parentID);
            $parentName = $parentMenuItemDetails['menu_group_name'] ?? null;
        
            $menuItemID = $this->menuItemModel->insertMenuItem($menuItemName, $menuItemURL, $menuGroup, $menuGroupName, $parentID, $parentName, $menuItemIcon, $orderSequence, $userID);
    
            $response = [
                'success' => true,
                'menuItemID' => $this->securityModel->encryptData($menuItemID),
                'title' => 'Insert Menu Item Success',
                'message' => 'The menu item has been inserted successfully.',
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
    # Function: updateMenuItem
    # Description: 
    # Updates the menu item if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateMenuItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['menu_item_id']) && !empty($_POST['menu_item_id']) && isset($_POST['menu_item_name']) && !empty($_POST['menu_item_name']) && isset($_POST['menu_group']) && !empty($_POST['menu_group']) && isset($_POST['order_sequence']) && !empty($_POST['order_sequence']) && isset($_POST['parent_id']) && isset($_POST['menu_item_url']) && isset($_POST['menu_item_icon'])) {
            $userID = $_SESSION['user_id'];
            $menuItemID = htmlspecialchars($_POST['menu_item_id'], ENT_QUOTES, 'UTF-8');
            $menuItemName = htmlspecialchars($_POST['menu_item_name'], ENT_QUOTES, 'UTF-8');
            $orderSequence = htmlspecialchars($_POST['order_sequence'], ENT_QUOTES, 'UTF-8');
            $menuGroup = htmlspecialchars($_POST['menu_group'], ENT_QUOTES, 'UTF-8');
            $parentID = htmlspecialchars($_POST['parent_id'], ENT_QUOTES, 'UTF-8');
            $menuItemURL = htmlspecialchars($_POST['menu_item_url'], ENT_QUOTES, 'UTF-8');
            $menuItemIcon = htmlspecialchars($_POST['menu_item_icon'], ENT_QUOTES, 'UTF-8');
        
            $checkMenuItemExist = $this->menuItemModel->checkMenuItemExist($menuItemID);
            $total = $checkMenuItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update Menu Item Error',
                    'message' => 'The menu item has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $menuGroupDetails = $this->menuGroupModel->getMenuGroup($menuGroup);
            $menuGroupName = $menuGroupDetails['menu_group_name'] ?? null;

            $parentMenuItemDetails = $this->menuItemModel->getMenuItem($parentID);
            $parentName = $parentMenuItemDetails['menu_group_name'] ?? null;

            $this->menuItemModel->updateMenuItem($menuItemID, $menuItemName, $menuItemURL, $menuGroup, $menuGroupName, $parentID, $parentName, $menuItemIcon, $orderSequence, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update Menu Item Success',
                'message' => 'The menu item has been updated successfully.',
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
    # Function: deleteMenuItem
    # Description: 
    # Delete the menu item if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMenuItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['menu_item_id']) && !empty($_POST['menu_item_id'])) {
            $menuItemID = htmlspecialchars($_POST['menu_item_id'], ENT_QUOTES, 'UTF-8');
        
            $checkMenuItemExist = $this->menuItemModel->checkMenuItemExist($menuItemID);
            $total = $checkMenuItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete Menu Item Error',
                    'message' => 'The menu item has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->menuItemModel->deleteMenuItem($menuItemID);
                
            $response = [
                'success' => true,
                'title' => 'Delete Menu Item Success',
                'message' => 'The menu item has been deleted successfully.',
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
    # Function: deleteMultipleMenuItem
    # Description: 
    # Delete the selected menu items if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleMenuItem() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['menu_item_id']) && !empty($_POST['menu_item_id'])) {
            $menuItemIDs = $_POST['menu_item_id'];
    
            foreach($menuItemIDs as $menuItemID){
                $checkMenuItemExist = $this->menuItemModel->checkMenuItemExist($menuItemID);
                $total = $checkMenuItemExist['total'] ?? 0;

                if($total > 0){
                    $this->menuItemModel->deleteMenuItem($menuItemID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple Menu Item Success',
                'message' => 'The selected menu items have been deleted successfully.',
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
    # Function: getMenuItemDetails
    # Description: 
    # Handles the retrieval of menu item details such as menu item name, order sequence, etc.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getMenuItemDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['menu_item_id']) && !empty($_POST['menu_item_id'])) {
            $userID = $_SESSION['user_id'];
            $menuItemID = htmlspecialchars($_POST['menu_item_id'], ENT_QUOTES, 'UTF-8');

            $checkMenuItemExist = $this->menuItemModel->checkMenuItemExist($menuItemID);
            $total = $checkMenuItemExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get menu item Details Error',
                    'message' => 'The menu item has does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $menuItemDetails = $this->menuItemModel->getMenuItem($menuItemID);

            $response = [
                'success' => true,
                'menuItemName' => $menuItemDetails['menu_item_name'] ?? null,
                'menuItemURL' => $menuItemDetails['menu_item_url'] ?? null,
                'menuItemID' => $menuItemDetails['menu_group_id'] ?? null,
                'menuItemName' => $menuItemDetails['menu_group_name'] ?? null,
                'parentID' => $menuItemDetails['parent_id'] ?? null,
                'parentName' => $menuItemDetails['parent_name'] ?? null,
                'menuItemIcon' => $menuItemDetails['menu_item_icon'] ?? null,
                'orderSequence' => $menuItemDetails['order_sequence'] ?? null
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
require_once '../../menu-item/model/menu-item-model.php';
require_once '../../menu-group/model/menu-group-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new MenuItemController(new menuItemModel(new DatabaseModel), new MenuGroupModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>