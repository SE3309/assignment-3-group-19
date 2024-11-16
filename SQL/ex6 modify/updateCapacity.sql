SET SQL_SAFE_UPDATES = 0;
-- Remove the SQL_SAFE_UPDATES IF NOT USING MYSQL
UPDATE cell_Block
SET capacity = capacity + ROUND(capacity * 0.20)
WHERE occupancy > (capacity * 0.90);

SET SQL_SAFE_UPDATES = 1;