#!/usr/bin/env python3.9

import random
import string

import psycopg2
import os
import uuid

from psycopg2 import *


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


def execute(cur, query, data):
    try:
        cur.execute(query, data)
    except Exception as e:
        print(f"Failed to execute\n  {query}\n  {e}")


def create_project(cur):
    query = "INSERT INTO project (name, gitlab_project_id, gitlab_project_token, gitlab_webhook_secret, " \
            "jira_key, compass_component_id, compass_deployment_event_source_id) VALUES (%s, %s, %s, %s, " \
            "%s, %s, %s) RETURNING id;"
    compass_id = f'ari:cloud:compass:{uuid.uuid4()}:component/3a2c7123-c245-4e57-84df-081b5d316bb1/{uuid.uuid4()}'
    compass_source_id = f'{uuid.uuid4()}'
    # project = ''.join(random.sample(string.ascii_lowercase, 8))
    project = "blue-fox"
    data = (project, "63", "12345678", "12345678", "AUTO", compass_id, compass_source_id)
    execute(cur, query, data)
    project_id = cur.fetchone()[0]
    print(f'project_id = {project_id}')
    return project_id


def create_job(cur, project_id):
    job_query = "INSERT INTO job (branch, commit_sha, status, created_at, started_at, type, payload, project_id) " \
                "VALUES (%s, %s, %s, %s, %s, %s, %s, %s) RETURNING id;"
    job_data = (
        "branch1", "ABCDEF1234", "EXECUTING", "2023-01-01 12:00:00", "2023-01-01 12:00:00",
        "FUSION_360_CAM",
        "", f"{project_id}")
    execute(cur, job_query, job_data)
    job_id = cur.fetchone()[0]
    print(f'job_id = {job_id}')
    return job_id


def move_job_to_history(cur, job_id, executor_id, project_id):
    select_query = "SELECT * FROM job WHERE id = %s;"
    select_data = (job_id,)
    execute(cur, select_query, select_data)
    record = cur.fetchone()
    print(f'Job record: {record}')

    delete_query = "DELETE FROM job WHERE id IN (%s);"
    delete_data = [job_id]
    execute(cur, delete_query, delete_data)

    job_history_query = "INSERT INTO job_history (id, branch, commit_sha, executed_on, " \
                        "created_at, started_at, finished_at, " \
                        "result, reason, type, payload, project_id) " \
                        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING id;"
    job_history_data = (
        f"{job_id}", "branch3", "ABCDEF1234", f'{executor_id}',
        "2023-01-01 10:00:00", "2023-01-01 11:00:00", "2023-01-01 12:00:00",
        "SUCCESS", "", "ANY",
        "{ 'name' : 'job name 2' }", f'{project_id}')
    execute(cur, job_history_query, job_history_data)
    job_history_id = cur.fetchone()[0]
    print(f'job_history_id = {job_history_id}')
    return job_history_id


def create_executor(cur, job_id):
    name = ''.join(random.sample(string.ascii_lowercase, 8))
    executor_query = "INSERT INTO executor (host, port, name, currently_executing_job, type) " \
                     "VALUES (%s, %s, %s, %s, %s) RETURNING id;"
    executor_data = ("100.69.1.123", random.randint(1001, 9000), name, job_id, "FUSION_360")
    execute(cur, executor_query, executor_data)
    executor_id = cur.fetchone()[0]
    print(f'executor_id = {executor_id}')
    return executor_id


def create_attachment(cur, job_id):
    attachment_query = "INSERT INTO attachment (job_id, name, document_service_id, type) VALUES (%s, %s, %s, %s) RETURNING id;"
    attachment_data = (job_id, "file.csv", str(uuid.uuid4()), "CUTTING_PARAMETERS_CSV")
    execute(cur, attachment_query, attachment_data)
    attachment_id = cur.fetchone()[0]
    print(f'attachment_id = {attachment_id}')
    return attachment_id


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
    cur: cursor = conn.cursor()

    project_id = create_project(cur)

    job_id1 = create_job(cur, project_id)
    job_id2 = create_job(cur, project_id)

    executor_id = create_executor(cur, job_id2)

    job_history_id = move_job_to_history(cur, job_id1, executor_id, project_id)

    create_attachment(cur, job_history_id)

    # Commit the changes to the database
    conn.commit()

    print_tables(cur)

    # Close the cursor and the database connection
    cur.close()
    conn.close()


if __name__ == '__main__':
    main()
