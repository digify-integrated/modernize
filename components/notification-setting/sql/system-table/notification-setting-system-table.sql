CREATE TABLE notification_setting(
	notification_setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	notification_setting_name VARCHAR(100) NOT NULL,
	notification_setting_description VARCHAR(200) NOT NULL,
	system_notification INT(1) NOT NULL DEFAULT 1,
	email_notification INT(1) NOT NULL DEFAULT 0,
	sms_notification INT(1) NOT NULL DEFAULT 0,
	system_notification_title VARCHAR(200),
	system_notification_message VARCHAR(200),
	email_notification_subject VARCHAR(200),
	email_notification_body LONGTEXT,
	sms_notification_message VARCHAR(500),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES users(user_id)
);

CREATE INDEX notification_setting_index_notification_setting_id ON notification_setting(notification_setting_id);

INSERT INTO `notification_setting` (`notification_setting_id`, `notification_setting_name`, `notification_setting_description`, `system_notification`, `email_notification`, `sms_notification`, `system_notification_title`, `system_notification_message`, `email_notification_subject`, `email_notification_body`, `sms_notification_message`, `last_log_by`) VALUES
(1, 'Login OTP', 'Notification setting for Login OTP received by the users.', 0, 1, 0, NULL, NULL, 'Login OTP - Secure Access to Your Account', '<p>To ensure the security of your account, we have generated a unique One-Time Password (OTP) for you to use during the login process. Please use the following OTP to access your account:</p>\r\n<p>OTP: <strong>{OTP_CODE}</strong></p>\r\n<p>Please note that this OTP is valid for &lt;strong&gt;5 minutes&lt;/strong&gt;. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.</p>\r\n<p>If you did not initiate this login or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.</p>\r\n<p>&nbsp;</p>\r\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p>', NULL, 1),
(2, 'Forgot Password', 'Notification setting when the user initiates forgot password.', 0, 1, 0, NULL, NULL, 'Password Reset Request - Action Required', '<p>We have received a request to reset your password. To ensure the security of your account, please follow the instructions below:</p>\r\n<p>1. Click on the link below to reset your password:</p>\r\n<p><a href=\"{RESET_LINK}\"><strong>Reset Password</strong></a></p>\r\n<p>2. If the button does not work, you can copy and paste the following link into your browser\'s address bar:</p>\r\n<p><strong>{RESET_LINK}</strong></p>\r\n<p>Please note that this link is time-sensitive and will expire after <strong>{RESET_DURATION} minutes</strong>. If you do not reset your password within this timeframe, you may need to request another password reset.</p>\r\n<p>If you did not initiate this password reset request or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.</p>\r\n<p>&nbsp;</p>\r\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p>', NULL, 1);