
# Olist E-Commerce Data Analysis Insights

A comprehensive collection of SQL query results and insights from the Olist e-commerce dataset.  
This document highlights key findings across customer behavior, sales performance, product trends, and seller performance, supporting data-driven decision-making and strategic planning.


### Query 1: Top 10 Customers by Total Spending

- Shows the customers who spent the most across all orders.
- Helps identify high-value customers for loyalty programs and targeted marketing campaigns.
- Uses aggregation and ranking to highlight the top contributors.

**Sample Output:**

| customer_unique_id                        | total_spent |
|-------------------------------------------|------------|
| 0a0a92112bd4c708ca5fde585afaa872         | 13664.08   |
| da122df9eeddfedc1dc1f5349a1a690c         | 7571.63    |
| 763c8b1c9c68a0229c42c9fc6f662b93         | 7274.88    |

### Query 2: Top 3 Products per Category by Sales Volume

- Shows the best-selling products within each category.
- Helps identify which products are most popular and in demand.
- Supports inventory planning, promotions, and stocking decisions.
- Ranking is done per category using window functions.

**Sample Output:**

| category_name                  | product_id                              | sales_volume | rank |
|--------------------------------|----------------------------------------|-------------|------|
| agro_industry_and_commerce     | 11250b0d4b709fee92441c5f34122aed      | 22          | 1    |
| agro_industry_and_commerce     | 423a6644f0aa529e8828ff1f91003690      | 18          | 2    |
| agro_industry_and_commerce     | 672e757f331900b9deea127a2a7b79fd      | 17          | 3    |
| air_conditioning               | 98e91d0f32954dcd8505875bb2b42cdb      | 17          | 1    |
| air_conditioning               | ccb162ed569f47d83f62aebd5700d7ad      | 13          | 2    |
| air_conditioning               | 0e34187d4312b97b5e698836d28ed040      | 11          | 3    |

### Query 3: Monthly Revenue and Month-over-Month Growth

- Shows total revenue for each month and compares it to the previous month.  
- Helps track sales trends and identify seasonal fluctuations or growth patterns.  
- Useful for forecasting, planning promotions, and analyzing business performance.  
- Month-over-month growth highlights periods of strong or weak performance; **Feb 2017 had the highest growth** at 108.09%.

**Sample Output:**

| month_date | revenue     | prev_month_revenue | mom_growth_percent |
|------------|------------|------------------|------------------|
| 01/02/17   | 261110.99  | 125476.99        | 108.09           |
| 01/03/17   | 406757.56  | 261110.99        | 55.78            |
| 01/04/17   | 378584.58  | 406757.56        | -6.93            |
| 01/05/17   | 552801.27  | 378584.58        | 46.02            |
| 01/06/17   | 483525.74  | 552801.27        | -12.53           |

### Query 4: Cumulative Revenue per Seller Over Time

- Shows monthly revenue for each seller and tracks cumulative revenue over time.  
- Helps measure individual seller performance and growth trends.  
- Useful for identifying top-performing sellers and monitoring revenue contributions.

**Sample Output:**

| seller_id                           | month_date | monthly_revenue | cumulative_revenue |
|------------------------------------|------------|----------------|------------------|
| 0015a82c2db000af6aaaf3ae2ecb0532  | 01/09/17   | 916.02         | 916.02           |
| 0015a82c2db000af6aaaf3ae2ecb0532  | 01/10/17   | 1832.04        | 2748.06          |
| 001cca7ae9ae17fb1caed9dfb1094831  | 01/02/17   | 1295.40        | 1295.40          |
| 001cca7ae9ae17fb1caed9dfb1094831  | 01/03/17   | 2124.00        | 3419.40          |
| 001cca7ae9ae17fb1caed9dfb1094831  | 01/04/17   | 2087.55        | 5506.95          |


### Query 5: Customers with the Most Orders

- Shows customers ranked by total number of orders.  
- Helps identify loyal and repeat buyers for retention and marketing strategies.  
- Useful for targeted promotions, loyalty programs, and customer engagement.

**Sample Output:**

| customer_unique_id                 | total_orders | rank |
|-----------------------------------|--------------|------|
| 8d50f5eadf50201ccdcedfb9e2ac8455 | 17           | 1    |
| 3e43e6105506432c953e165fb2acf44c | 9            | 2    |
| 6469f99c1f9dfae7733b25662e7f1782 | 7            | 3    |
| 1b6c7548a2a1f9037c1fd3ddfed95f33 | 7            | 3    |
| ca77025e7201e3b30c44b472ff346268 | 7            | 3    |

### Query 6: Sellers with Highest Average Product Review Ratings

- Shows sellers ranked by their average product review ratings.  
- Highlights top-performing sellers for recognition or incentives.  
- Useful for improving marketplace quality and promoting trusted sellers.

**Sample Output:**

| seller_id                           | avg_rating | review_count | row_num |
|------------------------------------|------------|--------------|---------|
| bdf0d02d36a1d839d0c39c4a887cdd49  | 5          | 7            | 1       |
| e439f7176d763f92de325271111b2fd5  | 5          | 7            | 2       |
| c3fe93ba3085f92855c97e57f38c8c05  | 5          | 7            | 3       |
| 186cdd1b2df32caa72cfb410bba768d3  | 5          | 6            | 4       |
| a64e44665225d19dfc0277eeeaaccc57  | 5          | 6            | 5       |

### Query 7: Orders with Longest Delivery Delays

- Shows orders ranked by the number of days taken to be delivered.  
- Helps detect fulfillment issues and bottlenecks in delivery.  
- Useful for identifying problem areas in logistics and improving customer satisfaction.

**Sample Output:**

| order_id                           | customer_id                           | order_date | delivered_date | delivery_days | rank |
|-----------------------------------|---------------------------------------|------------|----------------|---------------|------|
| ca07593549f1816d26a572e06dc1eab6 | 75683a92331068e2d281b11a7866ba44     | 21/02/17   | 19/09/17       | 209.63        | 1    |
| 1b3190b2dfa9d789e1f14c05b647a14a | d306426abe5fca15e54b645e4462dc7b     | 23/02/18   | 19/09/18       | 208.35        | 2    |
| 440d0d17af552815d15a9e41abe49359 | 7815125148cfa1e8c7fee1ff7974f16c     | 07/03/17   | 19/09/17       | 195.63        | 3    |
| 2fb597c2f772eca01b1f5c561bf6cc7b | 217906bc11a32c1e470eb7e08584894b     | 08/03/17   | 19/09/17       | 194.85        | 4    |
| 285ab9426d6982034523a855f55a885e | 9cf2c3fa2632cee748e1a59ca9d09b21     | 08/03/17   | 19/09/17       | 194.63        | 5    |


### Query 8: Percentage Contribution of Each Item to Order Total

- Shows each item’s contribution to the total value of its order.  
- Helps determine which items dominate order value for pricing strategies or promotions.  
- Useful for identifying high-value products and optimizing upselling opportunities.

**Sample Output:**

| order_id                           | product_id                          | item_total | total_order_value | pct_of_order |
|-----------------------------------|------------------------------------|------------|------------------|--------------|
| 0812eb902a67711a1cb742b3cdaa65ae | 489ae2aa008f021502940f251d4cce7f  | 6929.31    | 6929.31          | 100          |
| fefacc66af859508bf1a7934eab1e97f | 69c590f7ffc7bf8db97190b6cb6ed62e  | 6922.21    | 6922.21          | 100          |
| f5136e38d1a14a4dbd87dff67da82701 | 1bdf5e6731585cf01aa8169c7028d6ad  | 6726.66    | 6726.66          | 100          |
| a96610ab360d42a2e5335a3998b4718a | a6492cc69376c469ab6f61d8f44de961  | 4950.34    | 4950.34          | 100          |
| 199af31afc78c699f0dbf71fb178d4d4 | c3ed642d592594bb648ff4a04cee2747  | 4764.34    | 4764.34          | 100          |


### Query 9: Distribution of Payment Types Across All Orders

- Shows the distribution of different payment types used by customers.  
- Helps understand customer payment preferences and guide payment strategy.  
- Useful for prioritizing payment methods and optimizing checkout options.

**Sample Output:**

| payment_type | total_orders | pct_of_orders |
|--------------|--------------|---------------|
| credit_card  | 75768        | 73.95         |
| boleto       | 19495        | 19.03         |
| voucher      | 5704         | 5.57          |
| debit_card   | 1485         | 1.45          |


### Query 10: Sellers with Most Consistent Monthly Sales

- Shows sellers ranked by consistency in monthly sales.  
- Helps identify reliable sellers for stable supply and accurate forecasting.  
- Useful for supplier management, demand planning, and minimizing stockouts.

**Sample Output:**

| seller_id                           | months_with_sales | avg_monthly_sales | sales_stddev | d_rank |
|------------------------------------|-----------------|-----------------|--------------|--------|
| a0a14e50070f3225b3eabba5b85da517  | 2               | 124.32          | 0            | 1      |
| 1d0646a72178a6fb37ee8082140e06ec  | 2               | 48.81           | 0            | 1      |
| 51209b446b2073894bdc0face6c73ffc  | 2               | 219.44          | 0            | 1      |
| 8060d731897e33b5c5ae575ce1e209e1  | 2               | 116.41          | 0.21         | 2      |
| c398bc00a606d33758afd91f4e64fd15  | 2               | 82.75           | 0.28         | 3      |

### Query 11: Products Generating Highest Revenue

- Shows products ranked by total revenue generated.  
- Highlights the most profitable products for strategic focus and inventory planning.  
- Useful for prioritizing marketing, promotions, and product sourcing decisions.

**Sample Output:**

| product_id                           | product_name           | total_revenue | total_orders | rank |
|--------------------------------------|-----------------------|---------------|--------------|------|
| bb50f2e236e5eea0100680137654686c    | health_beauty         | 66538.40      | 192          | 1    |
| d1c427060a0f73f6b889a5c7c61f2ac4    | computers_accessories | 57382.33      | 322          | 2    |
| 6cdd53843498f92890544667809f1595    | health_beauty         | 57101.35      | 151          | 3    |
| 99a4788cb24856965c36a24e339b6058    | bed_bath_table        | 49408.18      | 472          | 4    |
| d6160fb7873f184099d9bc95e30376af    | computers             | 47314.18      | 33           | 5    |


### Query 12: Average Order Value per Customer State

- Shows the average order value for each customer state.  
- Reveals spending behavior by state to tailor marketing, promotions, and pricing strategies.  
- Useful for identifying high-value states and optimizing regional targeting.

**Sample Output:**

| customer_state | avg_order_value | total_orders |
|----------------|----------------|--------------|
| PB             | 263.79         | 501          |
| AC             | 252.18         | 75           |
| AP             | 240.92         | 67           |
| AL             | 238.64         | 389          |
| RO             | 236.13         | 237          |


### Query 13: Customers at Risk of Churn

- Shows customers who have not placed orders recently and are at risk of churning.  
- Helps identify inactive customers for re-engagement campaigns.  
- Useful for retention strategies, targeted marketing, and improving customer lifetime value.

**Sample Output:**

| customer_unique_id                 | last_order_date | customer_status   |
|-----------------------------------|----------------|-----------------|
| 830d5b7aaa3b6f1e9ad63703bec97d23 | 15/09/16       | Potential Churn |
| 8d3a54507421dbd2ce0a1d58046826e0 | 03/10/16       | Potential Churn |
| 87776adb449c551e74c13fc34f036105 | 03/10/16       | Potential Churn |
| 2f64e403852e6893ae37485d5fcacdaf | 03/10/16       | Potential Churn |
| 10e89fd8e5c745f81bec101207ba4d7d | 03/10/16       | Potential Churn |


### Query 14: Orders Containing Repeated Items

- Shows orders that contain multiple quantities of the same item.  
- Helps detect unusual buying patterns, bulk purchases, or potential fraud.  
- Useful for inventory planning, promotions, and understanding customer buying behavior.

**Sample Output:**

| order_id                           | product_id                           | product_category       | item_count |
|-----------------------------------|-------------------------------------|-----------------------|------------|
| 1b15974a0141d54e36626dca3fdc731a | ee3d532c8a438679776d222e997606b3   | computers_accessories | 20         |
| ab14fdcfbe524636d65ee38360e22ce8 | 9571759451b1d780ee7c15012ea109d4   | auto                  | 20         |
| 428a2f660dc84138d969ccd69a0ab6d5 | 89b190a046022486c635022524a974a8   | furniture_decor       | 15         |
| 9ef13efd6949e4573a18964dd1bbe7f5 | 37eb69aca8718e843d897aa7b82f462d   | garden_tools          | 15         |
| 73c8ab38f07dc94389065f7eba4f297a | 422879e10f46682990de24d770e7f83d   | garden_tools          | 14         |


### Query 15: Most Frequently Purchased Product Combinations

- Shows pairs of products that are commonly purchased together.  
- Supports cross-selling strategies and bundle recommendations (market basket analysis).  
- Useful for promotions, product placement, and increasing average order value.

**Sample Output:**

| product_a                           | product_b                           | combo_count |
|------------------------------------|------------------------------------|-------------|
| 05b515fdc76e888aada3c6d66c201dff  | 270516a3f41dc035aa87d220228f844c  | 100         |
| 36f60d45225e60c7da4558b070ce4b60  | e53e557d5a159f5aa2c5e995dfdf244b  | 48          |
| 62995b7e571f5760017991632bbfd311  | ac1ad58efc1ebf66bfadc09f29bdedc0  | 36          |
| 710b7c26b7a742f497bba45fab91a25f  | a9d9db064d4afd4458eb3e139fe29167  | 36          |
| 308e4e21ae228a10f6370a243ae59995  | 90b58782fdd04cb829667fcc41fb65f5  | 30          |


### Query 16: Category-wise Growth Trends

- Shows monthly revenue and month-over-month growth for each product category.  
- Helps measure which categories are growing fastest, supporting inventory planning and strategic focus.  
- Useful for identifying trends, seasonal patterns, and high-growth opportunities.

**Sample Output:**

| category_name                  | month      | monthly_revenue | prev_month_revenue | mom_growth_pct |
|--------------------------------|-----------|----------------|------------------|----------------|
| agro_industry_and_commerce     | 01/01/17  | 107.76         | NULL             | NULL           |
| agro_industry_and_commerce     | 01/02/17  | 331.10         | 107.76           | 207.26         |
| agro_industry_and_commerce     | 01/05/17  | 1763.74        | 110.69           | 1493.41        |
| air_conditioning               | 01/10/16  | 1503.61        | NULL             | NULL           |
| air_conditioning               | 01/02/17  | 2688.34        | 738.36           | 264.10         |
| air_conditioning               | 01/08/17  | 4563.49        | 1493.13          | 205.63         |


### Query 17: Category-wise Review Trends

- Shows average product review scores and total reviews per category over time.  
- Helps measure customer satisfaction and product performance by category.  
- Useful for improving quality, identifying popular products, and guiding inventory decisions.

**Sample Output:**

| category_name                  | month      | avg_review_score | total_reviews |
|--------------------------------|-----------|----------------|---------------|
| agro_industry_and_commerce     | 01/01/17  | 4.33           | 3             |
| agro_industry_and_commerce     | 01/02/17  | 3.86           | 7             |
| agro_industry_and_commerce     | 01/05/17  | 4.75           | 4             |
| air_conditioning               | 01/10/16  | 4.5            | 8             |
| air_conditioning               | 01/01/17  | 3.5            | 4             |
| air_conditioning               | 01/03/17  | 4.41           | 17            |


### Query 18: High-Value Orders with Low Review Scores

- Shows orders with high total value but low customer review scores.  
- Helps detect high-impact customer dissatisfaction for corrective actions.  
- Useful for prioritizing service recovery and improving product quality

**Sample Output:**

| order_id                           | total_order_value | review_score | product_category           |
|-----------------------------------|-----------------|-------------|----------------------------|
| 03caa2c082116e1d31e67e9ae3700499 | 13664.08        | 1           | fixed_telephony            |
| 736e1922ae60d0d6a89247b851902527 | 7274.88         | 1           | fixed_telephony            |
| 2cc9089445046817a7539d90805e6e5  | 6081.54         | 1           | agro_industry_and_commerce |
| 80dfedb6d17bf23539beeef3c768f4d7 | 4194.76         | 2           | small_appliances           |
| 66b9c991ee308f9342f6a7f63bb68251 | 3358.24         | 2           | fixed_telephony            |


---

## Conclusion

These insights provide a clear view of customer behavior, sales trends, and product performance. They can guide strategic decisions, improve operations, and enhance customer satisfaction.
