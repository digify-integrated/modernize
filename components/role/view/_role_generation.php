<?php
require_once '../../../session.php';
require_once '../../global/config/config.php';
require_once '../../global/model/database-model.php';
require_once '../../global/model/system-model.php';
require_once '../../user/model/user-model.php';
require_once '../../role/model/role-model.php';
require_once '../../global/model/security-model.php';

$databaseModel = new DatabaseModel();
$systemModel = new SystemModel();
$userModel = new UserModel($databaseModel);
$roleModel = new RoleModel($databaseModel);
$securityModel = new SecurityModel();

if(isset($_POST['type']) && !empty($_POST['type'])){
    $type = htmlspecialchars($_POST['type'], ENT_QUOTES, 'UTF-8');
    $response = [];
    
    switch ($type) {
        # -------------------------------------------------------------
        #
        # Type: role table
        # Description:
        # Generates the role table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'role table':
            $sql = $databaseModel->getConnection()->prepare('CALL generateRoleTable()');
            $sql->execute();
            $options = $sql->fetchAll(PDO::FETCH_ASSOC);
            $sql->closeCursor();

            foreach ($options as $row) {
                $roleID = $row['role_id'];
                $roleName = $row['role_name'];
                $roleDescription = $row['role_description'];

                $roleIDEncrypted = $securityModel->encryptData($roleID);

                $response[] = [
                    'CHECK_BOX' => '<input class="form-check-input datatable-checkbox-children" type="checkbox" value="'. $roleID .'">',
                    'ROLE_NAME' => '<div class="ms-3">
                                        <div class="user-meta-info">
                                            <h6 class="user-name mb-0">'. $roleName .'</h6>
                                            <small>'. $roleDescription .'</small>
                                        </div>
                                    </div>',
                    'ACTION' => '<div class="d-flex gap-2">
                                    <a href="role.php?id='. $roleIDEncrypted .'" class="text-info" title="View Details">
                                        <i class="ti ti-eye fs-5"></i>
                                    </a>
                                    <a href="javascript:void(0);" class="text-danger ms-3 delete-role" data-role-id="' . $roleID . '" title="Delete Menu Group">
                                        <i class="ti ti-trash fs-5"></i>
                                    </a>
                                </div>'
                ];
            }

            echo json_encode($response);
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: assigned menu item permission table
        # Description:
        # Generates the assigned menu item permission table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'assigned menu item permission table':
            if(isset($_POST['role_id']) && !empty($_POST['role_id'])){
                $roleID = htmlspecialchars($_POST['role_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateRoleMenuItemPermissionTable(:roleID)');
                $sql->bindValue(':roleID', $roleID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $rolePermissionID = $row['role_permission_id'];
                    $menuItemName = $row['menu_item_name'];
                    $readAccess = $row['read_access'];
                    $writeAccess = $row['write_access'];
                    $createAccess = $row['create_access'];
                    $deleteAccess = $row['delete_access'];

                    $readAccessChecked = $readAccess ? 'checked' : '';
                    $writeAccessChecked = $writeAccess ? 'checked' : '';
                    $createAccessChecked = $createAccess ? 'checked' : '';
                    $deleteAccessChecked = $deleteAccess ? 'checked' : '';

                    $readAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="read" ' . $readAccessChecked . '>
                                        </div>';

                    $writeAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="write" ' . $writeAccessChecked . '>
                                        </div>';

                    $createAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="create" ' . $createAccessChecked . '>
                                        </div>';

                    $deleteAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="delete" ' . $deleteAccessChecked . '>
                                        </div>';

                    $response[] = [
                        'MENU_ITEM' => $menuItemName,
                        'READ_ACCESS' => $readAccessButton,
                        'WRITE_ACCESS' => $writeAccessButton,
                        'CREATE_ACCESS' => $createAccessButton,
                        'DELETE_ACCESS' => $deleteAccessButton,
                        'ACTION' => '<div class="d-flex gap-2">
                                        <a href="javascript:void(0);" class="text-info view-role-permission-log-notes" data-role-permission-id="' . $rolePermissionID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                            <i class="ti ti-file-text fs-5"></i>
                                        </a>
                                        <a href="javascript:void(0);" class="text-danger ms-3 delete-role-permission" data-role-permission-id="' . $rolePermissionID . '" title="Delete Role Permission">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>
                                    </div>'
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: assigned role permission table
        # Description:
        # Generates the assigned role permission table.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'assigned role permission table':
            if(isset($_POST['menu_item_id']) && !empty($_POST['menu_item_id'])){
                $menuItemID = htmlspecialchars($_POST['menu_item_id'], ENT_QUOTES, 'UTF-8');

                $sql = $databaseModel->getConnection()->prepare('CALL generateMenuItemRolePermissionTable(:menuItemID)');
                $sql->bindValue(':menuItemID', $menuItemID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $rolePermissionID = $row['role_permission_id'];
                    $roleName = $row['role_name'];
                    $readAccess = $row['read_access'];
                    $writeAccess = $row['write_access'];
                    $createAccess = $row['create_access'];
                    $deleteAccess = $row['delete_access'];

                    $readAccessChecked = $readAccess ? 'checked' : '';
                    $writeAccessChecked = $writeAccess ? 'checked' : '';
                    $createAccessChecked = $createAccess ? 'checked' : '';
                    $deleteAccessChecked = $deleteAccess ? 'checked' : '';

                    $readAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="read" ' . $readAccessChecked . '>
                                        </div>';

                    $writeAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="write" ' . $writeAccessChecked . '>
                                        </div>';

                    $createAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="create" ' . $createAccessChecked . '>
                                        </div>';

                    $deleteAccessButton = '<div class="form-check form-check-inline">
                                            <input class="form-check-input success update-role-permission" type="checkbox" data-role-permission-id="' . $rolePermissionID . '" data-access-type="delete" ' . $deleteAccessChecked . '>
                                        </div>';

                    $response[] = [
                        'ROLE' => $roleName,
                        'READ_ACCESS' => $readAccessButton,
                        'WRITE_ACCESS' => $writeAccessButton,
                        'CREATE_ACCESS' => $createAccessButton,
                        'DELETE_ACCESS' => $deleteAccessButton,
                        'ACTION' => '<div class="d-flex gap-2">
                                        <a href="javascript:void(0);" class="text-info view-role-permission-log-notes" data-role-permission-id="' . $rolePermissionID . '" data-bs-toggle="offcanvas" data-bs-target="#log-notes-offcanvas" aria-controls="log-notes-offcanvas" title="View Log Notes">
                                            <i class="ti ti-file-text fs-5"></i>
                                        </a>
                                        <a href="javascript:void(0);" class="text-danger ms-3 delete-role-permission" data-role-permission-id="' . $rolePermissionID . '" title="Delete Role Permission">
                                            <i class="ti ti-trash fs-5"></i>
                                        </a>
                                    </div>'
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------

        # -------------------------------------------------------------
        #
        # Type: menu item role dual listbox options
        # Description:
        # Generates the menu item role dual listbox options.
        #
        # Parameters: None
        #
        # Returns: Array
        #
        # -------------------------------------------------------------
        case 'menu item role dual listbox options':
            if(isset($_POST['menu_item_id']) && !empty($_POST['menu_item_id'])){
                $menuItemID = htmlspecialchars($_POST['menu_item_id'], ENT_QUOTES, 'UTF-8');
                $sql = $databaseModel->getConnection()->prepare('CALL generateMenuItemRoleDualListBoxOptions(:menuItemID)');
                $sql->bindValue(':menuItemID', $menuItemID, PDO::PARAM_INT);
                $sql->execute();
                $options = $sql->fetchAll(PDO::FETCH_ASSOC);
                $sql->closeCursor();

                foreach ($options as $row) {
                    $response[] = [
                        'id' => $row['role_id'],
                        'text' => $row['role_name']
                    ];
                }

                echo json_encode($response);
            }
        break;
        # -------------------------------------------------------------
    }
}

?>