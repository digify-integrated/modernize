<?php
session_start();

# -------------------------------------------------------------
#
# Function: FileTypeController
# Description: 
# The FileTypeController class handles file type related operations and interactions.
#
# Parameters: None
#
# Returns: None
#
# -------------------------------------------------------------
class FileTypeController {
    private $fileTypeModel;
    private $authenticationModel;
    private $securityModel;

    # -------------------------------------------------------------
    #
    # Function: __construct
    # Description: 
    # The constructor initializes the object with the provided FileTypeModel, AuthenticationModel and SecurityModel instances.
    # These instances are used for file type related, user related operations and security related operations, respectively.
    #
    # Parameters:
    # - @param FileTypeModel $fileTypeModel     The FileTypeModel instance for file type related operations.
    # - @param AuthenticationModel $authenticationModel     The AuthenticationModel instance for user related operations.
    # - @param SecurityModel $securityModel   The SecurityModel instance for security related operations.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function __construct(FileTypeModel $fileTypeModel, AuthenticationModel $authenticationModel, SecurityModel $securityModel) {
        $this->fileTypeModel = $fileTypeModel;
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
                case 'add file type':
                    $this->addFileType();
                    break;
                case 'update file type':
                    $this->updateFileType();
                    break;
                case 'get file type details':
                    $this->getFileTypeDetails();
                    break;
                case 'delete file type':
                    $this->deleteFileType();
                    break;
                case 'delete multiple file type':
                    $this->deleteMultipleFileType();
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
    # Function: addFileType
    # Description: 
    # Inserts a file type.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function addFileType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['file_type_name']) && !empty($_POST['file_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $fileTypeName = htmlspecialchars($_POST['file_type_name'], ENT_QUOTES, 'UTF-8');

            $fileTypeID = $this->fileTypeModel->insertFileType($fileTypeName, $userID);
    
            $response = [
                'success' => true,
                'fileTypeID' => $this->securityModel->encryptData($fileTypeID),
                'title' => 'Insert File Type Success',
                'message' => 'The file type has been inserted successfully.',
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
    # Function: updateFileType
    # Description: 
    # Updates the file type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function updateFileType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
        
        if (isset($_POST['file_type_id']) && !empty($_POST['file_type_id']) && isset($_POST['file_type_name']) && !empty($_POST['file_type_name'])) {
            $userID = $_SESSION['user_account_id'];
            $fileTypeID = htmlspecialchars($_POST['file_type_id'], ENT_QUOTES, 'UTF-8');
            $fileTypeName = htmlspecialchars($_POST['file_type_name'], ENT_QUOTES, 'UTF-8');
        
            $checkFileTypeExist = $this->fileTypeModel->checkFileTypeExist($fileTypeID);
            $total = $checkFileTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Update File Type Error',
                    'message' => 'The file type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->fileTypeModel->updateFileType($fileTypeID, $fileTypeName, $userID);
                
            $response = [
                'success' => true,
                'title' => 'Update File Type Success',
                'message' => 'The file type has been updated successfully.',
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
    # Function: deleteFileType
    # Description: 
    # Delete the file type if it exists; otherwise, return an error message.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteFileType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['file_type_id']) && !empty($_POST['file_type_id'])) {
            $fileTypeID = htmlspecialchars($_POST['file_type_id'], ENT_QUOTES, 'UTF-8');
        
            $checkFileTypeExist = $this->fileTypeModel->checkFileTypeExist($fileTypeID);
            $total = $checkFileTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Delete File Type Error',
                    'message' => 'The file type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }

            $this->fileTypeModel->deleteFileType($fileTypeID);
                
            $response = [
                'success' => true,
                'title' => 'Delete File Type Success',
                'message' => 'The file type has been deleted successfully.',
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
    # Function: deleteMultipleFileType
    # Description: 
    # Delete the selected file types if it exists; otherwise, skip it.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function deleteMultipleFileType() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }

        if (isset($_POST['file_type_id']) && !empty($_POST['file_type_id'])) {
            $fileTypeIDs = $_POST['file_type_id'];
    
            foreach($fileTypeIDs as $fileTypeID){
                $checkFileTypeExist = $this->fileTypeModel->checkFileTypeExist($fileTypeID);
                $total = $checkFileTypeExist['total'] ?? 0;

                if($total > 0){
                    $this->fileTypeModel->deleteFileType($fileTypeID);
                }
            }
                
            $response = [
                'success' => true,
                'title' => 'Delete Multiple File Type Success',
                'message' => 'The selected file types have been deleted successfully.',
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
    # Function: getFileTypeDetails
    # Description: 
    # Handles the retrieval of file type details.
    #
    # Parameters: None
    #
    # Returns: Array
    #
    # -------------------------------------------------------------
    public function getFileTypeDetails() {
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return;
        }
    
        if (isset($_POST['file_type_id']) && !empty($_POST['file_type_id'])) {
            $userID = $_SESSION['user_account_id'];
            $fileTypeID = htmlspecialchars($_POST['file_type_id'], ENT_QUOTES, 'UTF-8');

            $checkFileTypeExist = $this->fileTypeModel->checkFileTypeExist($fileTypeID);
            $total = $checkFileTypeExist['total'] ?? 0;

            if($total === 0){
                $response = [
                    'success' => false,
                    'notExist' => true,
                    'title' => 'Get File Type Details Error',
                    'message' => 'The file type does not exist.',
                    'messageType' => 'error'
                ];
                
                echo json_encode($response);
                exit;
            }
    
            $fileTypeDetails = $this->fileTypeModel->getFileType($fileTypeID);

            $response = [
                'success' => true,
                'fileTypeName' => $fileTypeDetails['file_type_name'] ?? null
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
require_once '../../file-type/model/file-type-model.php';
require_once '../../authentication/model/authentication-model.php';

$controller = new FileTypeController(new FileTypeModel(new DatabaseModel), new AuthenticationModel(new DatabaseModel), new SecurityModel());
$controller->handleRequest();

?>