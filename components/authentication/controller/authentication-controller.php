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
    # - @param AuthenticationModel $authenticationModel     The authenticationModel instance for address type related operations.
    # - @param SystemModel $systemModel     The SystemModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(AddressTypeModel $authenticationModel, SystemModel $systemModel, SecurityModel $securityModel) {
        $this->authenticationModel = $authenticationModel;
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
                default:
                    echo json_encode(['success' => false, 'message' => 'Invalid transaction.']);
                    break;
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
        $rememberMe = isset($_POST['remember_me']);

        $checkUserExist = $this->authenticationModel->checkUserExist(null, $email);
        $total = $checkUserExist['total'] ?? 0;
    
        if ($total > 0) {
            echo json_encode(['success' => false, 'message' => 'The email or password you entered is invalid. Please double-check your credentials and try again.']);
            exit;
        }
    
        $userID = $user['user_id'];
        $userPassword = $this->securityModel->decryptData($user['password']);
        $encryptedUserID = $this->securityModel->encryptData($userID);

        $contactDetails = $this->userModel->getContactByID($userID);
        $contactID = $contactDetails['contact_id'] ?? null;

        if(!empty($contactID)){
            $contactDetails = $this->employeeModel->getEmployee($contactID);
            $portalAccess = $contactDetails['portal_access'] ?? 0;
        }
        else{
            $portalAccess = 0;
        }        
    
        if ($password !== $userPassword) {
            $this->handleInvalidCredentials($user);
            return;
        }
    
        if (!$user || !$user['is_active'] || (!empty($contactID) && !$portalAccess)) {
            echo json_encode(['success' => false, 'message' => 'Your account is currently inactive. Please contact the administrator for assistance.']);
            exit;
        }
    
        if ($this->passwordHasExpired($user)) {
            $this->handlePasswordExpiration($user, $email, $encryptedUserID);
            exit;
        }
    
        if ($user['is_locked']) {
            $this->handleAccountLock($user);
            exit;
        }
    
        $this->userModel->updateLoginAttempt($userID, 0, null);
    
        if ($user['two_factor_auth']) {
            $this->handleTwoFactorAuth($user, $email, $encryptedUserID, $rememberMe);
            exit;
        }
    
        $this->updateConnectionAndRememberToken($user, $rememberMe);
        $_SESSION['user_id'] = $userID;
        $_SESSION['contact_id'] = $contactID;
    
        echo json_encode(['success' => true, 'twoFactorAuth' => false]);
        exit;
    }
    # -------------------------------------------------------------
}

require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/system-model.php';

$controller = new AuthenticationController(new AuthenticationModel(new DatabaseModel), new SecurityModel(), new SystemModel());
$controller->handleRequest();
?>