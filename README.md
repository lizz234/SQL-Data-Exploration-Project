# 🧪 SQL Data Exploration Project: COVID-19 Global Data

Welcome to the **SQL Data Exploration Project**, where I dive deep into global COVID-19 data using SQL and uncover insights on death rates, vaccination trends, and population impacts across countries and continents.

---

## 📂 Project Overview

This project focuses on performing **data analysis using SQL** on real-world COVID-19 datasets, combining death and vaccination data to explore:

- Total cases and deaths by country
- Death rates and mortality analysis
- Vaccination progress over time
- Population vs. vaccination insights
- Ranking countries by impact

The analysis is performed using **MySQL Workbench**, leveraging advanced SQL features like:
- Window functions
- CTEs (Common Table Expressions)
- Views and aggregations
- Data cleaning techniques

---

## 📊 Datasets Used

The data comes from publicly available sources:

- `coviddeaths`: Includes daily COVID-19 deaths, cases, population, and continent info
- `covidvaccinations`: Tracks new and total vaccinations by date and country

Both datasets were loaded into MySQL for exploration and cleaned to handle missing or inconsistent data types (e.g., empty strings, inconsistent dates).

---

## 🔍 Key Insights

- Countries with the highest death tolls globally
- % of population vaccinated per country over time
- Rolling vaccination trends using `SUM(...) OVER (...)`
- Use of window functions to track cumulative metrics
- Identifying trends by continent

---

## 🛠 SQL Features Used

- `JOIN`, `GROUP BY`, `ORDER BY`
- `CAST`, `NULLIF`, and `STR_TO_DATE` for data cleaning
- `SUM(...) OVER (PARTITION BY...)` for rolling metrics
- Creating **views** and **tables** for storing processed results

---
