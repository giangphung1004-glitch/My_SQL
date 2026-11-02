# AdventureWorksDW2019 | SQL Practice & Business Analysis

## Overview

This repository contains a collection of **T-SQL exercises and business-oriented queries** built around the **AdventureWorksDW2019** sample data warehouse. The scripts cover SQL fundamentals and practical analysis of customers, products, orders, sales channels, and financial data.

The goal is to demonstrate how SQL can be used to retrieve, combine, transform, and summarize data for common business questions.

## Tools & Dataset

- **Database:** Microsoft AdventureWorksDW2019 (sample data warehouse)
- **Query language:** T-SQL (Microsoft SQL Server)
- **Recommended environment:** SQL Server Management Studio (SSMS) or another SQL Server-compatible query editor

> The database itself is not included in this repository. You will need access to AdventureWorksDW2019 to execute the queries.

## SQL Skills Covered

- Data retrieval with `SELECT`, `DISTINCT`, `TOP`, and `ORDER BY`
- Conditional filtering with `WHERE`, `IN`, `LIKE`, `BETWEEN`, and `IS NULL`
- String and date functions, computed columns, and `CASE WHEN`
- Multi-table `JOIN` operations and self-joins
- Aggregation with `COUNT`, `SUM`, `AVG`, `GROUP BY`, and `HAVING`
- Common Table Expressions (`CTEs`), subqueries, and `UNION ALL`
- Combining Internet and reseller sales data for reporting

## Repository Files

| File | Main topics |
| --- | --- |
| [`HomeworkKey 1 (1).sql`](HomeworkKey%201%20%281%29.sql) | SQL basics, calculated columns, sorting, removing duplicates, and top-ranked products |
| [`HomeworkKey 2 (1).sql`](HomeworkKey%202%20%281%29.sql) | Filtering, string matching, handling `NULL`, date functions, and employee data transformations |
| [`HomeworkKey 4 (1).sql`](HomeworkKey%204%20%281%29.sql) | Multi-table joins, products without sales, and parent-child relationships through self-joins |
| [`HomeworkKey 5 (1).sql`](HomeworkKey%205%20%281%29.sql) | Aggregation, grouping, `HAVING`, revenue and profit calculations, and monthly sales comparison using CTEs |
| [`SQL 2.sql`](SQL%202.sql) | Six business queries covering customer purchases, product performance, repeat orders, top categories, sales channels, and departmental finance |

## Featured Business Questions

The **`SQL 2.sql`** script addresses six reporting questions:

1. **Customer purchasing volume:** Which customers purchased the most units?
2. **Product sales performance:** Which products sold the most units?
3. **Repeat customers (2014):** Which customers placed at least two distinct orders in 2014?
4. **Top product categories (2014):** Which two product categories generated the most sales revenue?
5. **Sales channel comparison:** What is the revenue per order across Internet and reseller sales?
6. **Departmental financial summary:** What are the aggregated financial amounts for department groups and their parent groups?

## How to Run

1. Set up or connect to a Microsoft SQL Server instance containing the **AdventureWorksDW2019** database.
2. Open any `.sql` file in SSMS or a compatible SQL editor.
3. Select `AdventureWorksDW2019` as the active database, or execute:

   ```sql
   USE AdventureWorksDW2019;
   ```

4. Run the desired query and inspect its result set.

## Notes

- These scripts are **SQL learning and analysis exercises**, not a production reporting pipeline.
- Exercise descriptions and some inline comments are written in Vietnamese.
- Query results depend on the contents of the AdventureWorksDW2019 database used to run them.
