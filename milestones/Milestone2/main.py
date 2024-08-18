"""
The code below is just representative of the implementation of a Bot. 
However, this code was not meant to be compiled as it. It is the responsability 
of all the students to modifify this code such that it can fit the 
requirements for this assignments.
"""

import discord
import os
import re
import datetime
from database import Database
from discord.ext import commands
from models import *
from datetime import datetime

TOKEN = os.environ["DISCORD_TOKEN"]

intents = discord.Intents.all()

bot = commands.Bot(command_prefix='!', intents=discord.Intents.all())


@bot.event
async def on_ready():
  print(f'{bot.user} has connected to Discord!')
  Database.connect()


@bot.command(
    name="test",
    description="write your database business requirement for this command here"
)
async def _test(ctx, *args):
  testModel = TestModel(ctx, *args)
  response = testModel.response()
  await ctx.send(response)


# TODO: complete the following tasks:
#       (1) Replace the commands' names with your own commands
#       (2) Write the description of your business requirement in the description parameter
#       (3) Implement your commands' methods.


@bot.command(
    name="makeaccount",
    description=
    "Members of the server can make accounts and become a user of the system. Based on the roles given to them in the discord server, they are able to choose their roles in the system (Registered User, Employee, Administrator)."
)
async def _makeaccount(ctx, *args):
  expected_args_count = 6

  if len(args) < expected_args_count:
    await ctx.send(
        "Please provide all the required arguments for account creation.")
    await ctx.send(
        "!makeaccount <name> <email> <dob> <user_type> <alias> <password>")
    return

  if not re.match(r"[^@]+@[^@]+\.[^@]+", args[1]):
    await ctx.send(
        "Invalid email format. Please provide a valid email address.")
    return

  try:
    datetime.strptime(args[2], "%Y-%m-%d")
  except ValueError:
    await ctx.send(
        "Incorrect date format for Date of Birth. Please use YYYY-MM-DD.")
    return

  valid_user_types = ["Administrator", "Registered User", "Employee"]
  if args[3] not in valid_user_types:
    await ctx.send(
        "Invalid user type. Please choose from: Administrator, Registered User, Employee."
    )
    return

  accountModel = AccountModel(args[0], args[1], args[2], args[3], args[4],
                              args[5])
  account = accountModel.createAccount()
  if account == 1:
    await ctx.send(f"Account for {args[0]} ({args[1]}) created successfully!")
  else:
    await ctx.send("Account Creation Failed!")


@bot.command(
    name="addreport",
    description=
    "Users shall be able to add reports to the system. They can add the information of the report (title, threat, vulnerability, description, the device they are using). Additionally, they can optionally add the discovery method they used."
)
async def _addreport(ctx, *args):
  expected_args_count = 5

  if len(args) < expected_args_count:
    await ctx.send(
        "Please provide all the required arguments for adding a report.")
    await ctx.send(
        "!addreport <title> <email> <threat> <vulnerability> <description>")
    return
  if not re.match(r"[^@]+@[^@]+\.[^@]+", args[1]):
    await ctx.send(
        "Invalid email format. Please provide a valid email address.")
    return

  if args[2] == "NULL" and args[3] == "NULL":
    await ctx.send("Please provide at least one Threat of vulnerability.")
    return
  reportModel = ReportModel(args[0], args[1], args[2], args[3], args[4])
  report = reportModel.addReport()

  if report == 4:
    await ctx.send("Report Creation Failed: Vulnerability does not exist")
  elif report == 3:
    await ctx.send("Report Creation Failed: Threat does not exist")
  elif report == 2:
    await ctx.send("Report Creation Failed: Account does not exist")
  elif report == 1:
    await ctx.send(f"Report titled \"{args[0]}\" has been created!")
  else:
    await ctx.send("Report Creation Failed!")


@bot.command(
    name="usersinfected",
    description=
    "Find all the users that has been affected by a threat or vulnerability. Show their account name and the report title with the threat."
)
async def _usersinfected(ctx, *args):
  expected_args_count = 1

  if len(args) < expected_args_count:
    infectedModel = InfectedModel(None)
    infected = infectedModel.userInfected()
  else:
    infectedModel = InfectedModel(args[0])
    infected = infectedModel.infectedDevices()

  if infected:
    # Construct a formatted string with all data
    result_string = "\n".join([
        f"``Name: {row['name']}, Threat: {row['threat_name']}``"
        for row in infected
    ])

    # Send the formatted string in one message
    await ctx.send(f"Infected users:\n{result_string}")
  else:
    await ctx.send("No users found for the specified threat.")


@bot.command(
    name="reportsolved",
    description=
    "Find all the reports that was solved by a solution. Show the title of the report, the threat or vulnerability it contains, and the publisher of the report."
)
async def _reportsolved(ctx, *args):
  expected_args_count = 1

  if len(args) < expected_args_count:
    solutionModel = SolutionModel(None)
    solution = solutionModel.allSolution()
  else:
    solutionModel = SolutionModel(args[0])
    solution = solutionModel.solutionList()

  if solution:
    # Construct a formatted string with all data
    result_string = "\n".join([
        f"``Title: {row['title']}, Threat: {row['threat_name']}, Publisher: {row['name']}``"
        for row in solution
    ])

    # Send the formatted string in one message
    await ctx.send(f"Forums Solved:\n{result_string}")
  else:
    await ctx.send("No threats solved for the specified solution.")


@bot.command(
    name="closedreports",
    description=
    "Find all the closed reports that do not have any solutions. Show the report title, and publisher."
)
async def _closedreports(ctx, *args):
  expected_args_count = 0

  if len(args) > expected_args_count:
    await ctx.send(
        "Please provide all the required arguments for account creation.")
    await ctx.send("!closedreports")
    return

  closed_reports = ClosedReportModel.closedReports()
  if closed_reports:
    # Construct a formatted string with all data
    result_string = "\n".join([
        f"``Title: {row['title']}, Publisher: {row['name']}, Status: {row['status_name']}``"
        for row in closed_reports
    ])

    # Send the formatted string in one message
    await ctx.send(f"Closed Reports with no Solutions:\n{result_string}")
  else:
    await ctx.send("No Reports Found.")


@bot.command(
    name="reportlowdesc",
    description=
    "For each report, find the report with less than 20 characters in the description. Show the title of the report, the description, and the publisher."
)
async def _reportlowdesc(ctx, *args):
  expected_args_count = 0

  if len(args) > expected_args_count:
    await ctx.send(
        "Please provide all the required arguments for account creation.")
    await ctx.send("!reportlowdesc")
    return

  low_desc = ReportDescModel.lessDesc()
  if low_desc:
    # Construct a formatted string with all data
    result_string = "\n".join([
        f"``Title: {row['title']}, Publisher: {row['name']}, Description: {row['description']}``"
        for row in low_desc
    ])

    # Send the formatted string in one message
    await ctx.send(f"Reports with less than 20 characters:\n{result_string}")
  else:
    await ctx.send("No Reports Found.")


@bot.command(
    name="reportmodify",
    description=
    "Users shall be able to modify reports that they have submitted. They can only modify the title, threat, vulnerability, or description."
)
async def _reportmodify(ctx, *args):
  expected_args_count = 3
  if len(args) < expected_args_count:
    await ctx.send(
        "Please provide all the required arguments for adding a report.")
    await ctx.send("!reportmodify <report> <target> <modification> ")
    return
  valid_targets = ["title", "threat", "vulnerability", "description"]
  if args[1].lower() not in valid_targets:
    await ctx.send(
        "Invalid target type. Please choose from: Title, Threat, Vulnerability, Description."
    )
    return
  reportUpdateModel = ReportUpdateModel(args[0], args[1], args[2])
  report = reportUpdateModel.updateReport()

  if report == 4:
    await ctx.send("Report Update Failed: Cannot Find Threat/Vulnerability")
  elif report == 3:
    await ctx.send("Report Update Failed: Threat/Vulnerability does not exist")
  elif report == 2:
    await ctx.send("Report Creation Failed: Account does not exist")
  elif report == 1:
    await ctx.send(f"Report titled \"{args[0]}\" has been updated!")
  else:
    await ctx.send("Report Creation Failed!")


@bot.command(
    name="reportdelete",
    description=
    "Users shall be able to delete reports they have submitted, but not the threat or vulnerability they included."
)
async def _reportdelete(ctx, *args):
  expected_args_count = 1
  if len(args) < expected_args_count:
    await ctx.send(
        "Please provide all the required arguments for deleting a report.")
    await ctx.send("!reportdelete <report>")
    return
  reportDeleteModel = ReportDeleteModel(args[0])
  report = reportDeleteModel.deleteReport()

  if report == 2:
    await ctx.send("Report Deletion Failed: Forum does not exist")
  elif report == 1:
    await ctx.send(f"Report titled \"{args[0]}\" has been deleted!")
  else:
    await ctx.send("Report Deletion Failed!")


@bot.command(
    name="banuser",
    description=
    " Administrators can ban other users for misconduct or any other malicious reasons. When a user is banned, their account will be deleted first then be banned on the server. "
)
async def _banuser(ctx, *args):
  expected_args_count = 1
  if len(args) < expected_args_count:
    await ctx.send(
        "Please provide all the required arguments for banning a user.")
    await ctx.send("!banuser <name>")
    return

  if not re.match(r"[^@]+@[^@]+\.[^@]+", args[0]):
    await ctx.send(
        "Invalid email format. Please provide a valid email address.")
    return
  banUserModel = BanUserModel(args[0])
  ban = banUserModel.banUser()

  if ban == 3:
    await ctx.send("User Ban Failed: Account does not exist.")
  elif ban == 2:
    await ctx.send("User Ban Failed: User does not exist.")
  elif ban == 1:
    await ctx.send(f"User \"{args[0]}\" has been banned!")
  else:
    await ctx.send("User Ban Failed!")


@bot.command(
    name="solutionmodify",
    description=
    "Users can modify the solutions of the threats or vulnerabilities.")
async def _solutionmodify(ctx, *args):
  expected_args_count = 3
  if len(args) < expected_args_count:
    await ctx.send(
        "Please provide all the required arguments for adding a report.")
    await ctx.send("!solutionmodify <target> <name> <modification>")
    return
  valid_targets = ["solution", "name"]
  if args[0].lower() not in valid_targets:
    await ctx.send(
        "Invalid target type. Please choose from: Solution, or Name.")
    return
  solutionUpdateModel = SolutionUpdateModel(args[0], args[1], args[2])
  solution = solutionUpdateModel.updateSolution()

  if solution == 2:
    await ctx.send("Solution Update Failed: Solution does not exist")
  elif solution == 1:
    await ctx.send(f"Solution titled \"{args[1]}\" has been updated!")
  else:
    await ctx.send("Solution Update Failed!")


@bot.command(
    name="solutiondelete",
    description=
    "Create a trigger so when a solution is deleted, solution's information are backed up for future reference."
)
async def _solutiondelete(ctx, *args):
  expected_args_count = 1
  if len(args) < expected_args_count:
    await ctx.send("Please provide all the required arguments.")
    await ctx.send("!solutiondelete <solution>")
    return
  solutionDeleteModel = SolutionDeleteModel(args[0])
  solution = solutionDeleteModel.deleteSolution()

  if solution == 3:
    await ctx.send("Solution Delete Failed: Trigger Failed.")
  elif solution == 2:
    await ctx.send("Solution Delete Failed: Solution does not exist")
  else:
    await ctx.send(f"Solution \"{args[0]}\" has been deleted!")
    result_string = "\n".join([
        f"``Solution Name: {row['solution_name']}, Solution Description: {row['solution']}``"
        for row in solution
    ])

    await ctx.send(f"Backup Success:\n{result_string}")


@bot.command(
    name="addThreat",
    description=
    "Create a trigger so when a new threat is added, an alert will be added if the severity level of the threat severity level is High or Critical."
)
async def _addThreat(ctx, *args):
  expected_args_count = 2
  if len(args) < expected_args_count:
    await ctx.send("Please provide all the required arguments.")
    await ctx.send("!addThreat <threat name> <severity level>")
    return
  valid_targets = ["low", "medium", "high", "critical"]
  if args[1].lower() not in valid_targets:
    await ctx.send(
        "Invalid target type. Please choose from: Low, Medium, High, Critical."
    )
    return
  threatModel = ThreatModel(args[0], args[1])
  threat = threatModel.createThreat()

  if threat == 3:
    await ctx.send("Threat Creation Failed: Threat does not exist.")
  elif threat == 2:
    await ctx.send("Threat Creation Failed: Level does not exist")
  elif threat == 1:
    await ctx.send(f"Threat \"{args[0]}\" has been added!")
  else:
    await ctx.send(f"Threat \"{args[0]}\" has been added!")
    result_string = "\n".join([
        f"``Alert: {row['threat_name']}, Severity Level: {row['title']}, Publication: {row['alert_date']}``"
        for row in threat
    ])
    await ctx.send(f"Alert:\n{result_string}")


@bot.command(name="makeforum",
             description="A procedure that makes a forum for the caller.")
async def _makeforum(ctx, *args):
  expected_args_count = 3
  if len(args) < expected_args_count:
    await ctx.send("Please provide all the required arguments.")
    await ctx.send("!makeforum <title> <description> <email>")
    return
  if not re.match(r"[^@]+@[^@]+\.[^@]+", args[2]):
    await ctx.send(
        "Invalid email format. Please provide a valid email address.")
    return
  makeForumModel = ForumModel(args[0], args[1], args[2])
  forum = makeForumModel.createForum()

  if forum == 2:
    await ctx.send("Forum Creation Failed: User does not exist.")
  elif forum == 1:
    await ctx.send(f"Forum \"{args[0]}\" has been created!")
  else:
    await ctx.send("Report Creation Failed!")


@bot.command(
    name="empnum",
    description="A function that returns the number of employees in a company."
)
async def _empnum(ctx, *args):
  expected_args_count = 1
  if len(args) < expected_args_count:
    await ctx.send("Please provide all the required arguments.")
    await ctx.send("!empnum <company>")
    return
  employeeModel = EmployeeModel(args[0])
  empNum = employeeModel.getNumEmp()

  if empNum == -1:
    await ctx.send("Employee Fetch Failed: Company does not exist.")
  else:
    await ctx.send(f"There are {empNum} employees in {args[0]}")


@bot.command(
    name="reportstats",
    description=
    "A function that returns the number of reports a user has submitted from a specific date/s"
)
async def _reportstats(ctx, *args):
  expected_args_count = 2
  if len(args) < expected_args_count:
    await ctx.send("Please provide all the required arguments.")
    await ctx.send("!reportstats <email> <date>")
    return

  try:
    datetime.strptime(args[1], "%Y-%m-%d")
  except ValueError:
    await ctx.send("Incorrect date format for Date. Please use YYYY-MM-DD.")
    return

  if not re.match(r"[^@]+@[^@]+\.[^@]+", args[0]):
    await ctx.send(
        "Invalid email format. Please provide a valid email address.")
    return
  reportCountModel = ReportCountModel(args[0], args[1])
  reportcount = reportCountModel.getReportCount()

  if reportcount == -1:
    await ctx.send("Report Count Failed: User does not exist.")
  else:
    await ctx.send(
        f"There are {reportcount} forums submitted by {args[0]} on {args[1]}")


bot.run(TOKEN)
