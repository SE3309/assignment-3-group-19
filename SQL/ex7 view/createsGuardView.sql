CREATE VIEW guards_with_blocks_and_salaries AS
SELECT g.badgeNo, g.guardName, g.salary, cb.cellBlockID, cb.securityLevel
FROM guard g
JOIN cell_Block cb ON g.cellBlockID = cb.cellBlockID;
