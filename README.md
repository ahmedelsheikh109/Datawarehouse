# Modern SQL Data Warehouse & Analytics

Welcome to the **Modern SQL Data Warehouse & Analytics** project! 🚀

This repository contains an end-to-end data engineering and analytics solution. It demonstrates the design and implementation of a robust data warehouse using the **Medallion Architecture**, taking raw data from disparate sources, transforming it into a clean, structured format, and finally modeling it for business intelligence and reporting.

---

## 🎯 Project Overview

The primary goal of this project is to consolidate sales data from both an ERP system and a CRM system into a single, unified data model. By resolving data quality issues and applying a structured architecture, the project provides an optimized environment for generating analytical insights.

**Key Highlights:**
- **ETL Pipeline:** Robust Extraction, Transformation, and Loading of data using SQL.
- **Medallion Architecture:** Implementation of Bronze, Silver, and Gold data layers.
- **Data Modeling:** Creation of a Star Schema (Fact and Dimension tables) optimized for fast querying.
- **Actionable Analytics:** SQL-driven insights focusing on customer behavior, product performance, and sales trends.

---

## 🏗️ Architecture Design

This project adopts the Medallion Architecture to progressively enrich and improve data quality:

1. **🥉 Bronze Layer (Raw Data):** 
   - Acts as the landing zone for raw data ingested from source systems (ERP and CRM CSV files) directly into the SQL Server database. No transformations are applied at this stage.

2. **🥈 Silver Layer (Cleansed & Conformed):** 
   - Data is cleansed, standardized, and normalized. This layer resolves data quality issues, handles missing values, and ensures data consistency across the pipeline.

3. **🥇 Gold Layer (Business-Ready):** 
   - The final layer where data is modeled into a highly optimized Star Schema. This layer is specifically designed to support reporting tools, BI dashboards, and complex analytical queries.

*(Please refer to the `docs/` folder for detailed architecture diagrams, data flow designs, and data catalogs).*

---

## 🛠️ Technology Stack

- **Database Engine:** SQL Server
- **Development Tool:** SQL Server Management Studio (SSMS)
- **Data Processing:** T-SQL (Stored Procedures, Views, DDL/DML)
- **Modeling & Architecture Design:** Draw.io
- **Version Control:** Git & GitHub

---

## 📂 Repository Structure

```text
├── datasets/             # Source data files (ERP & CRM exports)
├── docs/                 # Documentation, data dictionaries, and diagrams
├── scripts/              
│   ├── bronze/           # DDL and load procedures for the Bronze layer
│   ├── silver/           # DDL and transformation procedures for the Silver layer
│   ├── gold/             # DDL and Star Schema definitions for the Gold layer
│   └── init_database.sql # Database initialization script
├── tests/                # SQL scripts for data quality and integrity checks
├── README.md             # Project documentation
└── .gitignore            # Git ignore configurations
```

---

## 🚀 Getting Started

To run this project locally and build the data warehouse:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/ahmedelsheikh109/Datawarehouse.git
   ```

2. **Initialize the Database:**
   - Open SQL Server Management Studio (SSMS).
   - Execute the `scripts/init_database.sql` script to create the database and required schemas.

3. **Execute the ETL Pipelines:**
   - **Bronze Layer:** Run the scripts in the `scripts/bronze/` folder to build tables and load the raw CSV data.
   - **Silver Layer:** Run the scripts in the `scripts/silver/` folder to clean and transform the data.
   - **Gold Layer:** Run the scripts in the `scripts/gold/` folder to assemble the final Star Schema model.

4. **Validate Data (Optional):**
   - Use the testing scripts located in the `tests/` directory to ensure data integrity across the Silver and Gold layers.

---

## 👨‍💻 About the Author

**Ahmed Elsheikh**  
*Data Engineer & Analyst*

I am passionate about building scalable data architectures, optimizing ETL pipelines, and translating raw data into actionable business insights. 

📫 **Let's Connect:**
- [GitHub Profile](https://github.com/ahmedelsheikh109)
