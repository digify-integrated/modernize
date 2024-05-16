<?php
/**
* Class NotificationSettingModel
*
* The NotificationSettingModel class handles notification setting related operations and interactions.
*/
class NotificationSettingModel {
    public $db;

    public function __construct(DatabaseModel $db) {
        $this->db = $db;
    }

    # -------------------------------------------------------------
    #   Update methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: updateNotificationSetting
    # Description: Updates the notification setting.
    #
    # Parameters:
    # - $p_notification_setting_id (int): The notification setting ID.
    # - $p_notification_setting_name (string): The notification setting name.
    # - $p_notification_setting_description (string): The notification setting description.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function updateNotificationSetting($p_notification_setting_id, $p_notification_setting_name, $p_notification_setting_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL updateNotificationSetting(:p_notification_setting_id, :p_notification_setting_name, :p_notification_setting_description, :p_last_log_by)');
        $stmt->bindValue(':p_notification_setting_id', $p_notification_setting_id, PDO::PARAM_INT);
        $stmt->bindValue(':p_notification_setting_name', $p_notification_setting_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_notification_setting_description', $p_notification_setting_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Insert methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: insertNotificationSetting
    # Description: Inserts the notification setting.
    #
    # Parameters:
    # - $p_notification_setting_name (string): The notification setting name.
    # - $p_notification_setting_description (string): The notification setting description.
    # - $p_last_log_by (int): The last logged user.
    #
    # Returns: String
    #
    # -------------------------------------------------------------
    public function insertNotificationSetting($p_notification_setting_name, $p_notification_setting_description, $p_last_log_by) {
        $stmt = $this->db->getConnection()->prepare('CALL insertNotificationSetting(:p_notification_setting_name, :p_notification_setting_description, :p_last_log_by, @p_notification_setting_id)');
        $stmt->bindValue(':p_notification_setting_name', $p_notification_setting_name, PDO::PARAM_STR);
        $stmt->bindValue(':p_notification_setting_description', $p_notification_setting_description, PDO::PARAM_STR);
        $stmt->bindValue(':p_last_log_by', $p_last_log_by, PDO::PARAM_INT);
        $stmt->execute();
        
        $result = $this->db->getConnection()->query('SELECT @p_notification_setting_id AS notification_setting_id');
        $menuItemID = $result->fetch(PDO::FETCH_ASSOC)['notification_setting_id'];
        
        return $menuItemID;
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Check exist methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: checkNotificationSettingExist
    # Description: Checks if a notification setting exists.
    #
    # Parameters:
    # - $p_notification_setting_id (int): The notification setting ID.
    #
    # Returns: The result of the query as an associative array.
    #
    # -------------------------------------------------------------
    public function checkNotificationSettingExist($p_notification_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL checkNotificationSettingExist(:p_notification_setting_id)');
        $stmt->bindValue(':p_notification_setting_id', $p_notification_setting_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Delete methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: deleteNotificationSetting
    # Description: Deletes the notification setting.
    #
    # Parameters:
    # - $p_notification_setting_id (int): The notification setting ID.
    #
    # Returns: None
    #
    # -------------------------------------------------------------
    public function deleteNotificationSetting($p_notification_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL deleteNotificationSetting(:p_notification_setting_id)');
        $stmt->bindValue(':p_notification_setting_id', $p_notification_setting_id, PDO::PARAM_INT);
        $stmt->execute();
    }
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #   Get methods
    # -------------------------------------------------------------

    # -------------------------------------------------------------
    #
    # Function: getNotificationSetting
    # Description: Retrieves the details of a notification setting.
    #
    # Parameters:
    # - $p_notification_setting_id (int): The notification setting ID.
    #
    # Returns:
    # - An array containing the notification setting details.
    #
    # -------------------------------------------------------------
    public function getNotificationSetting($p_notification_setting_id) {
        $stmt = $this->db->getConnection()->prepare('CALL getNotificationSetting(:p_notification_setting_id)');
        $stmt->bindValue(':p_notification_setting_id', $p_notification_setting_id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
    # -------------------------------------------------------------
}
?>