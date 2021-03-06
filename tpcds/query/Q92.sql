-- stats:
-- group by i_class_id: 17 groups, [5522, 348192] tuples per group

SELECT sum(ws_ext_discount_amt) AS "Excess Discount Amount"
FROM web_sales , item , date_dim ,
    (SELECT i_class_id AS class_id,
            1.3 * avg(ws_ext_discount_amt) AS avg_sales
     FROM web_sales ,
          date_dim ,
          item
     WHERE i_item_sk = ws_item_sk
       AND d_date BETWEEN '2000-01-01' AND '2000-04-01'
       AND d_date_sk = ws_sold_date_sk
     GROUP BY i_class_id) t
WHERE i_manufact_id = 200
  AND i_item_sk = ws_item_sk
  AND d_date BETWEEN '2000-01-01' AND '2000-04-01'
  AND d_date_sk = ws_sold_date_sk
  AND i_class_id = t.class_id
  AND ws_ext_discount_amt > t.avg_sales

-- Define IMID  = random(1,1000,uniform);
-- Define YEAR  = random(1998,2002,uniform);
-- Define WSDATE = date([YEAR]+"-01-01",[YEAR]+"-04-01",sales);
-- define _LIMIT=100;
-- 
-- [_LIMITA] select [_LIMITB] 
--    sum(ws_ext_discount_amt)  as "Excess Discount Amount" 
-- from 
--     web_sales 
--    ,item 
--    ,date_dim
-- where
-- i_manufact_id = [IMID]
-- and i_item_sk = ws_item_sk 
-- and d_date between '[WSDATE]' and 
--         (cast('[WSDATE]' as date) + 90 days)
-- and d_date_sk = ws_sold_date_sk 
-- and ws_ext_discount_amt  
--      > ( 
--          SELECT 
--             1.3 * avg(ws_ext_discount_amt) 
--          FROM 
--             web_sales 
--            ,date_dim
--          WHERE 
--               ws_item_sk = i_item_sk 
--           and d_date between '[WSDATE]' and
--                              (cast('[WSDATE]' as date) + 90 days)
--           and d_date_sk = ws_sold_date_sk 
--       ) 
-- order by sum(ws_ext_discount_amt)
-- [_LIMITC]; 