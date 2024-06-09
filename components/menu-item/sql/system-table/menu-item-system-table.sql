/* Menu Item Table */

CREATE TABLE menu_item (
    menu_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    menu_item_name VARCHAR(100) NOT NULL,
    menu_item_url VARCHAR(50),
    app_module_id INT UNSIGNED NOT NULL,
    app_module_name VARCHAR(100) NOT NULL,
	parent_id INT UNSIGNED,
    parent_name VARCHAR(100),
    order_sequence TINYINT(10) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id),
    FOREIGN KEY (last_log_by) REFERENCES app_module(app_module_id),
);

CREATE INDEX menu_item_index_menu_item_id ON menu_item(menu_item_id);
CREATE INDEX menu_item_index_app_module_id ON menu_item(app_module_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */