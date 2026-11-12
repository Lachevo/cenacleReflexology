# Cenacle Reflexology – Reservation Management System
### Complete System Documentation, Functionality Reference & Configuration Guide

---

## Table of Contents
1. [System Overview](#1-system-overview)
2. [Complete Functional Capabilities](#2-complete-functional-capabilities)
   - [Interactive Schedule Grid & Timeline](#interactive-schedule-grid--timeline)
   - [Drag-and-Drop Quick Intake System](#drag-and-drop-quick-intake-system)
   - [Intelligent Unit Enforcement (Chairs vs Bed)](#intelligent-unit-enforcement-chairs-vs-bed)
   - [Business Hours & Late-Night Cutoff Protection](#business-hours--late-night-cutoff-protection)
   - [Reservation Lifecycle & Collision Prevention](#reservation-lifecycle--collision-prevention)
   - [Custom Attributes & Customer Intake Data](#custom-attributes--customer-intake-data)
   - [User Management & Role-Based Access](#user-management--role-based-access)
   - [Reporting & Resource Utilization Analytics](#reporting--resource-utilization-analytics)
3. [Treatment Catalog, Pricing & Unit Allocation](#3-treatment-catalog-pricing--unit-allocation)
4. [Configuration Reference (What Every Setting Does)](#4-configuration-reference-what-every-setting-does)
   - [Application Settings](#a-application-settings)
   - [Language & Timezone Settings](#b-language--timezone-settings)
   - [Frontend & Display Settings](#c-frontend--display-settings)
   - [Registration & Access Security Settings](#d-registration--access-security-settings)
   - [Reservation & Booking Behavior Settings](#e-reservation--booking-behavior-settings)
   - [Schedule View Settings](#f-schedule-view-settings)
   - [Security & Session Settings](#g-security--session-settings)
   - [Email & Notification (SMTP) Settings](#h-email--notification-smtp-settings)
   - [Database Connection Settings](#i-database-connection-settings)
   - [Plugin Architecture Settings](#j-plugin-architecture-settings)
   - [REST API Settings](#k-rest-api-settings)
5. [Custom Plugins Architecture](#5-custom-plugins-architecture)
   - [PreReservation Business Logic Plugin (`plugins/PreReservation/Cenacle/`)](#prereservation-business-logic-plugin)
   - [Cenacle Styling Plugin (`plugins/Styling/CenacleStyling/`)](#cenacle-styling-plugin)
6. [Daily Staff Operating Guide](#6-daily-staff-operating-guide)
7. [Administrator Guide](#7-administrator-guide)
8. [Installation & Deployment Instructions](#8-installation--deployment-instructions)
9. [Troubleshooting & Maintenance Checklist](#9-troubleshooting--maintenance-checklist)

---

## 1. System Overview

**Cenacle Reflexology Reservation System** is an enterprise scheduling and customer intake platform tailored specifically for Cenacle Reflexology in Addis Ababa, Ethiopia.

- **Primary Purpose**: Managing daily bookings across **6 Reflexology Chairs** and **1 Massage Bed** with zero double-booking, automatic resource validation, fast walk-in intake, and real-time color-coded schedules.
- **Operating Timezone**: `Africa/Addis_Ababa` (UTC+3, EAT).
- **Currency**: Ethiopian Birr (ETB).
- **Operating Hours**:
  - **Monday – Saturday**: 2:30 PM – 2:30 AM (14:30 – 02:30 next day).
  - **Sunday**: 4:00 PM – 2:30 AM (16:00 – 02:30 next day).
  - **Cutoff**: Bookings are blocked after 1:30 AM.

---

## 2. Complete Functional Capabilities

### Interactive Schedule Grid & Timeline
- **Weekly & Daily Grid**: Displays all 7 units (Chairs 1–6 and Massage Bed) across time blocks.
- **20-Minute Time Slot Granularity**: Seamlessly accommodates 20m, 30m, 45m, 60m, and 90m treatments.
- **Instant Tooltips & Badges**: Hovering over any appointment reveals customer name, contact phone number, treatment name, total price, and duration.
- **5-Category Visual Color Legend**: Appointments are color-coded in real-time according to their treatment category.
- **Responsive Layout**: Adapts cleanly to desktop workstations, tablets at the reception desk, and mobile devices.

### Drag-and-Drop Quick Intake System
- **Floating Left Dock & Top Tray**: Staff can access quick treatment badges anytime without scrolling back to the top of the schedule.
- **Interactive Dragging**: Simply click and drag a treatment badge (Foot Reflexology, Full Body Massage, Back Massage, Head & Shoulder, or Hand Reflexology) directly onto an open time slot.
- **Interactive Intake Modal**: When dropped on a slot, an intake dialog immediately opens:
  1. **Duration & Price Selector**: Choose standard duration (e.g. 30m @ 900 ETB, 1h @ 1,300 ETB, 1h30m @ 2,000 ETB) with automatic end-time calculation.
  2. **Customer Name Field**: Required customer identifier.
  3. **Phone Number Field**: Customer contact for return identification.
  4. **Number of Persons**: Track group size.
  5. **Notes & Special Preferences**: Record customer requests (firm pressure, injuries, sore spots, etc.).
  6. **1-Click Confirm**: Fast booking creation directly into the schedule.

### Intelligent Unit Enforcement (Chairs vs Bed)
- **Automatic Resource Rules**:
  - **Full Body Massage** and **Back Massage** are strictly restricted to the **Massage Bed (ID 7)**.
  - **Foot Reflexology**, **Hand Reflexology**, and **Head & Shoulder Massage** are restricted to **Chairs 1–6**.
- **Interactive UI Blocking**: Dropping a Full Body massage onto a Chair immediately shows a warning dialog explaining that the treatment requires the Massage Bed.
- **Server-Side Validation**: Even if an operator manually edits the form or submits via API, the `CenacleValidation` plugin intercepts the request and blocks illegal assignments.

### Business Hours & Late-Night Cutoff Protection
- **Opening Time Protection**:
  - Automatically rejects bookings before 2:30 PM on Monday through Saturday.
  - Automatically rejects bookings before 4:00 PM on Sunday.
- **Closing Cutoff (1:30 AM)**:
  - Shifts end at 2:30 AM.
  - The system rejects any booking starting after 1:30 AM to guarantee staff sufficient time to complete treatments before closing.
- **Turnover & Cleaning Buffer**:
  - Every resource has a built-in 5-minute cleaning/sanitization buffer (`buffer_time = 300` seconds) preventing appointments from overlapping back-to-back without room turnaround time.

### Reservation Lifecycle & Collision Prevention
- **Zero Double-Booking Guarantee**: The database and application layer strictly enforce single-booking rules. No two appointments can ever overlap on the same chair or bed.
- **Full CRUD Capabilities**:
  - **Create**: Via drag-and-drop intake or the full booking creation page.
  - **View**: Click any appointment to view complete client intake and pricing details.
  - **Edit & Reschedule**: Move times, change durations, or update notes.
  - **Cancel / Delete**: Soft or hard deletion with full audit tracking.
- **Treatment Selector**: Dropdown menu featuring all standard treatments with prices, plus a "Custom Treatment" field for ad-hoc requests.

### Custom Attributes & Customer Intake Data
Every booking stores structured custom metadata:
1. **Treatment**: The selected treatment option.
2. **Phone Number**: Customer contact number.
3. **Number of Persons**: Party size.
4. **Notes**: Special preferences, medical notes, or requests.

### User Management & Role-Based Access
- **Application Administrators**: Full access to global configuration, layout hours, pricing, staff accounts, reports, and plugin settings.
- **Staff / Receptionists**: Access to the schedule, creating, editing, and checking in client appointments.
- **Password Security**: Bcrypt password hashing, session expiration timeouts, and CSRF protection.

### Reporting & Resource Utilization Analytics
- **Utilization Reports**: Generate metrics showing total hours booked per Chair and Massage Bed over any date range.
- **Customer Volume Reports**: Track daily, weekly, or monthly customer numbers.
- **Printable Schedule**: Single-click printer-friendly daily manifest for staff shifts.
- **CSV / Excel Export**: Export booking history for accounting and payroll reconciliation.

---

## 3. Treatment Catalog, Pricing & Unit Allocation

| Category | Service Duration | Price (ETB) | Schedule Color | Color Code | Allowed Resource |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Foot Reflexology** | 30 minutes | 900 Birr | 🔵 Blue | `#4A90D9` | Chairs 1–6 |
| **Foot Reflexology** | 1 hour | 1,300 Birr | 🔵 Blue | `#4A90D9` | Chairs 1–6 |
| **Foot Reflexology** | 1 hour 30 min | 2,000 Birr | 🔵 Blue | `#4A90D9` | Chairs 1–6 |
| **Full Body Massage** | 1 hour | 2,000 Birr | 🟣 Purple | `#8B5CF6` | Massage Bed |
| **Back Massage** | 30 minutes | 1,200 Birr | 🟤 Mauve | `#B07DB0` | Massage Bed |
| **Head & Shoulder Massage** | 20 minutes | 500 Birr | 🟢 Sage Green | `#5FAD8E` | Chairs 1–6 |
| **Head & Shoulder Massage** | 30 minutes | 700 Birr | 🟢 Sage Green | `#5FAD8E` | Chairs 1–6 |
| **Hand Reflexology** | 20 minutes | 500 Birr | 🟠 Warm Coral | `#E8865A` | Chairs 1–6 |
| **Hand Reflexology** | 30 minutes | 700 Birr | 🟠 Warm Coral | `#E8865A` | Chairs 1–6 |

---

## 4. Configuration Reference (What Every Setting Does)

All settings are configured in `config/config.php` (created from `config/cenacle.config.php`). Below is an exhaustive reference for each setting:

### A. Application Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `app.title` | `'Cenacle Reflexology'` | The public name of the application displayed in the browser tab, page headers, emails, and exports. |
| `app.debug` | `false` (prod) / `true` (dev) | When `true`, PHP errors and database stack traces are displayed on screen for debugging. Must be `false` in production. |
| `admin.email` | `'admin@cenacle.com'` | The primary administrator email address for receiving system notifications and error reports. |
| `admin.email.name`| `'Cenacle Admin'` | Display name shown on outgoing system emails. |
| `company.name` | `'Cenacle Reflexology'` | Company branding shown on page headers and PDF printouts. |
| `company.url` | `''` | Optional website link associated with the company logo. |

---

### B. Language & Timezone Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `default.timezone` | `'Africa/Addis_Ababa'` | Sets the primary timezone for Addis Ababa (UTC+3, EAT). Ensures all schedules, slots, and bookings match local Ethiopian time. |
| `default.language` | `'en_us'` | Sets default language for interface labels, messages, and email templates. |
| `enabled.languages`| `'en_us'` | Restricts available languages to English so staff are not confused by other options in the menu. |

---

### C. Frontend & Display Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `script.url` | `'http://localhost:8080/Web'` | **Crucial**: The public HTTP/HTTPS URL pointing to the `/Web` directory. Must end with `/Web` without trailing slash. Controls all redirects, CSS/JS links, and AJAX calls. |
| `install.password` | `''` | Password for running the web install wizard (`Web/install/`). Leave blank after initial installation to lock down the installer. |
| `cache.templates` | `true` | Enables Smarty template compilation caching in `/tpl_c/` for maximum performance. |
| `use.local.js.libs`| `true` | When `true`, loads jQuery, Bootstrap, and Flatpickr from local files (`Web/assets/vendor/`) rather than external CDNs, ensuring high speed on local networks. |
| `inactivity.timeout`| `60` | Inactivity session timeout in minutes. Automatically logs out an idle terminal after 60 minutes of no action. |
| `home.url` | `''` | Custom redirect destination when clicking the navbar logo. Blank defaults to staff homepage. |
| `logout.url` | `''` | Custom redirect destination after clicking Sign Out. Blank redirects to the login screen. |
| `default.homepage` | `2` | Determines which page users see right after logging in: `1` = Dashboard, `2` = Schedule Grid (Staff see the schedule immediately). |
| `default.page.size`| `50` | Default number of records per page in administrative tables (users, reservations, logs). |
| `css.extension.file`| `''` | Optional extra CSS file path. (Cenacle styles are handled by the `CenacleStyling` plugin). |
| `css.theme` | `'default'` | Base Bootstrap visual theme. |
| `name.format` | `'{first} {last}'` | How user names are displayed across the system. |

---

### D. Registration & Access Security Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `registration.captcha.enabled` | `false` | Enables/disables CAPTCHA on user registration. Disabled for internal staff use. |
| `registration.require.email.activation` | `false` | If `true`, new accounts cannot log in until clicking an email activation link. Disabled for direct staff onboarding. |
| `registration.auto.subscribe.email` | `false` | Automatically subscribes users to email announcements upon registration. |
| `allow.guests.reservations` | `false` | Allows anonymous guests to book without logging in. Disabled to prevent unauthorized public bookings. |
| `allow.anonymous.schedule` | `false` | When `false`, unauthenticated users cannot see the schedule grid. |
| `show.resources.to.unauthenticated.users` | `false` | Prevents public users from viewing the list of chairs and beds. |

---

### E. Reservation & Booking Behavior Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `reservation.time.block.minutes` | `20` | Slot interval in minutes. Set to 20 to support 20m, 30m, 45m, 60m, and 90m treatments. |
| `reservations.prevent.editing.after.end` | `false` | When `false`, receptionists can retroactively add notes or correct payment details after an appointment finishes. |
| `reservations.prevent.creating.before.start` | `false` | When `false`, allows staff to record walk-in customers who arrived slightly earlier than the booking was keyed in. |
| `reservation.requires.approval` | `false` | When `false`, appointments created by staff are instantly confirmed without requiring administrative sign-off. |
| `reservations.propagate.to.resources` | `true` | **Essential**: Enforces collision prevention. Booking a unit reserves that unit 100%, blocking any concurrent booking. |
| `delete.reservations.after.days` | `0` | If set to `> 0`, automatically purges cancelled reservations after N days. `0` preserves full booking history forever. |
| `checkin.enabled` | `false` | Optional check-in module where clients must check in upon arrival or forfeit the slot. |
| `checkin.timeout` | `15` | Minutes allowed before an unclaimed booking is marked missed. |
| `reservation.max.resources` | `1` | Maximum units a single appointment can claim. Set to `1` because each treatment is tied to exactly one Chair or Bed. |
| `reservation.allow.participants` | `false` | Disables multi-attendee meeting invites since reflexology sessions are one-on-one. |

---

### F. Schedule View Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `schedule.days.visible` | `7` | Number of days shown simultaneously on the weekly schedule view (shows all 7 days of the week). |
| `schedule.show.inaccessible.resources` | `false` | Hides units if a staff member lacks permission to view them. |
| `schedule.use.per.user.colors` | `false` | When `false`, coloring is driven by treatment category (Blue, Purple, Sage, Coral, Mauve) rather than the employee who booked it. |

---

### G. Security & Session Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `password.reset.code.ttl.minutes` | `60` | Time-to-live for password reset tokens sent via email (expires after 1 hour). |
| `csrf.validation` | `true` | Protects every POST form submission against Cross-Site Request Forgery attacks. |
| `secure.cookie` | `false` (local) / `true` (HTTPS) | Set to `true` when deployed on live HTTPS production so cookies are transmitted only via encrypted connections. |
| `inactivity.timeout.url` | `''` | Custom redirect page when session expires due to inactivity. |

---

### H. Email & Notification (SMTP) Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `email.default.from.address` | `'noreply@cenacle.com'` | The Sender email address shown on all outgoing confirmations. |
| `email.default.from.name` | `'Cenacle Reflexology'` | Display name shown on outgoing emails. |
| `email.smtp.host` | `'localhost'` | SMTP mail server hostname (e.g. `smtp.gmail.com` or local mailer). |
| `email.smtp.port` | `25` (or `587` / `465`) | SMTP communication port. |
| `email.smtp.protocol` | `'None'` (or `'tls'` / `'ssl'`) | SSL/TLS encryption protocol for mail server connection. |
| `email.smtp.username` | `''` | Mailbox username / login. |
| `email.smtp.password` | `''` | Mailbox password / App password. |

---

### I. Database Connection Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `database.type` | `'mysql'` | Database engine driver (`mysql` for MySQL 8.0+ or MariaDB 10.6+). |
| `database.user` | `'cenacle_user'` | The MySQL user account. |
| `database.password` | `'cenacle_password'` | The MySQL user password. |
| `database.hostspec` | `'db'` (Docker) or `'localhost'` | Database hostname or container host. |
| `database.name` | `'cenacle_booking'` | The MySQL database name. |
| `database.port` | `''` (defaults to 3306) | Custom database port if not standard 3306. |

---

### J. Plugin Architecture Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `plugins.prereservation` | `'Cenacle'` | **Activates the Cenacle Business Rules Engine**: Bed vs Chair restrictions, 1:30 AM cutoff, Sunday hours enforcement. |
| `plugins.styling` | `'CenacleStyling'` | **Activates the Cenacle Visual Engine**: Loads `Cenacle.css`, deep teal theme, and automatic appointment color mapping. |
| `plugins.authentication` | `''` | Custom authentication provider (e.g. LDAP, SAML, OAuth). Left blank for built-in database auth. |
| `plugins.authorization` | `''` | Custom permission evaluator. |
| `plugins.export` | `''` | Custom iCal/ICS export processor. |
| `plugins.postreservation`| `''` | Post-booking webhook/actions (e.g. sending SMS confirmations via Telebirr/local SMS gateway). |

---

### K. REST API Settings

| Key | Value / Example | What it does |
| :--- | :--- | :--- |
| `api.enabled` | `false` | Enables/disables the `/Web/Services/` REST API. Disabled for internal security unless integrating an external mobile app. |
| `api.registration.allow.self` | `false` | Allows external users to register through the REST API. |

---

## 5. Custom Plugins Architecture

### PreReservation Business Logic Plugin
- **Location**: `plugins/PreReservation/Cenacle/CenacleValidation.php`
- **Core Responsibilities**:
  1. **Chair / Bed Enforcement**:
     - Inspects all resource IDs attached to the proposed reservation.
     - If the service contains `"full body"` or `"back"`, it verifies `resource_id == 7` (Massage Bed). If booked on Chairs 1–6, it halts save with an explanatory error.
     - If the service is Foot, Hand, or Head & Shoulder, it ensures `resource_id != 7`.
  2. **1:30 AM Late Cutoff Rule**:
     - Compares appointment start time against local shift boundaries. If start time falls between 1:30 AM and 2:30 AM, it rejects booking with message: *"Reservations cannot be booked after 1:30 AM (closing at 2:30 AM)."*
  3. **Sunday Operating Hours Rule**:
     - On Sundays, validates that start time is not earlier than 4:00 PM.
  4. **Double Booking Guard**:
     - Decorates the default reservation validation pipeline to guarantee zero concurrent bookings.

### Cenacle Styling Plugin
- **Location**: `plugins/Styling/CenacleStyling/`
- **Core Responsibilities**:
  1. Serves `Cenacle.css` containing brand variables (`--cenacle-primary: #2C6E6E`).
  2. Implements `GetReservationAdditonalCSSClasses()`: Dynamically assigns CSS classes (`cenacle-foot`, `cenacle-fullbody`, `cenacle-back`, `cenacle-headshoulder`, `cenacle-hand`) to appointments on the grid by inspecting reservation titles and custom attributes.

---

## 6. Daily Staff Operating Guide

### Creating a Booking via Drag-and-Drop (Fastest)
1. On the Schedule screen (`Web/schedule.php`), look at the **Floating Left Dock** or the top treatment tray.
2. Click and hold the desired treatment badge (e.g. **Foot Reflexology**).
3. Drag it over the target Chair and open time slot.
4. Release the mouse.
5. In the **Intake Modal**:
   - Confirm duration (30m, 1h, or 1h30m).
   - Enter Customer Name and Phone Number.
   - Click **Confirm Booking**.
6. The appointment appears on the schedule with its blue category color.

### Creating a Booking Manually
1. Click any reservable white cell on the schedule.
2. In the reservation form, select the treatment from the **Treatment Type** dropdown.
3. Customer name, phone number, and duration automatically sync.
4. Click **Save**.

### Editing or Cancelling an Appointment
1. Click on the reservation block in the schedule grid.
2. A popup displays full details: client name, phone number, treatment, price, and notes.
3. Click **Edit** to modify times, or click **Delete** to cancel the session.

---

## 7. Administrator Guide

### Adding New Staff Accounts
1. Log in with your admin credentials.
2. Navigate to **Application Management → Manage Users**.
3. Click **Add User**.
4. Enter staff details (first name, last name, email, initial password).
5. Add the user to the **Staff** group so they have schedule management permissions.

### Changing Operating Hours or Layout
1. Navigate to **Application Management → Schedules**.
2. Select the Cenacle schedule and click **Layout**.
3. Edit time block availability codes:
   - `1` = Available for booking.
   - `2` = Blocked / Closed.

---

## 8. Installation & Hosting Guide

LibreBooking is a LAMP/LEMP application. It requires:
- **PHP**: `8.2` or higher (extensions: `pdo_mysql`, `mysqli`, `mbstring`, `intl`, `xml`, `curl`)
- **Database**: MySQL `8.0+` or MariaDB `10.6+`
- **Writable Directories**: `tpl_c/` and `uploads/` (`chmod 755`)

---

### Option A: Free Hosting

#### 1. Self-Host on Reception PC + Cloudflare Tunnel (⭐ Recommended Free Option)
If there is a computer at the Cenacle front desk that stays on during business hours, you can run the system locally with zero hosting fees and securely access it from anywhere in the world.

1. **Start the local Docker containers**:
   ```bash
   cd /home/lachevo/WK/librebooking
   docker compose up -d
   ```
2. **Download & install Cloudflare Tunnel** (free, no credit card required):
   ```bash
   # Download cloudflared binary
   curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
   sudo dpkg -i cloudflared.deb
   ```
3. **Expose the local server to a public HTTPS URL**:
   ```bash
   cloudflared tunnel --url http://localhost:8080
   ```
4. Cloudflare will output a secure public URL (e.g. `https://your-tunnel-name.trycloudflare.com`).
5. Update `script.url` in `config/config.php`:
   ```php
   'script.url' => 'https://your-tunnel-name.trycloudflare.com/Web',
   ```

#### 2. InfinityFree (Cloud Free Hosting)
- **Website**: [infinityfree.com](https://infinityfree.com)
- **Specs**: Free subdomain (e.g. `cenacle.rf.gd`), 5 GB SSD storage, MySQL DB, cPanel.
- **Setup Steps**:
  1. Register at InfinityFree and create an account. Choose a free subdomain.
  2. Open the **Control Panel → MySQL Databases** and create a new database.
  3. Open **phpMyAdmin**, select your database, and import the SQL files in order:
     - `database_schema/create-schema.sql`
     - Upgrades in `database_schema/upgrades/`
     - `database_schema/cenacle-setup.sql`
  4. Use FileZilla (FTP) to upload all project files to `htdocs/`.
  5. Edit `config/config.php` with the database credentials provided in your InfinityFree control panel.
  6. Ensure `tpl_c/` and `uploads/` permissions are set to `755`.

---

### Option B: Ethiopian Hosting Providers 🇪🇹 (Pay in ETB with telebirr / CBE)

For high-speed domestic performance and local payment methods without requiring international credit cards:

#### 1. HahuCloud (⭐ Best Local cPanel Host)
- **Website**: [hahucloud.com](https://www.hahucloud.com)
- **Payment Methods**: **telebirr**, Commercial Bank of Ethiopia (CBE), Awash Bank, Dashen Bank.
- **Cost**: ~1,500 – 3,500 ETB / year.
- **Why it fits**: Provides modern cPanel with a PHP version selector supporting **PHP 8.2+**.
- **Setup Steps**:
  1. Purchase a shared hosting plan or VPS.
  2. In cPanel, navigate to **MultiPHP Manager** and select **PHP 8.2**.
  3. Under **MySQL Databases**, create `cenacle_booking` and a database user.
  4. Under **phpMyAdmin**, import `create-schema.sql`, the version upgrades, and `cenacle-setup.sql`.
  5. Upload your files to `public_html/` and update `config/config.php` with the database credentials and domain URL.

#### 2. Ethio Telecom Cloud Hosting & VPS
- **Website**: [ethiotelecom.et](https://www.ethiotelecom.et)
- **Payment Methods**: **telebirr**, CBE Birr, bank transfer.
- **Cost**: Shared hosting ~500–1,500 ETB/month; Cloud VPS ~2,500–5,000 ETB/month.
- **Why it fits**: Hosted inside Ethio Telecom's national data centers for the lowest latency in Ethiopia.
- **Recommendation**: If choosing Ethio Telecom, select their **Cloud VPS** so you can run the pre-configured Docker containers (`docker compose up -d`) directly on Ubuntu.

#### 3. EthioHosting
- **Website**: [ethiohosting.com](https://ethiohosting.com)
- **Payment Methods**: CBE, telebirr, Awash.
- **Cost**: ~1,800 – 4,000 ETB / year.
- **Setup**: Standard cPanel workflow (select PHP 8.2, import MySQL database, upload files).

#### 4. Registering an Official Ethiopian `.et` Domain
- Register `.et` or `.com.et` domains via **EthioNIC** ([nic.et](https://www.nic.et)) or through HahuCloud / Ethio Telecom.
- Cost: ~1,500 – 3,500 ETB / year.

---

### Option C: Paid International Hosting (Highest Reliability)

| Provider | Plan | Approx. Price | Best For |
| :--- | :--- | :--- | :--- |
| **Hostinger** | Premium Shared | ~$2.99 / month | Easiest cPanel-style dashboard, free SSL, 1-click backups |
| **DigitalOcean** | Droplet (1 GB RAM, Ubuntu) | $6.00 / month | Running your exact Docker setup in the cloud ($200 free trial) |
| **AWS Lightsail** | LAMP / Linux Instance | $5.00 / month | High uptime, scalable Amazon infrastructure |

#### DigitalOcean / VPS Deployment (Using Existing Docker):
1. Create an Ubuntu 24.04 Droplet.
2. SSH into your server:
   ```bash
   ssh root@your_server_ip
   ```
3. Install Docker:
   ```bash
   apt update && apt install docker.io docker-compose -y
   ```
4. Clone the repository and run:
   ```bash
   git clone https://github.com/LibreBooking/librebooking.git cenacle
   cd cenacle
   ./scripts/init-docker-db.sh
   docker compose up -d
   ```
5. Set up free SSL with Certbot:
   ```bash
   apt install certbot python3-certbot-nginx -y
   certbot --nginx -d yourdomain.com
   ```

---

### Step-by-Step Production Deployment Checklist

Regardless of which host you select, follow this deployment sequence:

1. **Upload Files**: Place all repository files into the web root (`public_html/` or `/var/www/html/`).
2. **Database Import Order**:
   - `database_schema/create-schema.sql` (Base tables)
   - Upgrades in `database_schema/upgrades/` (Schema updates)
   - `database_schema/cenacle-setup.sql` (Cenacle schedules, chairs/bed, treatments, prices, and lookup tables)
3. **Configure `config/config.php`**:
   ```php
   'script.url' => 'https://yourdomain.com/Web',
   'database' => [
       'type' => 'mysql',
       'user' => 'your_db_user',
       'password' => 'your_db_password',
       'hostspec' => 'localhost',
       'name' => 'cenacle_booking',
   ],
   'app.debug' => false,
   ```
4. **Set Directory Permissions**:
   ```bash
   chmod -R 755 tpl_c/ uploads/
   ```
5. **Clear Cache**:
   ```bash
   rm -rf tpl_c/*
   ```
6. **Change Default Admin Password**: Log in with `cenacle.admin` / `cenacle123` and update the password under **My Account → Change Password**.

---

## 9. Troubleshooting & Maintenance Checklist

- **Clearing Cache**: If template edits do not show, clear compiled cache:
  ```bash
  rm -rf tpl_c/*
  ```
- **File Permissions**: Ensure web server can write to `/tpl_c/` and `/uploads/`:
  ```bash
  chmod -R 755 tpl_c/ uploads/
  ```
- **Foreign Key Errors**: If database re-initialization causes foreign key errors, ensure `database_schema/cenacle-setup.sql` has re-seeded the lookup tables (`reservation_types`, `reservation_statuses`, `user_statuses`, `roles`).
