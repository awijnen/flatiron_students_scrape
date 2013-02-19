require "sqlite3"

# Databases
# Open a database
db = SQLite3::Database.new "test.db"

# Create table
rows = db.execute <<-SQL
  CREATE TABLE users (
    id integer PRIMARY KEY,
    first_name text,
    last_name text
  );
SQL

# Inserts data with parameter markers
data = ["1", "Anthony", "Wijnen"]

db.execute("INSERT INTO users (id, first_name, last_name)
            VALUES (?, ?, ?)", data)
