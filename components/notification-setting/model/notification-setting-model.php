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