<?php
/**
* Class EmailSettingModel
*
* The EmailSettingModel class handles email setting related operations and interactions.
*/
class EmailSettingModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getEmailSetting
    # Description: Retrieves the details of a email setting.
    #
    # Parameters:
    # - $p_email_setting_id (int): The email setting ID.
    #
    # Returns:
    # - An array containing the email setting details.
    #
    # -------------------------------------------------------------
    public function getEmailSetting($p_email_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getEmailSetting(:p_email_setting_id)');
        $stmt->bindValue(':p_email_setting_id', $p_email_setting_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>