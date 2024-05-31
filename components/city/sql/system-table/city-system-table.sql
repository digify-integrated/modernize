/* City Table */

CREATE TABLE city (
    city_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    state_id INT UNSIGNED NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    country_id INT UNSIGNED NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    FOREIGN KEY (state_id) REFERENCES state(state_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX city_index_city_id ON city(city_id);
CREATE INDEX city_index_state_id ON city(state_id);
CREATE INDEX city_index_country_id ON city(country_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */