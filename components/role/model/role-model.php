<?php
/**
* Class RoleModel
*
* The RoleModel class handles role related operations and interactions.
*/
class RoleModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateRole
    # Description: Updates the role.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    # - $p_role_name (string): The role name.
    # - $p_role_description (int): The role description of role.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateRole($p_role_id, $p_role_name, $p_role_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateRole(:p_role_id, :p_role_name, :p_role_description, :p_last_log_by)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_role_name', $p_role_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_role_description', $p_role_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertRole
    # Description: Inserts the role.
    #
    # Parameters:
    # - $p_role_name (string): The role name.
    # - $p_role_description (int): The role description of role.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertRole($p_role_name, $p_role_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertRole(:p_role_name, :p_role_description, :p_last_log_by, @p_role_id)');
        $stmt->bindValue(':p_role_name', $p_role_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_role_description', $p_role_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_role_id AS role_id');
        $menuGroupID = $result->fetch(PDO::FETCH_ASSOC)['role_id'];
        
        return $menuGroupID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertRolePermission
    # Description: Inserts the role permission.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    # - $p_menu_item_id (int): The menu item ID.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertRolePermission($p_role_id, $p_menu_item_id, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertRolePermission(:p_role_id, :p_menu_item_id, :p_last_log_by)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_menu_item_id', $p_menu_item_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkRoleExist
    # Description: Checks if a role exists.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkRoleExist($p_role_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkRoleExist(:p_role_id)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteRole
    # Description: Deletes the role.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteRole($p_role_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteRole(:p_role_id)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getRole
    # Description: Retrieves the details of a role.
    #
    # Parameters:
    # - $p_role_id (int): The role ID.
    #
    # Returns:
    # - An array containing the role details.
    #
    # -------------------------------------------------------------
    public function getRole($p_role_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getRole(:p_role_id)');
        $stmt->bindValue(':p_role_id', $p_role_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>