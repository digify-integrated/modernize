<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../user/model/user-model.php';
require_once '../../menu-item/model/menu-item-model.php';
require_once '../../global/model/security-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$userModel = new UserModel($databaseModel);
$menuItemModel = new MenuItemModel($databaseModel);
$securityModel = new SecurityModel();

if(isset($_POST['type']) && !empty($_POST['type'])){
    $type = htmlspecialchars($_POST['type'], ENT_QUOTES, 'UTF-8');
    $response = [];
    
    switch ($type) {
        # -------------------------------------------------------------
        #
        # Type: menu item table
        # Description:
        # Generates the menu item table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'menu item table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateMenuItemTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            foreach ($options as $row) {
                $menuItemID = $row['menu_item_id'];
                $menuItemName = $row['menu_item_name'];
                $menuGroupName = $row['menu_group_name'];
                $orderSequence = $row['order_sequence'];

                $menuItemIDEncrypted = $securityModel->encryptData($menuItemID);

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $menuItemID .'">',
                    'MENU_ITEM_NAME' => $menuItemName,
                    'MENU_GROUP_NAME' => $menuGroupName,
                    'ORDER_SEQUENCE' => $orderSequence,
                    'ACTION' => '<div class="d-flex gap-2">
                                    <a href="menu-item.php?id='. $menuItemIDEncrypted .'" class="btn btn-info rounded-circle round-40 btn-sm d-inline-flex align-items-center justify-content-center fs-3" title="View Details">
                                        <i class="ti ti-eye"></i>
                                    </a>
                                    <button type="button" class="btn btn-danger rounded-circle round-40 btn-sm d-inline-flex align-items-center justify-content-center fs-3 delete-menu-item" data-menu-item-id="' . $menuItemID . '" title="Delete Menu Item">
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
        # Type: menu item options
        # Description:
        # Generates the menu item options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'menu item options':

            $sql = $databaseModel->getConnection()->prepare('CALL generateMenuItemOptions()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            $response[] = [
                'id' => '',
                'text' => '--'
            ];

            foreach ($options as $row) {
                $menuItemID = $row['menu_item_id'];
                $menuItemName = $row['menu_item_name'];

                $response[] = [
                    'id' => $row['menu_item_id'],
                    'text' => $row['menu_item_name']
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>