/* Menu Group Table */

CREATE TABLE app_module (
    app_module_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    app_module_name VARCHAR(100) NOT NULL,
    app_module_description VARCHAR(500) NOT NULL,
    app_logo VARCHAR(500),
    app_version VARCHAR(50) NOT NULL DEFAULT '1.0.0',
    order_sequence TINYINT(10) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX app_module_index_app_module_id ON app_module(app_module_id);

INSERT INTO app_module (app_module_name, app_module_description, app_logo, order_sequence, last_log_by) VALUES ('Administration', 'Centralized management hub for comprehensive organizational oversight and control', './components/app-module/image/logo/1/administration.png', 99, '1');
INSERT INTO app_module (app_module_name, app_module_description, app_logo, order_sequence, last_log_by) VALUES ('Technical', 'Comprehensive suite for advanced configuration and customization of system features', './components/app-module/image/logo/2/technical.png', 100, '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */