-- Electricity Department Government of Puducherry (PED)
-- Master Database Schema (PostgreSQL Compatible)
-- Generated for authoritative June 2026 Arrears & Staff System
-- Total Consumers: 197,690 | Total Arrears: ₹726.37 Cr

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

DROP TABLE IF EXISTS "admin_upload_logs" CASCADE;
CREATE TABLE "admin_upload_logs" (
  "id" SERIAL,
  "period" TEXT,
  "filename" TEXT,
  "uploaded_by" TEXT,
  "uploaded_at" TEXT,
  "status" TEXT,
  "record_count" BIGINT,
  "updated_live_count" BIGINT,
  "inserted_count" BIGINT,
  "sheets_count" BIGINT,
  "backup_path" TEXT,
  "error_message" TEXT,
  "audit_entry_id" BIGINT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "arrear_installments" CASCADE;
CREATE TABLE "arrear_installments" (
  "id" SERIAL,
  "arrear_id" BIGINT,
  "consumer_no" TEXT,
  "installment_no" BIGINT,
  "amount_paid_now" DOUBLE PRECISION,
  "remaining_amount" DOUBLE PRECISION,
  "due_date" TEXT,
  "approved_by" BIGINT,
  "approved_by_name" TEXT,
  "approver_role" TEXT,
  "notes" TEXT,
  "created_at" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "arrear_snapshots" CASCADE;
CREATE TABLE "arrear_snapshots" (
  "id" SERIAL,
  "upload_id" BIGINT,
  "period" TEXT,
  "consumer_no" TEXT,
  "section" TEXT,
  "name" TEXT,
  "region" TEXT,
  "bill_due" DOUBLE PRECISION,
  "arrears_total" DOUBLE PRECISION,
  "arrear_due" DOUBLE PRECISION,
  "bpsc_due" DOUBLE PRECISION,
  "total_amount_due" DOUBLE PRECISION,
  "total_paid" DOUBLE PRECISION,
  "last_paid_date" TEXT,
  "last_payment_amt" DOUBLE PRECISION,
  "arrear_ageing" TEXT,
  "category" TEXT,
  "department" TEXT,
  "connection_load" DOUBLE PRECISION,
  "disc_date" TEXT,
  "disc_reading" TEXT,
  "paid_after_disc" DOUBLE PRECISION,
  "recon_date" TEXT,
  "status" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "arrear_uploads" CASCADE;
CREATE TABLE "arrear_uploads" (
  "id" SERIAL,
  "period" TEXT,
  "uploaded_at" TEXT,
  "uploaded_by" TEXT,
  "record_count" BIGINT,
  "filename" TEXT,
  "status" TEXT,
  "backup_path" TEXT,
  "error_message" TEXT,
  "updated_live_count" BIGINT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "arrears" CASCADE;
CREATE TABLE "arrears" (
  "id" SERIAL,
  "consumer_no" TEXT,
  "section" TEXT,
  "name" TEXT,
  "bill_due" DOUBLE PRECISION,
  "total_arrears" DOUBLE PRECISION,
  "arrears_total" DOUBLE PRECISION,
  "paid_date" TEXT,
  "address" TEXT,
  "category" TEXT,
  "arrear_due" DOUBLE PRECISION,
  "bpsc_due" DOUBLE PRECISION,
  "total_amount_due" DOUBLE PRECISION,
  "total_paid" DOUBLE PRECISION,
  "last_payment_amount" DOUBLE PRECISION,
  "arrear_ageing" TEXT,
  "door_lock" TEXT,
  "disconnected_as_per_sheet" TEXT,
  "meter_stuck" TEXT,
  "department" TEXT,
  "connection_load" TEXT,
  "is_govt" BIGINT,
  "revenue_division" TEXT,
  "disc_date" TEXT,
  "disc_reading" TEXT,
  "paid_after_disc" DOUBLE PRECISION,
  "recon_date" TEXT,
  "installments" TEXT,
  "status" TEXT,
  "region" TEXT,
  "created_at" TEXT,
  "updated_at" TEXT,
  "updated_by" TEXT,
  "category_locked" BIGINT,
  "category_changed_at" TEXT,
  "category_changed_by" TEXT,
  "category_change_reason" TEXT,
  "risk_flags" TEXT,
  "risk_flag_count" BIGINT,
  "risk_flag_codes" TEXT,
  "source_file" TEXT,
  "source_sheet" TEXT,
  "source_row_num" BIGINT,
  "raw_row_json" TEXT,
  "has_correction" BIGINT,
  "corrections_json" TEXT,
  "corrected_department" TEXT,
  "corrected_paid_date" TEXT,
  "corrected_category" TEXT,
  "corrected_arrears_total" DOUBLE PRECISION,
  "risk_score" BIGINT,
  "risk_factors" TEXT,
  "risk_band" TEXT,
  "section_code" BIGINT,
  "division" TEXT,
  "promise_date" TEXT,
  "promise_amount" DOUBLE PRECISION,
  "promise_status" TEXT,
  "promise_notes" TEXT,
  "promise_recorded_by" TEXT,
  "promise_recorded_at" TEXT,
  "promise_resolved_at" TEXT,
  "broken_promise_count" BIGINT,
  "discontinued" TEXT,
  "date_of_discontinuation" TEXT,
  "meter_status" TEXT,
  "mobile" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "audit_log" CASCADE;
CREATE TABLE "audit_log" (
  "id" SERIAL,
  "entity" TEXT,
  "entity_id" TEXT,
  "action" TEXT,
  "actor" TEXT,
  "timestamp" TEXT,
  "prev_hash" TEXT,
  "entry_hash" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "bills" CASCADE;
CREATE TABLE "bills" (
  "id" SERIAL,
  "consumer_no" TEXT,
  "period" TEXT,
  "units_consumed" BIGINT,
  "amount" DOUBLE PRECISION,
  "due_date" TEXT,
  "status" TEXT,
  "payment_ref" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "broadcast_notifications" CASCADE;
CREATE TABLE "broadcast_notifications" (
  "id" SERIAL,
  "title" TEXT,
  "message" TEXT,
  "image_url" TEXT,
  "target_audience" TEXT,
  "priority" TEXT,
  "created_by" TEXT,
  "created_at" TEXT,
  "is_active" BIGINT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "complaints" CASCADE;
CREATE TABLE "complaints" (
  "id" SERIAL,
  "consumer_no" TEXT,
  "category" TEXT,
  "description" TEXT,
  "region" TEXT,
  "locality" TEXT,
  "feeder_id" TEXT,
  "lat" DOUBLE PRECISION,
  "lng" DOUBLE PRECISION,
  "photo_url" TEXT,
  "status" TEXT,
  "priority" TEXT,
  "assigned_to" BIGINT,
  "escalated_level" BIGINT,
  "escalated_to" BIGINT,
  "created_at" TEXT,
  "resolved_at" TEXT,
  "sla_deadline" TEXT,
  "resolution_photo_url" TEXT,
  "resolution_notes" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "consumer_corrections" CASCADE;
CREATE TABLE "consumer_corrections" (
  "id" SERIAL,
  "consumer_no" TEXT,
  "column_name" TEXT,
  "original_value" TEXT,
  "corrected_value" TEXT,
  "reason" TEXT,
  "flagged_by" TEXT,
  "flagged_at" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "consumers" CASCADE;
CREATE TABLE "consumers" (
  "consumer_no" TEXT,
  "name" TEXT,
  "mobile" TEXT,
  "region" TEXT,
  "locality" TEXT,
  "tariff_category" TEXT,
  "connection_type" TEXT,
  "address" TEXT,
  "meter_no" TEXT
);

DROP TABLE IF EXISTS "disconnection_events" CASCADE;
CREATE TABLE "disconnection_events" (
  "id" SERIAL,
  "consumer_no" TEXT,
  "event_type" TEXT,
  "event_date" TEXT,
  "recorded_at" TEXT,
  "recorded_by" BIGINT,
  "remarks" TEXT,
  "source" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "error_logs" CASCADE;
CREATE TABLE "error_logs" (
  "id" SERIAL,
  "request_id" TEXT,
  "source" TEXT,
  "timestamp" TEXT,
  "app_version" TEXT,
  "screen" TEXT,
  "error_type" TEXT,
  "http_status" BIGINT,
  "method" TEXT,
  "endpoint" TEXT,
  "employee_id" TEXT,
  "officer_name" TEXT,
  "officer_role" TEXT,
  "message" TEXT,
  "status" TEXT,
  "resolved_at" TEXT,
  "resolved_by" TEXT,
  "resolution_note" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "login_activity" CASCADE;
CREATE TABLE "login_activity" (
  "id" SERIAL,
  "employee_id" TEXT,
  "staff_id" BIGINT,
  "staff_name" TEXT,
  "role" TEXT,
  "outcome" TEXT,
  "reason" TEXT,
  "ip_address" TEXT,
  "user_agent" TEXT,
  "app_version" TEXT,
  "device_info" TEXT,
  "timestamp" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "outages" CASCADE;
CREATE TABLE "outages" (
  "id" SERIAL,
  "region" TEXT,
  "feeder_id" TEXT,
  "type" TEXT,
  "start_time" TEXT,
  "est_end_time" TEXT,
  "affected_consumer_count" BIGINT,
  "status" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "promise_to_pay_events" CASCADE;
CREATE TABLE "promise_to_pay_events" (
  "id" SERIAL,
  "arrear_id" BIGINT,
  "consumer_no" TEXT,
  "section" TEXT,
  "promise_date" TEXT,
  "promise_amount" DOUBLE PRECISION,
  "status" TEXT,
  "notes" TEXT,
  "recorded_by" TEXT,
  "recorded_at" TEXT,
  "resolved_at" TEXT,
  "resolved_by" TEXT,
  "resolution_reason" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "staff" CASCADE;
CREATE TABLE "staff" (
  "id" SERIAL,
  "name" TEXT,
  "employee_id" TEXT,
  "password_hash" TEXT,
  "role" TEXT,
  "designation" TEXT,
  "hierarchy_level" BIGINT,
  "region" TEXT,
  "locality" TEXT,
  "system_role" TEXT,
  "is_admin" BIGINT,
  "is_active" BIGINT,
  "must_change_password" BIGINT,
  "is_name_configured" BIGINT,
  "name_prefix" TEXT,
  "last_login_at" TEXT,
  "last_seen_at" TEXT,
  "created_at" TEXT,
  "updated_at" TEXT,
  PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "staff_area_assignment" CASCADE;
CREATE TABLE "staff_area_assignment" (
  "id" SERIAL,
  "staff_id" BIGINT,
  "locality" TEXT,
  PRIMARY KEY ("id")
);

-- Performance Indexes
CREATE INDEX IF NOT EXISTS idx_arrears_consumer_no ON arrears(consumer_no);
CREATE INDEX IF NOT EXISTS idx_arrears_section ON arrears(section);
CREATE INDEX IF NOT EXISTS idx_arrears_division ON arrears(division);
CREATE INDEX IF NOT EXISTS idx_arrears_status ON arrears(status);
CREATE INDEX IF NOT EXISTS idx_arrears_arrears_total ON arrears(arrears_total);
CREATE INDEX IF NOT EXISTS idx_arrears_mobile ON arrears(mobile);
CREATE INDEX IF NOT EXISTS idx_staff_employee_id ON staff(employee_id);
CREATE INDEX IF NOT EXISTS idx_broadcast_active ON broadcast_notifications(is_active);
CREATE INDEX IF NOT EXISTS idx_disconnection_consumer ON disconnection_events(consumer_no);
