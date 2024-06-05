/* Menu Group Table */

CREATE TABLE app_module (
    app_module_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    app_module_name VARCHAR(100) NOT NULL,
    app_module_description VARCHAR(500) NOT NULL,
    app_logo VARCHAR(500),
    order_sequence TINYINT(10) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX app_module_index_app_module_id ON app_module(app_module_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */