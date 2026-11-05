<?php

/**
 * Cenacle Reflexology – LibreBooking Configuration
 *
 * Copy this file to config/config.php and fill in the database credentials.
 * All Cenacle-specific settings are pre-configured below.
 */

return [
    'settings' => [

        ###########################
        # Application configuration
        ###########################

        # The public name of the application
        'app.title' => 'Cenacle Reflexology',

        # Enable or disable debug mode for the application (true/false)
        'app.debug' => false,

        # Administrator email address
        'admin.email' => 'admin@cenacle.com',

        # Display name used for outgoing admin emails
        'admin.email.name' => 'Cenacle Admin',

        # Company name to show in the page header
        'company.name' => 'Cenacle Reflexology',

        # URL to the company's website
        'company.url' => '',

        #######################
        # Language and Timezone
        #######################

        # Ethiopia timezone
        'default.timezone' => 'Africa/Addis_Ababa',

        'default.language' => 'en_us',

        # Show only English
        'enabled.languages' => 'en_us',

        ##########
        # Frontend
        ##########

        # Public URL to the Web directory of this instance (set to your actual URL)
        'script.url' => '',

        # Disable public install wizard
        'install.password' => '',

        # Enable template caching
        'cache.templates' => true,

        # Use locally bundled JS/CSS assets (no CDN needed)
        'use.local.js.libs' => true,

        # Session inactivity timeout in minutes
        'inactivity.timeout' => 60,

        'home.url' => '',
        'logout.url' => '',

        # Default homepage: 2 = Schedule (staff sees the booking grid first)
        'default.homepage' => 2,

        'default.page.size' => 50,

        # Path to Cenacle custom CSS (served as a static file, in addition to the plugin)
        'css.extension.file' => '',

        # Base theme – we override colours via the Cenacle Styling plugin
        'css.theme' => 'default',

        'name.format' => '{first} {last}',

        #######################
        # Analytics Integration
        #######################

        'google.analytics.tracking.id' => '',
        'slack.token' => '',

        ########
        # Pages
        ########

        'registration.captcha.enabled' => false,
        'registration.require.email.activation' => false,
        'registration.auto.subscribe.email' => false,

        # Allow guests to create reservations without an account
        'allow.guests.reservations' => false,

        'allow.anonymous.schedule' => false,
        'show.resources.to.unauthenticated.users' => false,

        ################
        # Reservations
        ################

        # Allow reservations to start any time (not just on 30-minute blocks)
        'reservation.time.block.minutes' => 20,

        # Allow updating/cancelling of past reservations
        'reservations.prevent.editing.after.end' => false,
        'reservations.prevent.creating.before.start' => false,

        # Require approval for new reservations (false = auto-confirm)
        'reservation.requires.approval' => false,

        # 1 = no overlap allowed  → enforces no double booking
        'reservations.propagate.to.resources' => true,

        # Keep cancelled reservations in DB
        'delete.reservations.after.days' => 0,

        'checkin.enabled' => false,
        'checkin.timeout' => 15,

        # Maximum number of participants per reservation
        'reservation.max.resources' => 1,

        # Allow multiple people in a session (group booking)
        'reservation.allow.participants' => false,

        ###########
        # Schedule
        ###########

        # Show 7 days on the weekly view
        'schedule.days.visible' => 7,
        'schedule.show.inaccessible.resources' => false,

        # Colour reservations per user so each staff member sees their bookings highlighted
        'schedule.use.per.user.colors' => false,

        ###########
        # Security
        ###########

        'password.reset.code.ttl.minutes' => 60,
        'csrf.validation' => true,
        'secure.cookie' => false,

        'inactivity.timeout.url' => '',

        ################
        # Email (SMTP)
        ################

        'email' => [
            'default.from.address' => 'noreply@cenacle.com',
            'default.from.name' => 'Cenacle Reflexology',
            'smtp' => [
                'host' => 'localhost',
                'port' => 25,
                'protocol' => 'None',
                'username' => '',
                'password' => '',
            ],
        ],

        ########################
        # Database Configuration
        ########################

        'database' => [
            'type' => 'mysql',
            'user' => 'cenacle_db_user',   # ← set your DB user
            'password' => '',               # ← set your DB password
            'hostspec' => 'localhost',
            'name' => 'cenacle_booking',    # ← set your DB name
            'port' => '',
        ],

        ######################
        # Plugin Configuration
        ######################

        'plugins' => [
            'authentication' => '',
            'authorization' => '',
            'export' => '',
            'permission' => '',
            'postregistration' => '',

            # Enable Cenacle pre-reservation business rules (bed/chair enforcement & 1:30 AM cutoff)
            'prereservation' => 'Cenacle',

            'postreservation' => '',

            # Enable Cenacle custom styling plugin
            'styling' => 'Cenacle',
        ],

        ###################
        # API Configuration
        ###################

        'api' => [
            'enabled' => false,
            'registration.allow.self' => false,
        ],

        ############
        # iCal feed
        ############

        'ical.subscription.key' => '',
    ],
];

