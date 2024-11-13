SELECT p.prisonerName, cb.securityLevel 
FROM prisoner p
JOIN cell c ON p.cellNo = c.cellNo
JOIN cell_Block cb ON c.cellBlockID = cb.cellBlockID
WHERE p.prisonerID >8970;
