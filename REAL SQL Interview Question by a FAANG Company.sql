-- REAL SQL Interview Question by a FAANG Company | SQL Interview Questions and Answers
-- Problem Inspiration: https://www.youtube.com/watch?v=2wN3D0jsj9k


-- Problem Statement:

-- Each transaction has two consecutive rows: one for the seller and one for the buyer. 
-- The transaction_id for the seller is lower than the transaction_id for the buyer, and 
-- the amount and date are the same for both.
-- Write an SQL query to find the top 5 seller-buyer pairs with the most transactions between them. 
-- Disqualify sellers who have also acted as buyers, and buyers who have also acted as sellers.

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_Date datetime
);

INSERT INTO transactions VALUES (1, 101, 500, '2025-01-01 10:00:01');
INSERT INTO transactions VALUES (2, 201, 500, '2025-01-01 10:00:01');
INSERT INTO transactions VALUES (3, 102, 300, '2025-01-02 00:50:01');
INSERT INTO transactions VALUES (4, 202, 300, '2025-01-02 00:50:01');
INSERT INTO transactions VALUES (5, 103, 700, '2025-01-03 06:00:01');
INSERT INTO transactions VALUES (6, 202, 700, '2025-01-03 06:00:01');
INSERT INTO transactions VALUES (7, 102, 200, '2025-01-03 10:50:01');
INSERT INTO transactions VALUES (8, 202, 200, '2025-01-03 10:50:01');
INSERT INTO transactions VALUES (9, 103, 500, '2025-01-01 11:00:01');
INSERT INTO transactions VALUES (10, 101, 500, '2025-01-01 11:00:01');

select * from transactions;

WITH transaction_pairs AS ( 
    SELECT transaction_id, customer_id AS seller_id, 
        LEAD(customer_id, 1) OVER (ORDER BY transaction_id) AS buyer_id,amount        
    FROM transactions
    ), seller_buyer_pairs AS (
    SELECT seller_id, buyer_id,COUNT(*) AS no_transactions
    FROM transaction_pairs 
    WHERE transaction_id % 2 = 1
    GROUP BY seller_id, buyer_id)
SELECT seller_id, buyer_id, no_transactions
FROM seller_buyer_pairs
WHERE seller_id NOT IN (SELECT buyer_id FROM seller_buyer_pairs)  
  AND buyer_id NOT IN (SELECT seller_id FROM seller_buyer_pairs)  
ORDER BY no_transactions DESC;



