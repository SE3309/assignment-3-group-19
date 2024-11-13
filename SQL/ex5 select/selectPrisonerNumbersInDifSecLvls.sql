SELECT cb.securityLevel, COUNT(p.prisonerID) AS numberOfPrisoners
FROM cell_Block cb
JOIN cell c ON cb.cellBlockID = c.cellBlockID
JOIN prisoner p ON c.cellNo = p.cellNo
GROUP BY cb.securityLevel;
