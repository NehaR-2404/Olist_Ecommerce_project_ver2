# Olist E-commerce SQL Project - version2

## Project Overview
This project is a comprehensive SQL analysis of the Olist E-commerce dataset, sourced from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). The goal is to extract actionable business insights by cleaning data, importing it into PostgreSQL, and performing SQL queries. The project demonstrates SQL proficiency, data cleaning techniques, and the ability to interpret results for business decision-making.

**Note:** This is the second version of the Olist E-commerce SQL analysis, featuring cleaning, refined queries, updated insights, and a demonstration pipeline integrating Pandas with PostgreSQL.

## Data Preparation
- Downloaded the dataset from Kaggle and explored each table to understand its structure and relationships.
- Cleaned data using **Pandas** to handle missing values, duplicates, and inconsistencies.
- Created a PostgreSQL database, defined tables, and imported the cleaned CSV files.

## Pandas–PostgreSQL Connection Demonstration
- Created a Python pipeline to demonstrate connection between **Pandas** and **PostgreSQL** using `SQLAlchemy` and `psycopg2`.
- This allows executing SQL queries directly from Python and fetching results as Pandas DataFrames.
- **Note:** Data was manually imported into PostgreSQL (pgAdmin4) and queried. The connection in Pandas is only for demonstration.

## SQL Queries & Analysis
Key example queries executed in PostgreSQL:  
- Top 10 customers by total spending  
- Top 3 products per category by sales volume  
- Monthly revenue and month-over-month growth  
- Orders with longest delivery delays  
- Sellers with highest average product review ratings  
- High-value orders with low review scores  

*For the full set of queries, refer to the `Olist_Ecommerce_queries_ver2/` folder.*

## Insights
- **High-value customers** identified for targeted marketing and loyalty initiatives.  
- **Best-selling products per category** revealed to optimize inventory and marketing strategy.  
- **Revenue trends** highlighted seasonal patterns and growth opportunities.  
- **Long delivery delays** indicated fulfillment bottlenecks.  
- **Top-rated sellers** recognized for performance incentives and quality monitoring.  
- **High-value orders with low review scores** flagged critical customer dissatisfaction.  

*For detailed insights from all queries, refer to `Olist_Ecommerce_Query_Insights_ver2.md`.*

## Challenges
- Cleaning and transforming large datasets for accurate import required careful handling of missing and inconsistent data.
- Mapping relationships between multiple tables without prior staging increased complexity, especially with foreign key dependencies.
- Writing efficient SQL queries for business insights while handling large datasets was time-consuming but crucial.

## Skills Demonstrated
- Efficiently importing and querying large datasets in PostgreSQL.
- Writing advanced SQL queries with joins, aggregation, and window functions.
- Integrating PostgreSQL with Python to fetch query results into Pandas for further analysis.
- Translating data into actionable business insights.
- Creating a demonstration pipeline to integrate data cleaning, querying, and analysis.

## Project Structure
```
Olist_Ecommerce_SQL_Project/
├── dataset/                                     # Original Kaggle CSV files
├── Olist_Ecommerce_queries_ver2/.               # SQL queries used for analysis
├── Query_Results_ver2/                          # Query results in CSV format
├── Olist_Ecommerce_Query_Insights_ver2.md       # Detailed insights from the queries
├── olist_clean_dataset.ipynb                    # Cleaning script for data cleaning and handling inconsitencies
├── olist_analysis_pipeline.ipynb                # Demonstration of connection pandas and postgresql             
├── README.md                                    # Project description and documentation
```

## Tools Used
- PostgreSQL  
- Python (Pandas, SQLAlchemy, psycopg2)  
- VS Code  

## Conclusion
This project demonstrates SQL expertise, data cleaning skills, and the ability to extract actionable insights from a real-world e-commerce dataset. The Pandas–PostgreSQL connection further showcases the ability to integrate SQL queries into a Python workflow, making it portfolio-ready.
