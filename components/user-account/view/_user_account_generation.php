<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../user-account/model/user-account-model.php';
require_once '../../global/model/security-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$userAccountModel = new UserAccountModel($databaseModel);
$securityModel = new SecurityModel();

if(isset($_POST['type']) && !empty($_POST['type'])){
    $type = htmlspecialchars($_POST['type'], ENT_QUOTES, 'UTF-8');
    $response = [];
    
    switch ($type) {
        # -------------------------------------------------------------
        #
        # Type: user account table
        # Description:
        # Generates the user account table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'user account table':
            $filterByUserAccountStatus = isset($_POST['filter_by_user_account_status']) ? htmlspecialchars($_POST['filter_by_user_account_status'], ENT_QUOTES, 'UTF-8') : null;
            $filterByUserAccountLockStatus = isset($_POST['filter_by_user_account_lock_status']) ? htmlspecialchars($_POST['filter_by_user_account_lock_status'], ENT_QUOTES, 'UTF-8') : null;
            
            $filterByPasswordExpiryDate = isset($_POST['filter_by_password_expiry_date']) ? explode(' - ', $_POST['filter_by_password_expiry_date']) : null;
            $passwordExpiryStartDate = $filterByPasswordExpiryDate[0] ?? null;
            $passwordExpiryEndDate = $filterByPasswordExpiryDate[1] ?? null;
            
            $filterByLastConnectionDate = isset($_POST['filter_last_connection_date']) ? explode(' - ', $_POST['filter_last_connection_date']) : null;
            $lastConnectionStartDate = $filterByLastConnectionDate[0] ?? null;
            $lastConnectionEndDate = $filterByLastConnectionDate[1] ?? null;

            $sql = $databaseModel->getConnection()->prepare('CALL generateUserAccountTable(:filterByMenuGroup)');
            $sql->bindValue(':filterByMenuGroup', $filterByMenuGroup, PDO::PARAM_INT);
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
                    'ACTION' => '<div class="action-btn">
                                    <a href="menu-item.php?id='. $menuItemIDEncrypted .'" class="text-info" title="View Details">
                                        <i class="ti ti-eye fs-5"></i>
                                    </a>
                                    <a href="javascript:void(0);" class="text-danger ms-3 delete-menu-item" data-menu-item-id="' . $menuItemID . '" title="Delete Menu Item">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>
                                </div>'
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------
    }
}

?>