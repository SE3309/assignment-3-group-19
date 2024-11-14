SELECT cellBlockID, securityLevel, capacity, occupancy
FROM cell_Block
WHERE occupancy < capacity;
