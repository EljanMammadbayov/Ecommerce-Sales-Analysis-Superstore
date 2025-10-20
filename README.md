# Superstore Sales Performance Analysis

**Author:** Eljan Mammadbayov  
**Tools:** Excel, SQL, Power BI (DAX), Power Query 
**Data source:** Sample Superstore (public sample dataset) — cleaned and processed for analysis.

---

## Project overview
This project analyses e-commerce sales using the Sample Superstore dataset (2014–2017). It explores revenue, profit, discount impact, shipping efficiency, and customer/state-level performance. The goal is to identify profit drivers and operational improvements.

Key highlights:
- California & New York lead in both revenue and profit.
- Indiana, Georgia, and Michigan show the highest profit margins (efficiency per sale).
- High discounts (≈29–39%) correlate with losses in several states; low discounts (0–7.5%) tend to coincide with stronger profits.
- Technology (50.8%) and Office Supplies (42.8%) are the main profit drivers; Furniture lags at ~2.5%.
- Copiers, Phones, and Accessories (Technology) are the top subcategories by profit.
- First-class shipping offers the best balance of speed (2 days avg) and profit.

---

## How to view
1. Download the `.pbix` file and open it in Power BI Desktop.
2. Or view png screenshots attached in the repo.
---

## Key files
- `sql/Superstore SQL query.sql` — all SQL used for initial analysis (YoY sales, profit, shipping).
- `powerbi/E_commerce_Superstore_BI.pbix` — interactive dashboard
- `data/Sample - Superstore_working.xlsx` — cleaned data used in the project

---

## Business recommendations (brief)
1. Review discount strategy in high-loss states (Texas, Ohio) and reduce deep discounts.  
2. Prioritise marketing & inventory for Technology and Office Supplies categories.  
3. Investigate furniture pricing and supplier costs to control losses.  
4. Maintain First-class shipping option for high-value clients/products.

---

## License & data
This repository uses the public Sample Superstore dataset for educational purposes. Use freely, but please credit the [original dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final).

---

If you’d like, view the LinkedIn post & project presentation [here](https://www.linkedin.com/posts/eljan-mammadbayov-538348231_powerbi-excel-sql-activity-7386112820150546432-Luoa?utm_source=share&utm_medium=member_desktop&rcm=ACoAADnksPwB3U-SnU3RkcBBbgEtuwMWsjeYvMQ).
