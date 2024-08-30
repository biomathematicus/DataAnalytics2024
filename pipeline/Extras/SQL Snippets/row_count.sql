SET search_path TO data_schema;
SELECT 
    n.nspname AS schema_name,
    c.relname AS table_name,
    c.reltuples::BIGINT AS estimated_row_count
FROM 
    pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE 
    n.nspname = 'data_schema'
    AND c.relkind = 'r'
ORDER BY 
    schema_name, estimated_row_count DESC, table_name;