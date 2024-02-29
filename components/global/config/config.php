<?php
# -------------------------------------------------------------
#
# Name       : date_default_timezone_set
# Purpose    : This sets the default timezone to PH.
#
# -------------------------------------------------------------

date_default_timezone_set('Asia/Manila');

# -------------------------------------------------------------
#
# Name       : Database Connection
# Purpose    : This is the place where your database login constants are saved
#
#              DB_HOST: database host, usually it's '127.0.0.1' or 'localhost', some servers also need port info
#              DB_NAME: name of the database. please note: database and database table are not the same thing
#              DB_USER: user for your database. the user needs to have rights for SELECT, UPDATE, DELETE and INSERT.
#              DB_PASS: the password of the above user
#
# -------------------------------------------------------------

define('DB_HOST', 'localhost');
define('DB_NAME', 'modernizedb');
define('DB_USER', 'modernize');
define('DB_PASS', 'qKHJpbkgC6t93nQr');

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : Encryption Key
# Purpose    : This is the serves as the encryption and decryption key of RC
#
# -------------------------------------------------------------

define('ENCRYPTION_KEY', '4b$Gy#89%q*aX@^p&cT!sPv6(5w)zSd+R');

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : Email Configuration
# Purpose    : Define constants for email server configuration.
#
# -------------------------------------------------------------

// Hostname of the mail server
define('MAIL_HOST', 'smtp.hostinger.com');

// Enable SMTP authentication
define('MAIL_SMTP_AUTH', true);

// Username for SMTP authentication
define('MAIL_USERNAME', 'cgmi-noreply@christianmotors.ph');

// Password for SMTP authentication
define('MAIL_PASSWORD', 'P@ssw0rd');

// SMTP security type (ssl/tls)
define('MAIL_SMTP_SECURE', 'ssl');

// Port number for the mail server
define('MAIL_PORT', 465);

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : Default Upload File Path
# Purpose    : Define default upload file paths for various modules.
#
# -------------------------------------------------------------

// Full and relative paths for default images
define('DEFAULT_IMAGES_FULL_PATH_FILE', '/modernize/assets/images/');
define('DEFAULT_IMAGES_RELATIVE_PATH_FILE', './assets/images/');

// Full and relative paths for default documents
define('DEFAULT_DOCUMENT_FULL_PATH_FILE', '/modernize/document/');
define('DEFAULT_DOCUMENT_RELATIVE_PATH_FILE', './document/');

// Full and relative paths for default product images
define('DEFAULT_PRODUCT_FULL_PATH_FILE', '/modernize/inventory/product/');
define('DEFAULT_PRODUCT_RELATIVE_PATH_FILE', './inventory/product/');

// Full and relative paths for default employee images
define('DEFAULT_EMPLOYEE_FULL_PATH_FILE', '/modernize/employee/');
define('DEFAULT_EMPLOYEE_RELATIVE_PATH_FILE', './employee/');

// Full and relative paths for default customer images
define('DEFAULT_CUSTOMER_FULL_PATH_FILE', '/modernize/customer/');
define('DEFAULT_CUSTOMER_RELATIVE_PATH_FILE', './customer/');

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : EMAIL AND PASSWORD DEFAULTS
# Purpose    : Define default email extension and password.
#
# -------------------------------------------------------------

// Default email extension
define('DEFAULT_EMAIL_EXTENSION', '@christianmotors.ph');

// Default password for various purposes
define('DEFAULT_PASSWORD', 'P@ssw0rd');

# -------------------------------------------------------------

# -------------------------------------------------------------
#
# Name       : SECURITY SETTINGS
# Purpose    : Define maximum allowed failed login and OTP attempts.
#
# -------------------------------------------------------------

// Maximum allowed failed login attempts
define('MAX_FAILED_LOGIN_ATTEMPTS', 5);

// Maximum allowed failed OTP attempts
define('MAX_FAILED_OTP_ATTEMPTS', 5);

# -------------------------------------------------------------
?>
