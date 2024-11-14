SET SQL_SAFE_UPDATES = 0;

DELETE FROM prisoner_Education
WHERE grade < 75
  AND attendance < 70
  AND prisonerID IN (
      SELECT prisonerID
      FROM prisoner
      WHERE dangerLevel = 'High'
      AND cellNo IN (
          SELECT cellNo
          FROM cell
          WHERE cellBlockID IN (
              SELECT cellBlockID
              FROM cell_Block
              WHERE securityLevel = 'Maximum'
          )
      )
  );

SET SQL_SAFE_UPDATES = 1;
