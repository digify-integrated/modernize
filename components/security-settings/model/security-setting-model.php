<?php
/**
* Class SecuritySettingModel
*
* The SecuritySettingModel class handles security setting related operations and interactions.
*/
class SecuritySettingModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getSecuritySetting
    # Description: Retrieves the details of a security setting.
    #
    # Parameters:
    # - $p_security_setting_id (int): The security setting ID.
    #
    # Returns:
    # - An array containing the user details.
    #
    # -------------------------------------------------------------
    public function getSecuritySetting($p_security_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getSecuritySetting(:p_security_setting_id)');
        $stmt->bindValue(':p_security_setting_id', $p_security_setting_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>