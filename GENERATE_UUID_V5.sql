DECLARE NAMESPACE_OID_IN_BYTES BYTES; 
SET NAMESPACE_OID_IN_BYTES = b'k\xa7\xb8\x12\x9d\xad\x11\xd1\x80\xb4\x00\xc0O\xd40\xc8';

CREATE TEMP FUNCTION FORMAT_UUID(UUID STRING)
  RETURNS STRING
  AS (
    CONCAT(SUBSTR(UUID,1,8), "-", SUBSTR(UUID,9,4), "-", SUBSTR(UUID,13,4), "-", SUBSTR(UUID,17,4), "-", SUBSTR(UUID,21,12))
  );

CREATE TEMP FUNCTION GENERATE_UUID_V5(Reference STRING, namespace_in_bytes BYTES)
  RETURNS STRING
  AS (
    FORMAT_UUID(
      TO_HEX(
        CAST(
          TO_HEX(LEFT(SHA1(CONCAT(namespace_in_bytes, CAST(Reference AS BYTES FORMAT 'UTF8'))), 16)) AS BYTES FORMAT 'HEX') & CAST('ffffffffffff0fff3fffffffffffffff' AS BYTES FORMAT 'HEX') | CAST('00000000000050008000000000000000' 
        AS BYTES FORMAT 'HEX')
      )
    )
  );

SELECT 
  reference,
  GENERATE_UUID_V5(reference, NAMESPACE_OID_IN_BYTES) AS UUID
  FROM UNNEST(["123","123456"]) AS reference;