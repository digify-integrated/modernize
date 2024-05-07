<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../upload-setting/model/upload-setting-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$uploadSettingModel = new UploadSettingModel($databaseModel);
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
        # Type: upload setting table
        # Description:
        # Generates the upload setting table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'upload setting table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateUploadSettingTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $uploadSettingDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $uploadSettingID = $row['upload_setting_id'];
                $uploadSettingName = $row['upload_setting_name'];
                $description = $row['description'];
                $maxFileSize = $row['max_file_size'];

                $uploadSettingIDEncrypted = $securityModel->encryptData($uploadSettingID);

                $deleteButton = '';
                if($uploadSettingDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-upload-setting" data-upload-setting-id="' . $uploadSettingID . '" title="Delete Menu Item">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $uploadSettingID .'">',
                    'UPLOAD_SETTING' => '<div class="d-flex align-items-center">
                                                <div class="ms-3">
                                                    <div class="user-meta-info">
                                                        <h6 class="user-name mb-0">'. $uploadSettingName .'</h6>
                                                        <small>'. $description .'</small>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>',
                    'MAX_FILE_SIZE' => $maxFileSize . ' kb',
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $uploadSettingIDEncrypted .'" class="text-info" title="View Details">
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
        # Type: subupload setting table
        # Description:
        # Generates the subupload setting table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'subupload setting table':
            if(isset($_POST['upload_setting_id']) && !empty($_POST['upload_setting_id'])){
                $uploadSettingID = htmlspecialchars($_POST['upload_setting_id'], ENT_QUOTES, 'UTF-8');
                $sql = $databaseModel->getConnection()->prepare('CALL generateSubuploadSettingTable(:uploadSettingID)');
                $sql->bindValue(':uploadSettingID', $uploadSettingID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();
    
                foreach ($options as $row) {
                    $uploadSettingName = $row['upload_setting_name'];
                    $orderSequence = $row['order_sequence'];
    
                    $uploadSettingIDEncrypted = $securityModel->encryptData($uploadSettingID);
    
                    $response[] = [
                        'MENU_ITEM_NAME' => $uploadSettingName,
                        'ORDER_SEQUENCE' => $orderSequence,
                    ];
                }
    
                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: upload setting options
        # Description:
        # Generates the upload setting options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'upload setting options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateUploadSettingOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $uploadSettingID = $row['upload_setting_id'];
                $uploadSettingName = $row['upload_setting_name'];

                $response[] = [
                    'id' => $row['upload_setting_id'],
                    'text' => $row['upload_setting_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: role upload setting dual listbox options
        # Description:
        # Generates the role upload setting dual listbox options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'role upload setting dual listbox options':
            if(isset($_POST['role_id']) && !empty($_POST['role_id'])){
                $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');
                $sql = $databaseModel->getConnection()->prepare('CALL generateRoleUploadSettingDualListBoxOptions(:roleID)');
                $sql->bindValue(':roleID', $roleID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $response[] = [
                        'id' => $row['upload_setting_id'],
                        'text' => $row['upload_setting_name']
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------
    }
}

?>