from faker import Faker
import random
import mysql.connector

fake = Faker()

# Connect to the MySQL database
connection = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password="adminadmin",
    database="prisoner_System"
)
cursor = connection.cursor()

try:
    # Insert cell blocks
    print("Inserting cell blocks...")
    cell_blocks = []
    for i in range(1, 51):  # Increase the number of cell blocks
        cell_blocks.append((i, random.choice(['Maximum', 'Medium', 'Minimum']), random.randint(100, 1000)))
    cursor.executemany("""
        INSERT INTO cell_Block (cellBlockID, securityLevel, capacity)
        VALUES (%s, %s, %s)
    """, cell_blocks)
    connection.commit()
    print(f"Inserted {len(cell_blocks)} cell blocks.")

    # Insert education courses
    print("Inserting education courses...")
    courses = []
    for i in range(1, 51):  # Increase the number of courses
        courses.append((i, random.choice(['Teaching', 'Programming', 'Accounting']),
                        random.choice(['Education', 'Vocational']), fake.name(), random.randint(20, 50)))
    cursor.executemany("""
        INSERT INTO education_Course (programID, programName, programType, instructorName, capacity)
        VALUES (%s, %s, %s, %s, %s)
    """, courses)
    connection.commit()
    print(f"Inserted {len(courses)} education courses.")

    # Insert guards
    print("Inserting guards...")
    guards = []
    for i in range(1, 5001):  # Increase the number of guards
        guards.append(
            (1000 + i, random.choice(range(1, 51)), fake.name(), fake.date_of_birth(minimum_age=21, maximum_age=60),
             random.randint(60, 100), random.randint(160, 200), random.randint(40000, 60000)))
    cursor.executemany("""
        INSERT INTO guard (badgeNo, cellBlockID, guardName, dateOfBirth, weightKg, heightCm, salary)
        VALUES (%s, %s, %s, %s, %s, %s, %s)
    """, guards)
    connection.commit()
    print(f"Inserted {len(guards)} guards.")

    # Insert cells, ensuring no cell block exceeds its capacity
    print("Inserting cells...")
    cells = []
    cell_counts = {i: 0 for i in range(1, 51)}  # Track the number of cells per cell block
    cursor.execute("SELECT cellBlockID, capacity FROM cell_Block")
    cell_block_capacities = {row[0]: row[1] for row in cursor.fetchall()}

    for i in range(1, 10001):  # Increase the number of cells
        cell_block_id = random.choice(range(1, 51))

        # Ensure the cell block does not exceed its capacity
        if cell_counts[cell_block_id] < cell_block_capacities[cell_block_id]:
            cells.append((i, cell_block_id, random.choice(['Solitary', 'Standard', 'Double']), random.randint(1, 3)))
            cell_counts[cell_block_id] += 1

    cursor.executemany("""
        INSERT INTO cell (cellNo, cellBlockID, cellType, floorNo)
        VALUES (%s, %s, %s, %s)
    """, cells)
    connection.commit()
    print(f"Inserted {len(cells)} cells.")

    # Insert prisoners, ensuring only one prisoner per cell
    print("Inserting prisoners...")
    cursor.execute("SELECT cellNo FROM cell WHERE cellNo NOT IN (SELECT cellNo FROM prisoner)")
    available_cells = cursor.fetchall()

    num_prisoners = min(len(available_cells), 9000)  # Define the number of prisoners based on available cells
    prisoners = []
    for i in range(1, num_prisoners + 1):
        assigned_cell = available_cells[i - 1][0]
        prisoners.append((i, assigned_cell, fake.name(), fake.date_of_birth(minimum_age=18, maximum_age=70),
                          random.randint(160, 200), random.randint(50, 100), random.choice(['Brown', 'Blue', 'Green']),
                          random.choice(['Black', 'Blonde', 'Brown', 'Red']),
                          fake.word(ext_word_list=['Robbery', 'Fraud', 'Assault', 'Drug Trafficking', 'Theft']),
                          random.choice(['Low', 'Medium', 'High'])))
    cursor.executemany("""
            INSERT INTO prisoner (prisonerID, cellNo, prisonerName, dateOfBirth, heightCm, weightKg, eyeColor, hairColor, offenseType, dangerLevel)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, prisoners)
    connection.commit()
    print(f"Inserted {len(prisoners)} prisoners.")

    # Fetch course capacities and current enrollment counts
    print("Fetching course capacities and enrollments...")
    cursor.execute("SELECT programID, capacity, enrolment FROM education_Course")
    courses = cursor.fetchall()

    # Create a dictionary to track enrollment for each course
    course_enrollment = {course[0]: {'capacity': course[1], 'enrollment': course[2]} for course in courses}

    # Insert prisoner education entries, ensuring no duplicate enrollments and respecting course capacity
    print("Inserting prisoner education entries...")
    prisoner_education_data = []  # List to store unique (prisonerStudentID, programID) pairs

    for i in range(1, num_prisoners + 1):
        num_courses = random.randint(1, 3)  # Each prisoner can take 1-3 courses
        enrolled_courses = set()
        for _ in range(num_courses):
            available_courses = [program_id for program_id, info in course_enrollment.items() if
                                 info['enrollment'] < info['capacity']]

            if not available_courses:
                # No courses available with capacity left
                break

            program_id = random.choice(available_courses)

            # Ensure uniqueness of (prisonerStudentID, programID)
            if program_id in enrolled_courses:
                continue

            # Add the unique pair to the list
            prisoner_education_data.append(
                (i, program_id, round(random.uniform(50, 100), 2), round(random.uniform(50, 100), 2)))

            # Update in-memory enrollment count for the course
            course_enrollment[program_id]['enrollment'] += 1
            enrolled_courses.add(program_id)

    cursor.executemany("""
        INSERT INTO prisoner_Education (prisonerID, programID, grade, attendance)
        VALUES (%s, %s, %s, %s)
    """, prisoner_education_data)
    connection.commit()
    print(f"Inserted {len(prisoner_education_data)} prisoner education entries.")

    # Insert incident reports
    print("Inserting incident reports...")
    incident_reports = []
    for i in range(1, 1001):  # Increase the number of incident reports
        incident_reports.append(
            (i, random.choice(range(1, num_prisoners + 1)), random.choice(range(1001, 1501)), fake.date_this_year()))
    cursor.executemany("""
        INSERT INTO incident_Report (incidentReportID, prisonerID, badgeNo, incidentReportDate)
        VALUES (%s, %s, %s, %s)
    """, incident_reports)
    connection.commit()
    print(f"Inserted {len(incident_reports)} incident reports.")

    # Insert prison transfer reports
    print("Inserting prison transfer reports...")
    transfer_reports = []
    for i in range(1, 201):  # Increase the number of transfer reports
        transfer_reports.append((i, random.choice(range(1, num_prisoners + 1)), fake.date_this_year()))
    cursor.executemany("""
        INSERT INTO prison_Transfer_Report (transferReportID, prisonerID, transferReportDate)
        VALUES (%s, %s, %s)
    """, transfer_reports)
    connection.commit()
    print(f"Inserted {len(transfer_reports)} prison transfer reports.")

except mysql.connector.Error as err:
    print(f"Error: {err}")
finally:
    cursor.close()
    connection.close()
    print("Database connection closed.")
