#!/usr/bin/env python3

import psycopg2
import os


def print_tables(cur):
    cur.execute("""SELECT table_name FROM information_schema.tables
           WHERE table_schema = 'public'""")
    tables = cur.fetchall()
    for table in tables:
        table_name = table[0]
        print(f'\nTable: {table_name}')
        cur.execute(f"SELECT * FROM {table_name}")
        rows = cur.fetchall()
        for row in rows:
            print(row)


def main():
    home_dir = os.path.expanduser("~")
    bluefox_password = os.path.join(home_dir, "keys", "bluefox")

    # Open the file in read mode
    with open(bluefox_password, 'r') as file:
        # Read all lines from the file into a list
        lines = file.readlines()

    password = lines[0].strip()  # Strip any newline characters from the line
    # print(f'password: "{password}"')

    # Establish a connection to the database
    conn = psycopg2.connect(
        database="bluefox",
        user="bluefox",
        password=password,
        host="localhost",
        port="5432"
    )

    # Create a cursor object to execute SQL queries
    cur = conn.cursor()

    print_tables(cur)

    project_query = "INSERT INTO project (id, name, gitlab_project_id, gitlab_project_token, gitlab_webhook_secret, " \
                    "jira_key, compass_component_id, compass_deployment_event_source_id) VALUES (%s, %s, %s, %s, %s, " \
                    "%s, %s, %s)"
    project_data = ("1", "blue-fox", "63", "12345678", "12345678", "AUTO",
                    "ari:cloud:compass:2edb6087-00f4-4968-bca5-fd6ade7628d4:component/3a2c7123-c245-4e57-84df"
                    "-081b5d316bb1/e340c3ef-f81f-4a49-9afd-d9e18c644f00",
                    "")
    cur.execute(project_query, project_data)

    job_query = "INSERT INTO job (id, branch, commit_sha, status, created_at, started_at, type, payload, project_id) " \
                "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
    job_data1 = (
        "2", "branch2", "ABCDEF1234", "WAITING", "2023-01-01 12:00:00", "2023-01-01 12:00:00",
        "CUTTING_PARAMS_TEST_RUN",
        "", "1")
    cur.execute(job_query, job_data1)

    executor_query = "INSERT INTO executor (id, host, port, name, currently_executing_job, type) " \
                     "VALUES (%s, %s, %s, %s, %s, %s)"
    executor_data = ("2", "100.69.1.123", "8000", "machine2", "2", "FUSION_360")
    cur.execute(executor_query, executor_data)

    job_history_query = "INSERT INTO job_history (id, branch, commit_sha, executed_on, " \
                        "created_at, started_at, finished_at, " \
                        "result, reason, type, payload, project_id) " \
                        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    job_history_data = (
        "3", "branch3", "ABCDEF1234", "2",
        "2023-01-01 10:00:00", "2023-01-01 11:00:00", "2023-01-01 12:00:00",
        "SUCCESS", "", "CUTTING_PARAMS_TEST_RUN",
        "{ 'name' : 'job name 2' }", "1")
    cur.execute(job_history_query, job_history_data)


    # Commit the changes to the database
    conn.commit()

    print_tables(cur)

    # Close the cursor and the database connection
    cur.close()
    conn.close()


if __name__ == '__main__':
    main()
