<?php
/**
* Class UserModel
*
* The UserModel class handles user operations and interactions.
*/
class UserModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getUser
    # Description: Retrieves the details of a user.
    #
    # Parameters:
    # - $p_user_id (int): The user ID of the user.
    # - $p_email (string): The email address of the user.
    #
    # Returns:
    # - An array containing the user details.
    #
    # -------------------------------------------------------------
    public function getUser($p_user_id, $p_email) {
        $stmt = $this->db->getConnection()->prepare('CALL getUser(:p_user_id, :p_email)');
        $stmt->bindValue(':p_user_id', $p_user_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>