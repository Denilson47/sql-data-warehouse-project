# SQL Naming Conventions

This document outlines the naming conventions used in this SQL Data Warehouse project to ensure consistency and readability.

## 1. General Rules
*   **Case:** Use `snake_case` for all object names (tables, columns, views).
*   **Language:** Use English for all names.
*   **Clarity:** Names should be descriptive and self-explanatory. Avoid abbreviations unless they are industry standard (e.g., `id`, `dt`).

## 2. Schema Naming
*   **Bronze:** `bronze` (Raw data, untouched).
*   **Silver:** `silver` (Cleaned, filtered, and standardized data).
*   **Gold:** `gold` (Business-level aggregations and dimensions).

## 3. Table Naming
*   **Dimensions:** Prefix with `dim_` (e.g., `dim_customers`, `dim_products`).
*   **Facts:** Prefix with `fact_` (e.g., `fact_sales`).
*   **Source Tables:** Use the source system name or generic descriptor (e.g., `crm_cust_info`).

## 4. Column Naming
*   **Primary Keys:** Use `table_name_id` or just `id` if clear (e.g., `customer_id`).
*   **Foreign Keys:** Use the referenced table name + `_key` or `_id` (e.g., `product_key`).
*   **Dates:** Suffix with `_date` (e.g., `order_date`, `create_date`).
*   **Booleans/Flags:** Use `is_` or `has_` prefix (e.g., `is_active`), though in this project we use descriptive text like 'Yes'/'No'.

## 5. Views and Stored Procedures
*   **Views:** Named similarly to tables but often without prefixes if they replace the table in the Gold layer (e.g., `gold.dim_customers`).
*   **Stored Procedures:** Use verb-noun structure (e.g., `load_silver`, `refresh_gold`).
