<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../state/model/state-model.php';
require_once '../../global/model/security-model.php';
require_once '../../global/model/global-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$stateModel = new StateModel($databaseModel);
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
        # Type: state table
        # Description:
        # Generates the state table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'state table':
            $filterByCountry = isset($_POST['filter_by_country']) ? htmlspecialchars($_POST['filter_by_country'], ENT_QUOTES, 'UTF-8') : null;
            $sql = $databaseModel->getConnection()->prepare('CALL generateStateTable(:filterByCountry)');
            $sql->bindValue(':filterByCountry', $filterByCountry, PDO::PARAM_INT);
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $stateDeleteAccess = $globalModel->checkAccessRights($userID, $pageID, 'delete');

            foreach ($options as $row) {
                $stateID = $row['state_id'];
                $stateName = $row['state_name'];
                $countryName = $row['country_name'];

                $stateIDEncrypted = $securityModel->encryptData($stateID);

                $deleteButton = '';
                if($stateDeleteAccess['total'] > 0){
                    $deleteButton = '<a href="javascript:void(0);" class="text-danger ms-3 delete-state" data-state-id="' . $stateID . '" title="Delete State">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>';
                }

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $stateID .'">',
                    'STATE_NAME' => $stateName,
                    'COUNTRY_NAME' => $countryName,
                    'ACTION' => '<div class="action-btn">
                                    <a href="'. $pageLink .'&id='. $stateIDEncrypted .'" class="text-info" title="View Details">
                                        <i class="ti ti-eye fs-5"></i>
                                    </a>
                                   '. $deleteButton .'
                                </div>'
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>