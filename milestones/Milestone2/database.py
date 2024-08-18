import os
import pymysql.cursors

# note that your remote host where your database is hosted
# must support user permissions to run stored triggers, procedures and functions.
db_host = os.environ["DB_HOST"]
db_username = os.environ["DB_USER"]
db_password = os.environ["DB_PASSWORD"]
db_name = os.environ["DB_NAME"]


class Database:

  @staticmethod
  def connect():
    """
        This method creates a connection with your database
        IMPORTANT: all the environment variables must be set correctly
                   before attempting to run this method. Otherwise, it
                   will throw an error message stating that the attempt
                   to connect to your database failed.
        """
    try:
      conn = pymysql.connect(host=db_host,
                             port=3306,
                             user=db_username,
                             password=db_password,
                             db=db_name,
                             charset="utf8mb4",
                             cursorclass=pymysql.cursors.DictCursor)
      print("Bot connected to database {}".format(db_name))
      return conn
    except ConnectionError as err:
      print(f"An error has occurred: {err.args[1]}")
      print("\n")

  #TODO: needs to implement the internal logic of all the main query operations
  def get_response(self, query, values=None, fetch=False, many_entities=False):
    """
        query: the SQL query with wildcards (if applicable) to avoid injection attacks
        values: the values passed in the query
        fetch: If set to True, then the method fetches data from the database (i.e with SELECT)
        many_entities: If set to True, the method can insert multiple entities at a time.
        """
    connection = self.connect()
    try:
        with connection.cursor() as cursor:
            if values:
                if many_entities:
                    cursor.executemany(query, values)
                else:
                    cursor.execute(query, values)
            else:
                cursor.execute(query)

            if fetch:
                if many_entities:
                    response = cursor.fetchall()
                else:
                    response = cursor.fetchall() if fetch else None
            else:
                connection.commit()
                response = None

    except pymysql.MySQLError as e:
        print(f"An error occurred: {e}")
        response = None
    finally:
        connection.close()
    return response

  @staticmethod
  def select(query, values=None, fetch=True):
    database = Database()
    return database.get_response(query, values=values, fetch=fetch)

  @staticmethod
  def insert(query, values=None, many_entities=False):
    database = Database()
    return database.get_response(query,
                                 values=values,
                                 many_entities=many_entities)

  @staticmethod
  def update(query, values=None):
    database = Database()
    return database.get_response(query, values=values)

  @staticmethod
  def delete(query, values=None):
    database = Database()
    return database.get_response(query, values=values)
    
class Query: 
  GET_USER = "SELECT * FROM User WHERE email = %s"
  GET_USER_ID = "SELECT user_id FROM User WHERE email = %s"
  GET_ACCOUNT = "SELECT account_id FROM Accounts WHERE username = %s"
  GET_ACCOUNT_ID = "SELECT accounts_id FROM User WHERE email = %s"
  GET_REPORT_ID = "SELECT report_id FROM Reports WHERE title = %s"
  GET_SOLUTION_ID = "SELECT solution_id FROM Solutions WHERE solution_name = %s"
  GET_SOLUTION_BU = "SELECT solution_id FROM SolutionBackup WHERE solution_name = %s"
  GET_SOLUTION_BU_ID = "SELECT * FROM SolutionBackup WHERE solution_id = %s"
  GET_THREAT_ID = "SELECT threat_id FROM Threats WHERE threat_name = %s"
  GET_VUL_ID = "SELECT vulnerabilty_id FROM Vulnerabilities WHERE vulnerability_name = %s"
  GET_REG_ID = "SELECT registered_id FROM RegisteredUsers WHERE registered_user_id = %s"
  GET_DEVICE_ID = "SELECT device_id FROM Devices WHERE user_log = %s"
  GET_SEVERITY_LEVEL = "SELECT severity_id FROM SeverityLevel WHERE title = %s"
  GET_COMPANY_ID = "SELECT company_id FROM Company WHERE name = %s"

  GET_USER_THREAT_NAME = "SELECT DISTINCT u.name, t.threat_name\
                          FROM User u\
                          JOIN RegisteredUsers ru ON u.accounts_id = ru.registered_user_id\
                          JOIN Devices d ON ru.registered_id = d.user_log\
                          JOIN InfectedDevices id ON d.device_id = id.device_id\
                          JOIN Threats t ON id.threat_id = t.threat_id\
                          WHERE t.threat_name = %s"
  GET_USER_THREAT = "SELECT DISTINCT u.name, t.threat_name\
                      FROM User u\
                      JOIN RegisteredUsers ru ON u.accounts_id = ru.registered_user_id\
                      JOIN Devices d ON ru.registered_id = d.user_log\
                      JOIN InfectedDevices id ON d.device_id = id.device_id\
                      JOIN Threats t ON id.threat_id = t.threat_id"
  GET_SOLUTION_NAME = "SELECT r.title, t.threat_name, u.name\
                      FROM Reports r\
                      JOIN RegisteredUsers ru ON r.submitted_by = ru.registered_id\
                      JOIN User u ON ru.registered_id = u.user_id\
                      JOIN Threats t ON r.threat = t.threat_id\
                      JOIN Solutions s ON t.threat_id = s.solution_id\
                      WHERE s.solution_name =%s"
  GET_ALL_SOLUTION = "SELECT r.title, t.threat_name, u.name\
                      FROM Reports r\
                      JOIN RegisteredUsers ru ON r.submitted_by = ru.registered_id\
                      JOIN User u ON ru.registered_id = u.user_id\
                      JOIN Threats t ON r.threat = t.threat_id\
                      JOIN Solutions s ON t.threat_id = s.solution_id"
  GET_CLOSE_REPORT = "SELECT r.title, u.name, s.status_name\
                      FROM Reports r\
                      JOIN RegisteredUsers ru ON r.submitted_by = ru.registered_id\
                      JOIN User u ON ru.registered_id = u.user_id\
                      JOIN Status s ON r.status = s.status_id\
                      WHERE s.status_name = 'Closed'\
                      AND NOT EXISTS (\
                          SELECT 1\
                          FROM Solutions sol\
                          WHERE sol.solution_id = r.report_id\
                      )"
  GET_LESS_DESC = "SELECT r.title, r.description, u.name\
                  FROM Reports r\
                  JOIN RegisteredUsers ru ON r.submitted_by = ru.registered_id\
                  JOIN User u ON ru.registered_id = u.user_id\
                  WHERE LENGTH(r.description) < 20"
  GET_NAME_TITLE_ALERT = "SELECT t.threat_name, sl.title, a.alert_date \
                          FROM Alert a\
                          JOIN Threats t ON t.threat_id = a.threat\
                          JOIN SeverityLevel sl ON sl.severity_id = t.severity_level\
                          WHERE t.threat_id = %s"
  
  ADD_ACCOUNT = "INSERT INTO Accounts (username, password) VALUES (%s, %s)"
  ADD_USER = "INSERT INTO User (name, email, dob, user_type, accounts_id) VALUES (%s, %s, %s, %s, %s)"
  ADD_REG_USER = "INSERT INTO RegisteredUsers (registered_user_id) VALUES (%s)"
  ADD_REPORT = "INSERT INTO Reports (title, submitted_by, threat, vulnerability, publication_date, description, status) VALUES (%s, %s, %s, %s, %s, %s, %s)"
  ADD_DEVICE = "INSERT INTO Devices (user_log) VALUES (%s)"
  ADD_INFDEV = "INSERT INTO InfectedDevices (device_id, threat_id) VALUES (%s, %s)"
  ADD_THREAT = "INSERT INTO Threats (threat_name, status, severity_level) VALUES (%s, %s, %s)"
  
  DELETE_REPORT= "DELETE FROM Reports WHERE report_id = %s"
  DELETE_SOLUTION = "DELETE FROM Solutions WHERE solution_id = %s"
  DELETE_USER = "DELETE FROM User WHERE user_id = %s"
  DELETE_ACCOUNTS = "DELETE FROM Accounts WHERE account_id = %s"
  
  UPDATE_REPORTS_TITLE = "UPDATE Reports SET title = %s WHERE report_id = %s"
  UPDATE_REPORTS_THREAT = "UPDATE Reports SET threat = %s WHERE report_id = %s"
  UPDATE_REPORTS_VUL = "UPDATE Reports SET vulnerability = %s WHERE report_id = %s"
  UPDATE_REPORTS_DESC = "UPDATE Reports SET description = %s WHERE report_id = %s"
  UPDATE_SOLUTION_NAME = "UPDATE Solutions SET solution_name = %s WHERE solution_id = %s"
  UPDATE_SOLUTION_SOLUTION = "UPDATE Solutions SET solution = %s WHERE solution_id = %s"

  CALL_PROCEDURE = "CALL CreateForumProcedure(%s, %s, %s)"

  GET_EMPLOYEE_COUNT = "SELECT GetEmployeeCount(%s)"
  GET_USER_REPORTS_COUNT_FROM_DATE = "SELECT GetUserReportsCountFromDate(%s, %s)"