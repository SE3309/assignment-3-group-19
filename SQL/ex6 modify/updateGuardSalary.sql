UPDATE guard g
SET salary = salary * 1.6
WHERE cellBlockID IN (
    SELECT cellBlockID 
    FROM cell_Block
    WHERE securityLevel = 'Maximum'
);