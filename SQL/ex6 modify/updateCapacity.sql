SET SQL_SAFE_UPDATES = 0;

UPDATE cell_Block
SET capacity = capacity + ROUND(capacity * 0.20)
WHERE occupancy > (capacity * 0.90);

SET SQL_SAFE_UPDATES = 1;