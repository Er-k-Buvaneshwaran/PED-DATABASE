# Electricity Department Government of Puducherry (PED)
## Official Master Database & Restoration Toolkit (June 2026 Authoritative Base)

[![GitHub license](https://img.shields.io/badge/license-Government_of_Puducherry-blue.svg)](LICENSE)
[![Database](https://img.shields.io/badge/Database-PostgreSQL%20%7C%20SQLite-green.svg)]()
[![Records](https://img.shields.io/badge/Consumers-197%2C690-brightgreen.svg)]()
[![Arrears](https://img.shields.io/badge/Total_Arrears-₹726.37_Cr-red.svg)]()

---

### 1. Executive Summary & Provenance
This repository contains the complete master dataset, schema DDL, and turnkey restoration toolkit for the **Electricity Department, Government of Puducherry (PED) Arrear & Disconnection Tracking System**.

- **Source Document**: `original_excel/Arrears_June-2026_Google_Sheet.xlsx` (22.75 MB)
- **Authoritative Date**: June 2026 (Statutory Reference Base)
- **Total Registered Consumers**: **197,690**
- **Total Outstanding Arrears**: **₹726,37,13,875.00** (~₹726.37 Crores)
- **Administrative Sections**: **44 Sections** across all Divisions (Urban, Rural North, Rural South)
- **Staff Accounts**: **57 Staff Profiles** (44 Junior Engineers, 6 Executive Engineers, 1 Superintending Engineer, 1 Master Admin, and Linemen)

---

### 2. Table Summary

| Table | Description | Total Records |
| :--- | :--- | :--- |
| `arrears` | Full consumer master ledger, policy numbers, sections, outstanding amounts, ageing, risk scores | **197,690** |
| `staff` | All administrative and field officers (JEs, EEs, SE, Admins) | **57** |
| `broadcast_notifications` | Statutory department circulars & high-priority revenue recovery directives | **4** |
| `disconnection_events` | Disconnection / reconnection field activity logs | **225** |
| `arrear_uploads` | Master ingestion audit records | **1** |
| `audit_log` | Cryptographic tamper-evident operational logs | **15** |
| `login_activity` | Administrative access records | **12** |

---

### 3. Repository Structure

```
PED-DATABASE/
├── data/
│   └── ped-connect.db.gz               # Compressed SQLite Master Database (61 MB)
├── original_excel/
│   └── Arrears_June-2026_Google_Sheet.xlsx # Authoritative Department Spreadsheet (22.7 MB)
├── schema.sql                           # Clean PostgreSQL DDL (Tables, Columns, Sequences, Indexes)
├── restore-to-postgres.js              # High-performance batch restore tool (500-row chunks)
├── package.json                         # Node.js dependencies (pg, better-sqlite3)
├── .gitignore
└── README.md
```

---

### 4. How to Restore to PostgreSQL (Railway, Supabase, Neon, or Local)

#### Step 1: Install Dependencies
```bash
npm install
```

#### Step 2: Run Restore with your Database Connection String
```bash
DATABASE_URL="postgresql://postgres:password@host:port/database" npm run restore
```

The script automatically:
1. Decompresses `data/ped-connect.db.gz`.
2. Connects to your PostgreSQL instance.
3. Creates all tables matching the verified schema.
4. Inserts all 197,690 consumers in safe 500-record transactions.
5. Builds composite indexes for instantaneous mobile & admin queries.
