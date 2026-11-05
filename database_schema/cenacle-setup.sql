-- =============================================================================
-- Cenacle Reflexology – Database Initial Setup Script
-- =============================================================================
-- Run this AFTER the base LibreBooking schema has been installed.
-- It wipes the sample data and inserts Cenacle-specific configuration:
--   • Layout (time blocks) for Mon–Sat 14:30–02:30 and Sun 16:00–02:30
--   • Schedule
--   • 6 Chairs + 1 Bed
--   • Admin and Staff groups / roles
--   • Service custom attribute with colour rules
--   • Pricing custom attribute
--   • Admin user (change password immediately after first login)
-- =============================================================================

SET foreign_key_checks = 0;

-- ---------------------------------------------------------------------------
-- 0. Wipe sample / default data
-- ---------------------------------------------------------------------------
DELETE FROM `reservation_accessories`;
DELETE FROM `reservation_resources`;
DELETE FROM `reservation_users`;
DELETE FROM `reservation_instances`;
DELETE FROM `reservation_series`;
DELETE FROM `blackout_instances`;
DELETE FROM `blackout_series`;
DELETE FROM `custom_attribute_values`;
DELETE FROM `reservation_color_rules`;
DELETE FROM `custom_attributes`;
DELETE FROM `user_resource_permissions`;
DELETE FROM `group_resource_permissions`;
DELETE FROM `resources`;
DELETE FROM `user_groups`;
DELETE FROM `group_roles`;
DELETE FROM `groups`;
DELETE FROM `users`;
DELETE FROM `time_blocks`;
DELETE FROM `schedules`;
DELETE FROM `layouts`;

ALTER TABLE `resources`  AUTO_INCREMENT = 1;
ALTER TABLE `schedules`  AUTO_INCREMENT = 1;
ALTER TABLE `layouts`    AUTO_INCREMENT = 1;
ALTER TABLE `groups`     AUTO_INCREMENT = 1;
ALTER TABLE `users`      AUTO_INCREMENT = 1;
ALTER TABLE `custom_attributes` AUTO_INCREMENT = 1;

-- ---------------------------------------------------------------------------
-- 1. Groups & Roles
-- ---------------------------------------------------------------------------
-- role_id: 1 = Group Admin, 2 = Application Admin, 4 = Schedule Admin
INSERT INTO `groups` (`group_id`, `name`) VALUES
    (1, 'Administrators'),
    (2, 'Staff');

-- Administrators group gets Application Admin role
INSERT INTO `group_roles` (`group_id`, `role_id`) VALUES
    (1, 2);

-- ---------------------------------------------------------------------------
-- 2. Time Layout – shared base layout (all timezones stored in UTC in
--    LibreBooking; the per-schedule timezone is applied at display time)
--
--    Business hours (Addis Ababa EAT = UTC+3):
--      Mon–Sat open 14:30 local → 11:30 UTC, close 02:30 next day → 23:30 UTC
--      Sun     open 16:00 local → 13:00 UTC, close 02:30 next day → 23:30 UTC
--
--    We create ONE layout that covers the WIDEST window (14:30–02:30 local).
--    Sunday restriction is handled by the layout's day-of-week availability,
--    configured via the admin UI after setup.
-- ---------------------------------------------------------------------------

-- Layout 1: Cenacle Main (Ethiopia / Addis Ababa)
INSERT INTO `layouts` (`layout_id`, `timezone`, `is_using_single_layout`)
VALUES (1, 'Africa/Addis_Ababa', 0);

-- Time blocks: 20-minute slots from 14:30 to 02:30+1 day
-- availability_code: 2 = unavailable, 1 = available
INSERT INTO `time_blocks` (`availability_code`, `layout_id`, `start_time`, `end_time`) VALUES
-- Midnight to 02:30 → available (this is the late-night portion of the previous day's shift)
(1, 1, '00:00', '00:20'),
(1, 1, '00:20', '00:40'),
(1, 1, '00:40', '01:00'),
(1, 1, '01:00', '01:20'),
(1, 1, '01:20', '01:40'),
(1, 1, '01:40', '02:00'),
(1, 1, '02:00', '02:20'),
(1, 1, '02:20', '02:30'),
-- 02:30 to 14:30 → closed
(2, 1, '02:30', '14:30'),
-- 14:30 to 23:59 → available
(1, 1, '14:30', '14:40'),
(1, 1, '14:40', '15:00'),
(1, 1, '15:00', '15:20'),
(1, 1, '15:20', '15:40'),
(1, 1, '15:40', '16:00'),
(1, 1, '16:00', '16:20'),
(1, 1, '16:20', '16:40'),
(1, 1, '16:40', '17:00'),
(1, 1, '17:00', '17:20'),
(1, 1, '17:20', '17:40'),
(1, 1, '17:40', '18:00'),
(1, 1, '18:00', '18:20'),
(1, 1, '18:20', '18:40'),
(1, 1, '18:40', '19:00'),
(1, 1, '19:00', '19:20'),
(1, 1, '19:20', '19:40'),
(1, 1, '19:40', '20:00'),
(1, 1, '20:00', '20:20'),
(1, 1, '20:20', '20:40'),
(1, 1, '20:40', '21:00'),
(1, 1, '21:00', '21:20'),
(1, 1, '21:20', '21:40'),
(1, 1, '21:40', '22:00'),
(1, 1, '22:00', '22:20'),
(1, 1, '22:20', '22:40'),
(1, 1, '22:40', '23:00'),
(1, 1, '23:00', '23:20'),
(1, 1, '23:20', '23:40'),
(1, 1, '23:40', '00:00');

-- Layout 2: Sunday layout – opens later (16:00 instead of 14:30)
INSERT INTO `layouts` (`layout_id`, `timezone`, `is_using_single_layout`)
VALUES (2, 'Africa/Addis_Ababa', 0);

INSERT INTO `time_blocks` (`availability_code`, `layout_id`, `start_time`, `end_time`) VALUES
(1, 2, '00:00', '00:20'),
(1, 2, '00:20', '00:40'),
(1, 2, '00:40', '01:00'),
(1, 2, '01:00', '01:20'),
(1, 2, '01:20', '01:40'),
(1, 2, '01:40', '02:00'),
(1, 2, '02:00', '02:20'),
(1, 2, '02:20', '02:30'),
-- 02:30 to 16:00 → closed on Sunday
(2, 2, '02:30', '16:00'),
-- 16:00 to 23:59 → available
(1, 2, '16:00', '16:20'),
(1, 2, '16:20', '16:40'),
(1, 2, '16:40', '17:00'),
(1, 2, '17:00', '17:20'),
(1, 2, '17:20', '17:40'),
(1, 2, '17:40', '18:00'),
(1, 2, '18:00', '18:20'),
(1, 2, '18:20', '18:40'),
(1, 2, '18:40', '19:00'),
(1, 2, '19:00', '19:20'),
(1, 2, '19:20', '19:40'),
(1, 2, '19:40', '20:00'),
(1, 2, '20:00', '20:20'),
(1, 2, '20:20', '20:40'),
(1, 2, '20:40', '21:00'),
(1, 2, '21:00', '21:20'),
(1, 2, '21:20', '21:40'),
(1, 2, '21:40', '22:00'),
(1, 2, '22:00', '22:20'),
(1, 2, '22:20', '22:40'),
(1, 2, '22:40', '23:00'),
(1, 2, '23:00', '23:20'),
(1, 2, '23:20', '23:40'),
(1, 2, '23:40', '00:00');

-- ---------------------------------------------------------------------------
-- 3. Schedule
--    weekdaystart: 1 = Monday
--    daysvisible:  7 = show a full week
-- ---------------------------------------------------------------------------
INSERT INTO `schedules` (`schedule_id`, `name`, `isdefault`, `weekdaystart`, `daysvisible`, `layout_id`)
VALUES (1, 'Cenacle Main', 1, 1, 7, 1);

-- ---------------------------------------------------------------------------
-- 4. Resources  (6 Chairs + 1 Bed = 7)
--    min_duration in seconds: 20 min = 1200s, 30 min = 1800s
--    min_increment: 20 minutes = 1200s (smallest slot)
--    autoassign: 1 = auto-assign available resource
--    allow_multiday_reservations: 0 = single-day only
-- ---------------------------------------------------------------------------

-- Chair 1
INSERT INTO `resources` (`resource_id`, `name`, `description`, `isactive`, `min_duration`, `min_increment`, `max_duration`,
                          `buffer_time`, `autoassign`, `requires_approval`, `allow_multiday_reservations`, `schedule_id`)
VALUES (1, 'Chair 1', 'Available for Foot Reflexology, Head & Shoulder, Hand Reflexology', 1,
        1200, 1200, 5400, 300, 1, 0, 0, 1);

-- Chair 2
INSERT INTO `resources` (`resource_id`, `name`, `description`, `isactive`, `min_duration`, `min_increment`, `max_duration`,
                          `buffer_time`, `autoassign`, `requires_approval`, `allow_multiday_reservations`, `schedule_id`)
VALUES (2, 'Chair 2', 'Available for Foot Reflexology, Head & Shoulder, Hand Reflexology', 1,
        1200, 1200, 5400, 300, 1, 0, 0, 1);

-- Chair 3
INSERT INTO `resources` (`resource_id`, `name`, `description`, `isactive`, `min_duration`, `min_increment`, `max_duration`,
                          `buffer_time`, `autoassign`, `requires_approval`, `allow_multiday_reservations`, `schedule_id`)
VALUES (3, 'Chair 3', 'Available for Foot Reflexology, Head & Shoulder, Hand Reflexology', 1,
        1200, 1200, 5400, 300, 1, 0, 0, 1);

-- Chair 4
INSERT INTO `resources` (`resource_id`, `name`, `description`, `isactive`, `min_duration`, `min_increment`, `max_duration`,
                          `buffer_time`, `autoassign`, `requires_approval`, `allow_multiday_reservations`, `schedule_id`)
VALUES (4, 'Chair 4', 'Available for Foot Reflexology, Head & Shoulder, Hand Reflexology', 1,
        1200, 1200, 5400, 300, 1, 0, 0, 1);

-- Chair 5
INSERT INTO `resources` (`resource_id`, `name`, `description`, `isactive`, `min_duration`, `min_increment`, `max_duration`,
                          `buffer_time`, `autoassign`, `requires_approval`, `allow_multiday_reservations`, `schedule_id`)
VALUES (5, 'Chair 5', 'Available for Foot Reflexology, Head & Shoulder, Hand Reflexology', 1,
        1200, 1200, 5400, 300, 1, 0, 0, 1);

-- Chair 6
INSERT INTO `resources` (`resource_id`, `name`, `description`, `isactive`, `min_duration`, `min_increment`, `max_duration`,
                          `buffer_time`, `autoassign`, `requires_approval`, `allow_multiday_reservations`, `schedule_id`)
VALUES (6, 'Chair 6', 'Available for Foot Reflexology, Head & Shoulder, Hand Reflexology', 1,
        1200, 1200, 5400, 300, 1, 0, 0, 1);

-- Massage Bed  (Full Body & Back Massage only)
INSERT INTO `resources` (`resource_id`, `name`, `description`, `isactive`, `min_duration`, `min_increment`, `max_duration`,
                          `buffer_time`, `autoassign`, `requires_approval`, `allow_multiday_reservations`, `schedule_id`)
VALUES (7, 'Massage Bed', 'Available for Full Body Massage and Back Massage', 1,
        1800, 1200, 5400, 300, 1, 0, 0, 1);

-- ---------------------------------------------------------------------------
-- 5. Custom Attributes
--
--    attribute_category:
--      1 = Reservation, 2 = User, 4 = Resource
--
--    display_type:
--      1 = Text,  2 = Select (dropdown), 3 = Checkbox, 4 = Textarea, 5 = Date
-- ---------------------------------------------------------------------------

-- 5a. Treatment / Service (dropdown) – reservation attribute
--     Staff selects the service when booking.
INSERT INTO `custom_attributes`
    (`custom_attribute_id`, `display_label`, `display_type`, `attribute_category`,
     `validation_regex`, `is_required`, `possible_values`, `admin_only`, `is_private`)
VALUES
    (1, 'Treatment', 2, 1, NULL, 1,
     'Foot Reflexology – 30 min (900 Birr)|Foot Reflexology – 1 hr (1,300 Birr)|Foot Reflexology – 1.5 hr (2,000 Birr)|Full Body Massage – 1 hr (2,000 Birr)|Back Massage – 30 min (1,200 Birr)|Head & Shoulder Massage – 20 min (500 Birr)|Head & Shoulder Massage – 30 min (700 Birr)|Hand Reflexology – 20 min (500 Birr)|Hand Reflexology – 30 min (700 Birr)',
     0, 0);

-- 5b. Number of persons (text, required)
INSERT INTO `custom_attributes`
    (`custom_attribute_id`, `display_label`, `display_type`, `attribute_category`,
     `validation_regex`, `is_required`, `possible_values`, `admin_only`, `is_private`)
VALUES
    (2, 'Number of Persons', 1, 1, '^[1-9][0-9]*$', 1, NULL, 0, 0);

-- 5c. Customer phone number (text, optional – for returning customer lookup)
INSERT INTO `custom_attributes`
    (`custom_attribute_id`, `display_label`, `display_type`, `attribute_category`,
     `validation_regex`, `is_required`, `possible_values`, `admin_only`, `is_private`)
VALUES
    (3, 'Phone Number', 1, 1, NULL, 0, NULL, 0, 0);

-- 5d. Notes / special requests
INSERT INTO `custom_attributes`
    (`custom_attribute_id`, `display_label`, `display_type`, `attribute_category`,
     `validation_regex`, `is_required`, `possible_values`, `admin_only`, `is_private`)
VALUES
    (4, 'Notes', 4, 1, NULL, 0, NULL, 0, 0);

-- ---------------------------------------------------------------------------
-- 6. Reservation Colour Rules (tied to the "Treatment" dropdown attribute)
--
--    comparison_type: 1 = equals
--    attribute_type:  maps to CustomAttributeTypes constants (1 = text/select)
-- ---------------------------------------------------------------------------

-- Foot Reflexology → Blue #4A90D9
INSERT INTO `reservation_color_rules` (`custom_attribute_id`, `attribute_type`, `required_value`, `comparison_type`, `color`)
VALUES (1, 1, 'Foot Reflexology – 30 min (900 Birr)',       1, '#4A90D9');

INSERT INTO `reservation_color_rules` (`custom_attribute_id`, `attribute_type`, `required_value`, `comparison_type`, `color`)
VALUES (1, 1, 'Foot Reflexology – 1 hr (1,300 Birr)',       1, '#4A90D9');

INSERT INTO `reservation_color_rules` (`custom_attribute_id`, `attribute_type`, `required_value`, `comparison_type`, `color`)
VALUES (1, 1, 'Foot Reflexology – 1.5 hr (2,000 Birr)',     1, '#4A90D9');

-- Full Body Massage → Purple #8B5CF6
INSERT INTO `reservation_color_rules` (`custom_attribute_id`, `attribute_type`, `required_value`, `comparison_type`, `color`)
VALUES (1, 1, 'Full Body Massage – 1 hr (2,000 Birr)',      1, '#8B5CF6');

-- Back Massage → Mauve #B07DB0
INSERT INTO `reservation_color_rules` (`custom_attribute_id`, `attribute_type`, `required_value`, `comparison_type`, `color`)
VALUES (1, 1, 'Back Massage – 30 min (1,200 Birr)',         1, '#B07DB0');

-- Head & Shoulder Massage → Sage #5FAD8E
INSERT INTO `reservation_color_rules` (`custom_attribute_id`, `attribute_type`, `required_value`, `comparison_type`, `color`)
VALUES (1, 1, 'Head & Shoulder Massage – 20 min (500 Birr)',1, '#5FAD8E');

INSERT INTO `reservation_color_rules` (`custom_attribute_id`, `attribute_type`, `required_value`, `comparison_type`, `color`)
VALUES (1, 1, 'Head & Shoulder Massage – 30 min (700 Birr)',1, '#5FAD8E');

-- Hand Reflexology → Coral #E8865A
INSERT INTO `reservation_color_rules` (`custom_attribute_id`, `attribute_type`, `required_value`, `comparison_type`, `color`)
VALUES (1, 1, 'Hand Reflexology – 20 min (500 Birr)',        1, '#E8865A');

INSERT INTO `reservation_color_rules` (`custom_attribute_id`, `attribute_type`, `required_value`, `comparison_type`, `color`)
VALUES (1, 1, 'Hand Reflexology – 30 min (700 Birr)',        1, '#E8865A');

-- ---------------------------------------------------------------------------
-- 7. Admin user
--    Password: cenacle123  (bcrypt hash below – CHANGE IMMEDIATELY)
--    Generated via: password_hash('cenacle123', PASSWORD_BCRYPT)
--    If your LibreBooking uses SHA1+salt, replace with the appropriate hash.
-- ---------------------------------------------------------------------------
INSERT INTO `users`
    (`fname`, `lname`, `email`, `username`, `password`, `salt`,
     `timezone`, `lastlogin`, `status_id`, `date_created`, `language`)
VALUES
    ('Cenacle', 'Admin', 'admin@cenacle.com', 'cenacle.admin',
     -- This is a placeholder SHA1 hash for password "cenacle123" with salt "cenacle1"
     -- Run Web/install/ to create a proper user, or update this hash.
     SHA1(CONCAT('cenacle123', 'cenacle1')), 'cenacle1',
     'Africa/Addis_Ababa', NOW(), 1, NOW(), 'en_us');

-- Make admin a member of the Administrators group
INSERT INTO `user_groups` (`user_id`, `group_id`)
SELECT u.user_id, 1 FROM `users` u WHERE u.username = 'cenacle.admin';

-- Grant admin full access to all resources
INSERT INTO `user_resource_permissions` (`user_id`, `resource_id`, `permission_id`)
SELECT u.user_id, r.resource_id, 1
FROM `users` u, `resources` r
WHERE u.username = 'cenacle.admin';

SET foreign_key_checks = 1;

-- =============================================================================
-- POST-SETUP CHECKLIST
-- =============================================================================
-- 1. Update admin password via Admin → Manage Users after first login
-- 2. Admin → Manage Schedules → set weekdaystart=Monday, daysvisible=7
-- 3. Admin → Manage Schedules → assign layout 1 (Mon–Sat) as default;
--    configure Sunday to use layout 2 via day-of-week layout overrides
-- 4. Admin → Manage Resources → review min/max duration for each resource
-- 5. Admin → Manage Groups → create staff logins and add to "Staff" group
-- 6. Upload Cenacle logo via Admin → Application Settings → Logo
-- 7. Config: set script.url to your actual domain in config/config.php
-- =============================================================================

