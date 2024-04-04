<?php
/**
* Class UserAccountModel
*
* The UserAccountModel class handles user operations and interactions.
*/
class UserAccountModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateUserAccount
    # Description: Updates the user account.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_file_as (string): The name of the user account.
    # - $p_email (string): The email of the user account.
    # - $p_password (string): The password of the user account.
    # - $p_password_expiry_date (date): The password expiry date.
    # - $p_last_password_change (datetime): The last password change.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateUserAccount($p_user_account_id, $p_file_as, $p_email, $p_password, $p_password_expiry_date, $p_last_password_change, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateUserAccount(:p_user_account_id, :p_file_as, :p_email, :p_password, :p_password_expiry_date, :p_last_password_change, :p_last_log_by)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_file_as', $p_file_as, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_password', $p_password, PDO::PARAM_STR);
        $stmt->bindValue(':p_password_expiry_date', $p_password_expiry_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_password_change', $p_last_password_change, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertUserAccount
    # Description: Inserts the user account.
    #
    # Parameters:
    # - $p_file_as (string): The name of the user account.
    # - $p_email (string): The email of the user account.
    # - $p_password (string): The password of the user account.
    # - $p_password_expiry_date (date): The password expiry date.
    # - $p_last_password_change (datetime): The last password change.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertUserAccount($p_file_as, $p_email, $p_password, $p_password_expiry_date, $p_last_password_change, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertUserAccount(:p_file_as, :p_email, :p_password, :p_password_expiry_date, :p_last_password_change, :p_last_log_by, @p_user_account_id)');
        $stmt->bindValue(':p_file_as', $p_file_as, PDO::PARAM_STR);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->bindValue(':p_password', $p_password, PDO::PARAM_STR);
        $stmt->bindValue(':p_password_expiry_date', $p_password_expiry_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_password_change', $p_last_password_change, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_user_account_id AS user_account_id');
        $menuGroupID = $result->fetch(PDO::FETCH_ASSOC)['user_account_id'];
        
        return $menuGroupID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkUserAccountExist
    # Description: Checks if a user account exists.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkUserAccountExist($p_user_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkUserAccountExist(:p_user_account_id)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkUserAccountEmailExist
    # Description: Checks if a user account email exists.
    #
    # Parameters:
    # - $p_email (string): The email of the user account.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkUserAccountEmailExist($p_email) {
        $stmt = $this->db->getConnection()->prepare('CALL checkUserAccountEmailExist(:p_email)');
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkUserAccountEmailUpdateExist
    # Description: Checks if a user account email exists for updating.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    # - $p_email (string): The email of the user account.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkUserAccountEmailUpdateExist($p_user_account_id, $p_email) {
        $stmt = $this->db->getConnection()->prepare('CALL checkUserAccountEmailUpdateExist(:p_user_account_id, :p_email)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteUserAccount
    # Description: Deletes the user account.
    #
    # Parameters:
    # - $p_user_account_id (int): The user account ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteUserAccount($p_user_account_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteUserAccount(:p_user_account_id)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getUserAccount
    # Description: Retrieves the details of a user account.
    #
    # Parameters:
    # - $p_user_account_id (int): The user ID of the user.
    # - $p_email (string): The email address of the user.
    #
    # Returns:
    # - An array containing the user details.
    #
    # -------------------------------------------------------------
    public function getUserAccount($p_user_account_id, $p_email) {
        $stmt = $this->db->getConnection()->prepare('CALL getUserAccount(:p_user_account_id, :p_email)');
        $stmt->bindValue(':p_user_account_id', $p_user_account_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>