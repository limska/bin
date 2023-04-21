#!/usr/bin/env python3

import psycopg2

# Establish a connection to the database
conn = psycopg2.connect(
    database="bluefox",
    user="bluefox",
    password="********",
    host="localhost",
    port="5432"
)

# Create a cursor object to execute SQL queries
cur = conn.cursor()

job_query = "INSERT INTO job (id, branch, commit_sha, status, created_at, started_at, type, payload, project_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
job_data = ("2", "branch2", "ABCDEF1234", "WAITING", "2023-01-01 12:00:00", "2023-01-01 12:00:00", "CUTTING_PARAMS_TEST_RUN", "{ 'name' : 'job name' }", "1")
cur.execute(job_query, job_data)

executor_query = "INSERT INTO executor (id, host, port, name, currently_executing_job, type) VALUES (%s, %s, %s, %s, %s, %s)"
executor_data = ("2", "100.69.1.123", "8000", "machine2", "2", "FUSION_360")
cur.execute(executor_query, executor_data)

# Commit the changes to the database
conn.commit()

# Close the cursor and the database connection
cur.close()
conn.close()

