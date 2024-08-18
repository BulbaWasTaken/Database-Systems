"""
In this file you must implement all your database models.
If you need to use the methods from your database.py call them
statically. For instance:
       # opens a new connection to your database
       connection = Database.connect()
       # closes the previous connection to avoid memory leaks
       connection.close()
"""

from database import Database, Query
from datetime import date

class AccountModel:

  def __init__(self, name, email, dob, user_type, alias, password):
    self.name = name
    self.email = email
    self.dob = dob
    self.user_type = user_type
    self.alias = alias
    self.password = password

  def createAccount(self):
    account_check = Database.select(Query.GET_USER, values=(self.email), fetch=True)
    if account_check:
      return 0

    Database.insert(Query.ADD_ACCOUNT, values=(self.alias, self.password))
    account_result = Database.select(Query.GET_ACCOUNT, values=(self.alias), fetch=True)

    if account_result:
      account_id = account_result[0]['account_id']

      Database.insert(Query.ADD_USER,
                      values=(self.name, self.email, self.dob, self.user_type,
                              account_id))
      reg_user_id = Database.select(Query.GET_ACCOUNT_ID, values=(self.email), fetch=True)
      reg_account_id = reg_user_id[0]['accounts_id']
      Database.insert(Query.ADD_REG_USER, values=(reg_account_id))

      return 1
    else:
      return 0

class ReportModel:

  def __init__(self, title, email, threat, vulnerability, description):
    self.title = title
    self.email = email
    self.threat = threat
    self.vulnerability = vulnerability
    self.description = description

  def addReport(self):
    user_id = Database.select(Query.GET_USER_ID, values=(self.email), fetch=True)
    if not user_id:
      return 2

    if self.threat != "NULL":
      threat_id = Database.select(Query.GET_THREAT_ID, values=(self.threat))
      if not threat_id:
        return 3

    if self.vulnerability != "NULL":
      vulnerability_id = Database.select(Query.GET_VUL_ID, values=(self.vulnerability))
      if not vulnerability_id:
        return 4

    reg_account_id = user_id[0]['user_id']
    Database.insert(Query.ADD_REG_USER, values=(reg_account_id))

    registered_id = Database.select(Query.GET_REG_ID, values=(reg_account_id))
    reg_user_id = registered_id[0]['registered_id']
    

    t_id = None if self.threat == "NULL" else threat_id[0]['threat_id']
    v_id = None if self.vulnerability == "NULL" else vulnerability_id[0][
        'vulnerabilty_id']
    status = 1

    Database.insert(Query.ADD_REPORT,
                    values=(self.title, reg_user_id, t_id, v_id, date.today(),
                            self.description, status))

    Database.insert(Query.ADD_DEVICE, values=(reg_user_id))
    device_id = Database.select(Query.GET_DEVICE_ID, values=(reg_user_id))
    if self.threat != "NULL":
      Database.insert(Query.ADD_INFDEV, values=(device_id[0]['device_id'], t_id))
    return 1

class InfectedModel:

  def __init__(self, threat):
    self.threat = threat

  def infectedDevices(self):
   
    inf_devices = Database.select(Query.GET_USER_THREAT_NAME, values=(self.threat), fetch=True)
    return inf_devices

  def userInfected(self):
    inf_devices = Database.select(Query.GET_USER_THREAT, values=None, fetch=True)
    return inf_devices

class SolutionModel:

  def __init__(self, solution):
    self.solution = solution

  def solutionList(self):
    sol_list = Database.select(Query.GET_SOLUTION_NAME, values=(self.solution), fetch=True)
    return sol_list

  def allSolution(self):
    all_sol_list = Database.select(Query.GET_ALL_SOLUTION, values=(self.solution), fetch=True)
    return all_sol_list

class ClosedReportModel:

  def closedReports():
    closed_reports = Database.select(Query.GET_CLOSE_REPORT, values=None, fetch=True)
    return closed_reports

class ReportDescModel:

  def lessDesc():
    less_desc = Database.select(Query.GET_LESS_DESC, values=None, fetch=True)
    return less_desc

class ReportUpdateModel:

  def __init__(self, report, target, modification):
    self.report = report
    self.target = target
    self.modification = modification

  def updateReport(self):
    if self.target.lower() == "title":
      report_id = Database.select(Query.GET_REPORT_ID, values=(self.report))
      if not report_id:
        return 3
        
      Database.update(Query.UPDATE_REPORTS_TITLE,
                      values=(self.modification, report_id[0]['report_id']))
      return 1

    if self.target.lower() == "threat":
      report_id = Database.select(Query.GET_REPORT_ID, values=(self.report))
      if not report_id:
        return 3

      if self.modification.lower() == "null":
        Database.update(Query.UPDATE_REPORTS_THREAT, values=(None, report_id[0]['report_id']))
        return 1

      threat_id = Database.select(Query.GET_THREAT_ID, values=(self.modification))
      if not threat_id:
        return 4
      Database.update(Query.UPDATE_REPORTS_THREAT,
                      values=(threat_id[0]['threat_id'],
                              report_id[0]['report_id']))
      return 1

    if self.target.lower() == "vulnerability":
      report_id = Database.select(Query.GET_REPORT_ID, values=(self.report))
      if not report_id:
        return 3

      if self.modification.lower() == "null":
        Database.update(Query.UPDATE_REPORTS_VUL, values=(None, report_id[0]['report_id']))
        return 1

      vulnerabilty_id = Database.select(Query.GET_VUL_ID, values=(self.modification))
      if not vulnerabilty_id:
        return 4
      Database.update(Query.UPDATE_REPORTS_VUL,
                      values=(vulnerabilty_id[0]['vulnerabilty_id'],
                              report_id[0]['report_id']))
      return 1

    if self.target.lower() == "description":
      report_id = Database.select(Query.GET_REPORT_ID, values=(self.report))
      if not report_id:
        return 3

      if self.modification.lower() == "null":
        Database.update(Query.UPDATE_REPORTS_DESC, values=(None, report_id[0]['report_id']))
        return 1

      Database.update(Query.UPDATE_REPORTS_DESC,
                      values=(self.modification, report_id[0]['report_id']))
      return 1

class BanUserModel:
  def __init__(self, name):
    self.name = name

  def banUser(self):
    user_id = Database.select(Query.GET_USER_ID, values=(self.name))
    if not user_id:
      return 2
      
    accounts_id = Database.select(Query.GET_ACCOUNT_ID, values=(self.name))
    if not accounts_id:
      return 3

    Database.delete(Query.DELETE_USER, values=(user_id[0]['user_id']))
    Database.delete(Query.DELETE_ACCOUNTS, values=(accounts_id[0]['accounts_id']))
    return 1

class SolutionUpdateModel:
  def __init__(self, target, name, modification):
    self.target = target
    self.name = name
    self.modification = modification

  def updateSolution(self):
    if self.target.lower() == "name":
      solution_id = Database.select(Query.GET_SOLUTION_ID, values=(self.name))
      if not solution_id:
        return 2
      Database.update(Query.UPDATE_SOLUTION_NAME,
                      values=(self.modification, solution_id[0]['solution_id']))
      return 1

    if self.target.lower() == "solution":
      solution_id = Database.select(Query.GET_SOLUTION_ID, values=(self.name))
      if not solution_id:
        return 2

      if self.modification.lower() == "null":
        Database.update(Query.UPDATE_SOLUTION_SOLUTION, values=(None, solution_id[0]['solution_id']))
        return 1

      Database.update(Query.UPDATE_SOLUTION_SOLUTION, values=(self.modification, solution_id[0]['solution_id']))
      return 1

class ReportDeleteModel:
  def __init__(self, name):
    self.name = name

  def deleteReport(self):
    report_id = Database.select(Query.GET_REPORT_ID, values=(self.name))
    if not report_id:
      return 2

    Database.delete(Query.DELETE_REPORT, values=(report_id[0]['report_id']))
    return 1
class SolutionDeleteModel:
  def __init__(self, solution):
    self.solution = solution

  def deleteSolution(self):
    solution_id = Database.select(Query.GET_SOLUTION_ID, values=(self.solution))
    if not solution_id:
      return 2
    Database.delete(Query.DELETE_SOLUTION, values=(solution_id[0]['solution_id']))

    solution_id_sec = Database.select(Query.GET_SOLUTION_BU, values=(self.solution))
    if not solution_id_sec:
      return 3
    solution_id_sec_list = Database.select(Query.GET_SOLUTION_BU_ID, values=(solution_id_sec[0]['solution_id']))
    return solution_id_sec_list

class ThreatModel:
  def __init__(self, name, level):
    self.name = name
    self.level = level
  def createThreat(self):
    severity_id = Database.select(Query.GET_SEVERITY_LEVEL, values=(self.level))
    if not severity_id:
      return 2

    Database.insert(Query.ADD_THREAT, values=(self.name, 1 , severity_id[0]['severity_id']))

    if self.level.lower() == "high" or self.level.lower() == "critical":
      threat_id = Database.select(Query.GET_THREAT_ID, values=(self.name))
      if not threat_id:
        return 3
      val = Database.select(Query.GET_NAME_TITLE_ALERT, values = (threat_id[0]['threat_id']))
      return val
    else:
      return 1

class ForumModel:
  def __init__(self, title, description, email):
    self.title = title
    self.description = description
    self.email = email

  def createForum(self):
    user_id = Database.select(Query.GET_USER_ID, values=(self.email))
    if not user_id:
      return 2

    Database().get_response(Query.CALL_PROCEDURE, values=(self.title, self.description, user_id[0]['user_id']))
    return 1

class EmployeeModel:
  def __init__(self, company):
    self.company = company

  def getNumEmp(self):
    company_id = Database.select(Query.GET_COMPANY_ID, values=(self.company))
    if not company_id:
      return -1
    comp_id = company_id[0]['company_id']
    num_emp = Database.select(Query.GET_EMPLOYEE_COUNT, values=(comp_id))
    return num_emp[0][f'GetEmployeeCount({comp_id})']

class ReportCountModel:
  def __init__(self, email, date):
    self.email = email
    self.date = date

  def getReportCount(self):
    user_id = Database.select(Query.GET_USER_ID, values=(self.email))
    if not user_id:
      return -1
    use_id = user_id[0]['user_id']
    num_reports = Database.select(Query.GET_USER_REPORTS_COUNT_FROM_DATE, values=(use_id, self.date))
    return num_reports[0][f'GetUserReportsCountFromDate({use_id}, \'{self.date}\')']