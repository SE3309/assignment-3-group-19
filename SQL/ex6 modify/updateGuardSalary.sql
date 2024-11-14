UPDATE guard g
SET salary = salary * 1.6
WHERE g.cellBlockID IN (
    SELECT cb.cellBlockID 
    FROM cell_Block cb
    WHERE cb.securityLevel = 'Maximum'
) 
AND g.salary < (SELECT MAX(cell_Block.occupancy) FROM cell_Block) *500;
