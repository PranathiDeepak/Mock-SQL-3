WITH CTE AS (
    SELECT 
        o.seller_id,
        i.item_brand,
        u.favorite_brand,
        DENSE_RANK() OVER (PARTITION BY o.seller_id ORDER BY o.order_date) AS rnk
    FROM orders o
    JOIN items i ON o.item_id = i.item_id
    JOIN users u ON o.seller_id = u.user_id
),
CTE2 AS (
    SELECT 
        seller_id,
        item_brand,
        favorite_brand
    FROM CTE
    WHERE rnk = 2
)
SELECT 
    u.user_id AS seller_id,
    CASE 
        WHEN c.item_brand = u.favorite_brand THEN 'yes'
        ELSE 'no'
    END AS '2nd_item_fav_brand'
FROM users u
LEFT JOIN CTE2 c ON u.user_id = c.seller_id;
