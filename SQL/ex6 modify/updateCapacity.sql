UPDATE cell_Block
SET capacity = capacity + ROUND(capacity * 0.20)
WHERE occupancy > (capacity * 0.90);
