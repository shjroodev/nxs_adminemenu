CREATE TABLE IF NOT EXISTS `nxs_admin` (
    `identifier` VARCHAR(60) NOT NULL PRIMARY KEY,
    `inJail`     TINYINT(1)  DEFAULT 0,
    `jailCoords` TEXT        DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `nxs_warn` (
    `id`               INT AUTO_INCREMENT PRIMARY KEY,
    `identifier`       VARCHAR(60)  NOT NULL,
    `player_name`      VARCHAR(100) DEFAULT NULL,
    `staff_identifier` VARCHAR(60)  DEFAULT NULL,
    `staff_name`       VARCHAR(100) DEFAULT NULL,
    `reason`           TEXT         DEFAULT NULL,
    `warn_date`        DATETIME     DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_warn_identifier (`identifier`),
    INDEX idx_warn_staff      (`staff_identifier`)
);

CREATE TABLE IF NOT EXISTS `nxs_kick` (
    `id`               INT AUTO_INCREMENT PRIMARY KEY,
    `identifier`       VARCHAR(60)  NOT NULL,
    `player_name`      VARCHAR(100) DEFAULT NULL,
    `staff_identifier` VARCHAR(60)  DEFAULT NULL,
    `staff_name`       VARCHAR(100) DEFAULT NULL,
    `reason`           TEXT         DEFAULT NULL,
    `kick_date`        DATETIME     DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_kick_identifier (`identifier`),
    INDEX idx_kick_staff      (`staff_identifier`)
);

CREATE TABLE IF NOT EXISTS `nxs_jail` (
    `id`               INT AUTO_INCREMENT PRIMARY KEY,
    `identifier`       VARCHAR(60)  NOT NULL,
    `player_name`      VARCHAR(100) DEFAULT NULL,
    `staff_identifier` VARCHAR(60)  DEFAULT NULL,
    `staff_name`       VARCHAR(100) DEFAULT NULL,
    `reason`           TEXT         DEFAULT NULL,
    `jail_date`        DATETIME     DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_jail_identifier (`identifier`),
    INDEX idx_jail_staff      (`staff_identifier`)
);

CREATE TABLE IF NOT EXISTS `nxs_ban` (
    `id`               INT AUTO_INCREMENT PRIMARY KEY,
    `ban_code`         INT          DEFAULT NULL UNIQUE,
    `ban_identifier`   VARCHAR(60)  NOT NULL,
    `all_identifiers`  TEXT         DEFAULT NULL,
    `player_name`      VARCHAR(100) DEFAULT NULL,
    `staff_identifier` VARCHAR(60)  DEFAULT NULL,
    `staff_name`       VARCHAR(100) DEFAULT NULL,
    `reason`           TEXT         DEFAULT NULL,
    `ban_date`         DATETIME     DEFAULT CURRENT_TIMESTAMP,
    `expire_date`      DATETIME     DEFAULT NULL,
    `active`           TINYINT(1)   DEFAULT 1,
    `ban_token`        VARCHAR(255) DEFAULT NULL,
    INDEX idx_ban_identifier (`ban_identifier`),
    INDEX idx_ban_active     (`active`),
    INDEX idx_ban_code       (`ban_code`)
);

CREATE TABLE IF NOT EXISTS `nxs_ban_history` (
    `id`               INT AUTO_INCREMENT PRIMARY KEY,
    `ban_id`           INT          NOT NULL,
    `action`           VARCHAR(50)  NOT NULL,
    `admin_identifier` VARCHAR(60)  DEFAULT NULL,
    `admin_name`       VARCHAR(100) DEFAULT NULL,
    `note`             TEXT         DEFAULT NULL,
    `timestamp`        DATETIME     DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_history_ban_id (`ban_id`)
);
