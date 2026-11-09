# Cenacle Reflexology – Internal Reservation Management System

This repository has been customized for **Cenacle Reflexology** according to your operational specifications.

---

## 1. Operating Rules & Settings

| Item | Specification |
|------|---------------|
| **Operating Hours (Mon–Sat)** | 2:30 PM – 2:30 AM (14:30 – 02:30 next day) |
| **Operating Hours (Sun)** | 4:00 PM – 2:30 AM (16:00 – 02:30 next day) |
| **Last Reservation Cutoff** | 1:30 AM (closing at 2:30 AM) |
| **Time Slot Granularity** | 20 minutes (accommodating 20m, 30m, 45m, 1h, 1h30m) |
| **Cleaning / Preparation Buffer** | 5 minutes (`buffer_time = 300s`) between bookings |
| **Double Booking** | Automatically blocked |
| **Timezone** | `Africa/Addis_Ababa` (UTC+3) |
| **Default View** | Schedule Grid (Weekly & Daily Timeline) |

---

## 2. Resource Allocation (7 Total Units)

| Resource | Quantity | Allowed Treatments | Notes |
|----------|----------|--------------------|-------|
| **Chairs 1–6** | 6 | Foot Reflexology, Head & Shoulder Massage, Hand Reflexology | Reserved strictly for reflexology & upper body |
| **Massage Bed** | 1 | Full Body Massage, Back Massage | The only unit equipped for full body & back massage |

> **Enforced by Plugin**: The included `Cenacle` PreReservation plugin automatically rejects any reservation where a Back or Full Body massage is assigned to a Chair, or where a Foot/Hand/Head treatment is assigned to the Massage Bed.

---

## 3. Services, Durations, Pricing & Color Coding

| Category | Service Duration | Price (ETB) | Schedule Color | Allowed Unit |
|----------|------------------|-------------|----------------|--------------|
| **Foot Reflexology** | 30 minutes | 900 Birr | 🔵 Blue (`#4A90D9`) | Chairs 1–6 |
| **Foot Reflexology** | 1 hour | 1,300 Birr | 🔵 Blue (`#4A90D9`) | Chairs 1–6 |
| **Foot Reflexology** | 1 hour 30 min | 2,000 Birr | 🔵 Blue (`#4A90D9`) | Chairs 1–6 |
| **Full Body Massage** | 1 hour | 2,000 Birr | 🟣 Purple (`#8B5CF6`) | Massage Bed |
| **Back Massage** | 30 minutes | 1,200 Birr | 🟤 Mauve (`#B07DB0`) | Massage Bed |
| **Head & Shoulder Massage** | 20 minutes | 500 Birr | 🟢 Sage Green (`#5FAD8E`) | Chairs 1–6 |
| **Head & Shoulder Massage** | 30 minutes | 700 Birr | 🟢 Sage Green (`#5FAD8E`) | Chairs 1–6 |
| **Hand Reflexology** | 20 minutes | 500 Birr | 🟠 Warm Coral (`#E8865A`) | Chairs 1–6 |
| **Hand Reflexology** | 30 minutes | 700 Birr | 🟠 Warm Coral (`#E8865A`) | Chairs 1–6 |

---

## 4. Architecture & Customized Components

### A. Styling Plugin (`plugins/Styling/CenacleStyling/`)
- Injects `Cenacle.css` with a minimal, modern aesthetic: deep teal primary branding (`#2C6E6E`), high-contrast reservation blocks, clean cards, and responsive table styling.
- Dynamically assigns service colors to every reservation block on the schedule grid based on the treatment selected or title keywords (`foot` → blue, `full body` → purple, etc.).
- Enabled via `'plugins' => ['styling' => 'CenacleStyling']` in `config/config.php`.

### B. Business Rules Plugin (`plugins/PreReservation/Cenacle/`)
- Enforces bed-vs-chair rules:
  - Full Body / Back Massages can **only** be saved on `Massage Bed`.
  - Foot / Hand / Head & Shoulder treatments **cannot** block the `Massage Bed`.
- Enforces the 1:30 AM cutoff: prevents booking reservations that start between 1:30 AM and 2:30 AM.
- Enforces opening hours (prevents booking before 2:30 PM Mon–Sat, or before 4:00 PM on Sunday).
- Decorates the core validation pipeline to maintain zero-tolerance double-booking protection.

### C. Configuration (`config/cenacle.config.php`)
- Pre-configured with application name: **Cenacle Reflexology**.
- Timezone: `Africa/Addis_Ababa`.
- 20-minute slot intervals, 7-day default visibility.
- Auto-assign enabled, guest booking disabled (staff internal use).
- Enables both `Cenacle` Styling and `Cenacle` PreReservation plugins.

### D. Database Seed Script (`database_schema/cenacle-setup.sql`)
- Configures operating schedules and time layouts (14:30–02:30 Mon–Sat; 16:00–02:30 Sun).
- Creates the 6 Chairs and 1 Massage Bed with 5-minute sanitization/prep buffers (`buffer_time = 300`).
- Configures custom attributes:
  1. `Treatment`: Dropdown populated with the 9 specific services and prices.
  2. `Number of Persons`: Numeric field for group/party size.
  3. `Phone Number`: For quick search and returning customer lookup.
  4. `Notes`: For customer preferences or special requirements.
- Configures database color rules mapping each treatment to its category color.
- Sets up Administrator (`admin@cenacle.com`) and Staff role groups.

### E. User Interface Enhancements
- **Drag & Drop Quick Intake Tray (`tpl/Schedule/schedule.tpl`)**:
  - Staff can drag any of the 5 treatment badges directly onto any open slot in the schedule.
  - Interactive validation: Dropping a Bed massage onto a Chair, or Reflexology onto the Massage Bed, is immediately blocked with an explanatory warning.
  - Interactive Intake Modal: Pops up upon drop, asking for:
    1. **Duration & Price** (pre-selected to standard duration with 1-click alternatives).
    2. **Customer Name** (required).
    3. **Phone Number** (for return lookup).
    4. **Number of Persons** (party size).
    5. **Notes / Special Requests** (pressure preferences, soreness, etc.).
  - Calculates the exact end date/time and passes all intake data to the booking engine with 1-click confirmation.
- **Global Header**: Features clean Cenacle Reflexology branding mark, ready for custom logo upload, plus a persistent quick color legend for the 5 treatment families.
- **Booking Creation Screen (`tpl/Reservation/create.tpl`)**: Includes a collapsible **Cenacle Services, Pricing & Bed Allocation Guide** right above the form, and pre-fills all intake data from drag-and-drop sessions.
- **Schedule Screen (`tpl/Schedule/schedule.tpl`)**: Displays a dedicated treatment category legend alongside the standard status markers.

---

## 5. Deployment & First-Time Setup Instructions

### Step 1: Database Setup

**Option A (Automated - 1 command)**:
```bash
# Usage: ./scripts/setup-cenacle-db.sh [db_name] [db_user] [db_password] [db_host]
./scripts/setup-cenacle-db.sh cenacle_booking cenacle_user your_secure_password localhost
```

**Option B (Manual)**:
1. Create a MySQL/MariaDB database:
   ```sql
   CREATE DATABASE cenacle_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'cenacle_user'@'localhost' IDENTIFIED BY 'your_secure_password';
   GRANT ALL PRIVILEGES ON cenacle_booking.* TO 'cenacle_user'@'localhost';
   FLUSH PRIVILEGES;
   ```
2. Import the base schema:
   ```bash
   mysql -u cenacle_user -p cenacle_booking < database_schema/create-schema.sql
   ```
3. Run version upgrades (required so all modern columns exist):
   ```bash
   for f in $(ls -v database_schema/upgrades/*/*.sql 2>/dev/null); do
       mysql -u cenacle_user -p cenacle_booking < "$f" 2>/dev/null || true
   done
   ```
4. Apply the Cenacle custom seed data:
   ```bash
   mysql -u cenacle_user -p cenacle_booking < database_schema/cenacle-setup.sql
   ```

### Step 2: Configuration Activation
1. Copy the Cenacle configuration to `config/config.php`:
   ```bash
   cp config/cenacle.config.php config/config.php
   ```
2. Edit `config/config.php` and set your database credentials:
   ```php
   'database' => [
       'type' => 'mysql',
       'user' => 'cenacle_user',
       'password' => 'your_secure_password',
       'hostspec' => 'localhost',
       'name' => 'cenacle_booking',
   ],
   ```
3. Set your public Web directory URL in `config/config.php`:
   ```php
   'script.url' => 'https://yourdomain.com/Web',
   ```

### Step 3: Logo Upload
When you are ready to upload your logo file:
- Place your logo file in `Web/img/custom-logo.png` or upload it through the administrator dashboard under:
  **Application Management → Application Settings → Logo**.

### Step 4: Staff Accounts
- Log in with the default admin account:
  - **Username**: `cenacle.admin`
  - **Password**: `cenacle123` *(change this immediately after initial login via Profile / Change Password)*
- Go to **Application Management → Manage Users** to create accounts for employees, assigning them to the **Staff** group.

