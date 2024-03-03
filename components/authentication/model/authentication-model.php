<?php
/**
* Class AuthenticationModel
*
* The AuthenticationModel class handles authentication operations and interactions.
*/
class AuthenticationModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getLoginCredentials
    # Description: Retrieves the details of a login credentials.
    #
    # Parameters:
    # - $p_email (string): The email address of the user.
    #
    # Returns:
    # - An array containing the user details.
    #
    # -------------------------------------------------------------
    public function getLoginCredentials($p_email) {
        $stmt = $this->db->getConnection()->prepare('CALL getLoginCredentials(:p_email)');
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkLoginCredentialsExist
    # Description: Checks if the login credentials exists.
    #
    # Parameters:
    # - $p_email (string): The email address of the user.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkLoginCredentialsExist($p_email = null) {
        $stmt = $this->db->getConnection()->prepare('CALL checkLoginCredentialsExist(:p_email)');
        $stmt->bindValue(':p_email', $p_email, PDO::PARAM_STR);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Update exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateLoginAttempt
    # Description: Updates the login attempt details for a user.
    #
    # Parameters:
    # - $p_user_id (int): The user ID.
    # - $p_failed_login_attempts (int): The number of failed login attempts.
    # - $p_last_failed_login_attempt (datetime): The date and time of the last failed login attempt.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateLoginAttempt($p_user_id, $p_failed_login_attempts, $p_last_failed_login_attempt) {
        $stmt = $this->db->getConnection()->prepare('CALL updateLoginAttempt(:p_user_id, :p_failed_login_attempts, :p_last_failed_login_attempt)');
        $stmt->bindValue(':p_user_id', $p_user_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_failed_login_attempts', $p_failed_login_attempts, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_failed_login_attempt', $p_last_failed_login_attempt, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateAccountLock
    # Description: Updates the account lock status and lock duration for a user.
    #
    # Parameters:
    # - $p_user_id (int): The user ID.
    # - $p_locked (string): The lock status (yes/no).
    # - $p_lock_duration (int): The lock duration in minutes.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateAccountLock($p_user_id, $p_locked, $p_lock_duration) {
        $stmt = $this->db->getConnection()->prepare('CALL updateAccountLock(:p_user_id, :p_locked, :p_lock_duration)');
        $stmt->bindValue(':p_user_id', $p_user_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_locked', $p_locked, PDO::PARAM_STR);
        $stmt->bindValue(':p_lock_duration', $p_lock_duration, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateOTP
    # Description: Updates the OTP details for a user.
    #
    # Parameters:
    # - $p_user_id (int): The user ID.
    # - $p_otp (string): The new OTP.
    # - $p_otp_expiry_date (datetime): The expiry date and time of the OTP.
    # - $p_remember_me (bool): Flag indicating whether "remember me" is enabled.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateOTP($p_user_id, $p_otp, $p_otp_expiry_date, $p_remember_me) {
        $stmt = $this->db->getConnection()->prepare('CALL updateOTP(:p_user_id, :p_otp, :p_otp_expiry_date, :p_remember_me)');
        $stmt->bindValue(':p_user_id', $p_user_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_otp', $p_otp, PDO::PARAM_STR);
        $stmt->bindValue(':p_otp_expiry_date', $p_otp_expiry_date, PDO::PARAM_STR);
        $stmt->bindValue(':p_remember_me', $p_remember_me, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateLastConnection
    # Description: Updates the last connection date for a user.
    #
    # Parameters:
    # - $p_user_id (int): The user ID.
    # - $p_last_connection_date (datetime): The date and time of the last connection.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateLastConnection($p_user_id, $p_last_connection_date) {
        $stmt = $this->db->getConnection()->prepare('CALL updateLastConnection(:p_user_id, :p_last_connection_date)');
        $stmt->bindValue(':p_user_id', $p_user_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_last_connection_date', $p_last_connection_date, PDO::PARAM_STR);
        $stmt->execute();
    }
    # -------------------------------------------------------------
}
?>