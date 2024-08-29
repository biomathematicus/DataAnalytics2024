import psycopg2

connection = psycopg2.connect(
  user="postgres", 
  password="pwd123", 
  host="postgres-db", 
  port=5432,
  options='-c search_path=data_schema'
)

cursor = connection.cursor()

cursor.execute("SELECT * from lea_LEACharacteristics limit 5;")

# Fetch all rows from database
record = cursor.fetchall()

print("Data from Database:- ", record)