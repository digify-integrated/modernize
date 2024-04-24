<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../file-extension/model/file-extension-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$fileExtensionModel = new FileExtensionModel($databaseModel);
$securityModel = new SecurityModel();
$globalModel = new GlobalModel($databaseModel, $securityModel);

if(isset($_POST['type']) && !empty($_POST['type'])){
    $type = htmlspecialchars($_POST['type'], ENT_QUOTES, 'UTF-8');
    $pageID = isset($_POST['page_id']) ? $_POST['page_id'] : null;
    $pageLink = isset($_POST['page_link']) ? $_POST['page_link'] : null;
    $response = [];
    
    switch ($type) {
        # -------------------------------------------------------------
        #
        # Type: file type table
        # Description:
        # Generates the file type table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'file type table':
            $filterByFileType = isset($_POST['filter_by_file_type']) ? htmlspecialchars($_POST['filter_by_file_type'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateFileExtensionTable(:filterByFileType)');
            $sql->bindValue(':filterByFileType', $filterByFileType, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $fileExtensionDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $fileExtensionID = $row['file_extension_id'];
                $fileExtensionName = $row['file_extension_name'];
                $fileTypeName = $row['file_type_name'];

                $fileExtensionIDEncrypted = $securityModel->encryptData($fileExtensionID);

                $deleteButton = '';
                if($fileExtensionDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-file-extension" data-file-extension-id="' . $fileExtensionID . '" title="Delete Menu Item">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $fileExtensionID .'">',
                    'FILE_EXTENSION_NAME' => $fileExtensionName,
                    'FILE_TYPE_NAME' => $fileTypeName,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $fileExtensionIDEncrypted .'" class="text-info" title="View Details">
                                        <i class="ti ti-eye fs-5"></i>
                                    </a>
                                   '. $deleteButton .'
                                </div>'
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: role file type dual listbox options
        # Description:
        # Generates the role file type dual listbox options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'role file type dual listbox options':
            if(isset($_POST['role_id']) && !empty($_POST['role_id'])){
                $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
                $sql = $databaseModel->getConnection()->prepare('CALL generateRoleFileExtensionDualListBoxOptions(:roleID)');
                $sql->bindValue(':roleID', $roleID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $response[] = [
                        'id' => $row['file_extension_id'],
                        'text' => $row['file_extension_name']
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------
    }
}

?>