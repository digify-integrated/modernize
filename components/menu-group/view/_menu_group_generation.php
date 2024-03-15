<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../user/model/user-model.php';
require_once '../../menu-group/model/menu-group-model.php';
require_once '../../global/model/security-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$userModel = new UserModel($databaseModel);
$menuGroupModel = new MenuGroupModel($databaseModel);
$securityModel = new SecurityModel();

if(isset($_POST['type']) && !empty($_POST['type'])){
    $type = htmlspecialchars($_POST['type'], ENT_QUOTES, 'UTF-8');
    $response = [];
    
    switch ($type) {
        # -------------------------------------------------------------
        #
        # Type: menu group table
        # Description:
        # Generates the menu group table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'menu group table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateMenuGroupTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            foreach ($options as $row) {
                $menuGroupID = $row['menu_group_id'];
                $menuGroupName = $row['menu_group_name'];
                $orderSequence = $row['order_sequence'];

                $menuGroupIDEncrypted = $securityModel->encryptData($menuGroupID);

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $menuGroupID .'">',
                    'MENU_GROUP_NAME' => $menuGroupName,
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="d-flex gap-2">
                                    <a href="menu-group.php?id='. $menuGroupIDEncrypted .'" class="btn btn-info rounded-circle round-40 btn-sm d-inline-flex align-items-center justify-content-center fs-3" title="View Details">
                                        <i class="ti ti-eye"></i>
                                    </a>
                                    <button type="button" class="btn btn-danger rounded-circle round-40 btn-sm d-inline-flex align-items-center justify-content-center fs-3 delete-menu-group" data-menu-group-id="' . $menuGroupID . '" title="Delete Menu Group">
                                        <i class="ti ti-trash"></i>
                                    </button>
                                </div>'
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: menu group options
        # Description:
        # Generates the menu group options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'menu group options':
            $sql = $databaseModel->getConnection()->prepare('CALL generateMenuGroupOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            foreach ($options as $row) {
                $menuGroupID = $row['menu_group_id'];
                $menuGroupName = $row['menu_group_name'];

                $response[] = [
                    'id' => $row['menu_group_id'],
                    'text' => $row['menu_group_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>