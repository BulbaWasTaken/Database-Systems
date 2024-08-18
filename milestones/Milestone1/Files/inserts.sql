   -- Script name: inserts.sql
   -- Author:      Karl Xavier Layco
   -- Purpose:     Insert sample data to test the integrity of this database system
   
   -- the database used to insert the data into.
   USE CyberThreatManagementDB; 
   
   -- Company table inserts
   INSERT INTO company (name, email, collab) VALUES ('Test1Inc', 'company1@test.com', NULL);
   INSERT INTO company (name, email, collab) VALUES ('Test2Inc', 'company2@test.com', 2);
   INSERT INTO company (name, email, collab) VALUES ('Test3Inc', 'company3@test.com', NULL);
   UPDATE company SET collab = 1 where company_id = 2;
   UPDATE company SET collab = 2 where company_id = 1;
   
   -- Accounts Table Inserts
   INSERT INTO accounts (username, password) VALUES ('usernametest1', 'passwordtest1');
   INSERT INTO accounts (username, password) VALUES ('usernametest2', 'passwordtest2');
   INSERT INTO accounts (username, password) VALUES ('usernametest3', 'passwordtest3');
   INSERT INTO accounts (username, password) VALUES ('usernametest4', 'passwordtest4');
   INSERT INTO accounts (username, password) VALUES ('usernametest5', 'passwordtest5');
   INSERT INTO accounts (username, password) VALUES ('usernametest6', 'passwordtest6');
   INSERT INTO accounts (username, password) VALUES ('usernametest7', 'passwordtest7');
   INSERT INTO accounts (username, password) VALUES ('usernametest8', 'passwordtest8');
   INSERT INTO accounts (username, password) VALUES ('usernametest9', 'passwordtest9');
   
   -- User table inserts
   INSERT INTO user (name, email, dob, user_type, accounts_id) VALUES ('Karl', 'klayco@sfsu.edu', '2000-12-26', 'Administrator', 1);
   INSERT INTO user (name, email, dob, user_type, accounts_id) VALUES ('John', 'jdoe@sfsu.edu', '2000-08-14', 'Registered User', 2);
   INSERT INTO user (name, email, dob, user_type, accounts_id) VALUES ('Meg', 'mgriffin@sfsu.edu', '2001-04-29', 'Employee', 3);
   INSERT INTO user (name, email, dob, user_type, accounts_id) VALUES ('Mike', 'mdean@sfsu.edu', '2002-10-22', 'Administrator', 4);
   INSERT INTO user (name, email, dob, user_type, accounts_id) VALUES ('Joy', 'jrain@sfsu.edu', '1999-06-19', 'Registered User', 5);
   INSERT INTO user (name, email, dob, user_type, accounts_id) VALUES ('Roy', 'rgonzales@sfsu.edu', '2000-11-03', 'Employee', 6);
   INSERT INTO user (name, email, dob, user_type, accounts_id) VALUES ('Stacey', 'sjones@sfsu.edu', '2001-03-13', 'Administrator', 7);
   INSERT INTO user (name, email, dob, user_type, accounts_id) VALUES ('Hadey', 'hsmith@sfsu.edu', '2000-04-25', 'Registered User', 8);
   INSERT INTO user (name, email, dob, user_type, accounts_id) VALUES ('Lance', 'lchu@sfsu.edu', '2001-02-06', 'Employee', 9);
   
   -- Administrator table inserts
   INSERT INTO administrators (admin_password, admin_user_id) VALUES ('adminPassTest1', 1);
   INSERT INTO administrators (admin_password, admin_user_id) VALUES ('adminPassTest2', 4);
   INSERT INTO administrators (admin_password, admin_user_id) VALUES ('adminPassTest3', 7);
   
   -- Registered Users table inserts
   INSERT INTO registeredusers(registered_user_id) VALUES (2),(5),(8);
   
   -- Teams table insert
   INSERT INTO teams (team_name, admin_managed) VALUES ('Lakers', 1), ('Kings',3), ('Warriors', 2);
   
   -- Employees table inserts
   INSERT INTO employees (user_id, company, team_id) VALUES (3, 3, 1);
   INSERT INTO employees (user_id, company, team_id) VALUES (6, 1, 1);
   INSERT INTO employees (user_id, company, team_id) VALUES (9, 2, 3);
   
   -- Admin Manage Users table inserts
   INSERT INTO adminmanageusers (admin_id, employee_id, registered_user_id) VALUES (1, 1, 1);
   INSERT INTO adminmanageusers (admin_id, employee_id, registered_user_id) VALUES (2, 1, 1);
   INSERT INTO adminmanageusers (admin_id, employee_id, registered_user_id) VALUES (3, 1, 1);
   
   -- Forums table Inserts
   INSERT INTO forums (forum_title, forum_description, publisher) VALUES ('TITLE Test 1', 'First Test for forums', 2);
   INSERT INTO forums (forum_title, forum_description, publisher) VALUES ('TITLE Test 2', 'Second Test for forums', 1);
   INSERT INTO forums (forum_title, forum_description, publisher) VALUES ('TITLE Test 3', 'Third Test for forums', 2);
   INSERT INTO forums (forum_title, forum_description, publisher) VALUES ('TITLE Test 4', 'Fourth Test for forums', 9);
   INSERT INTO forums (forum_title, forum_description, publisher) VALUES ('TITLE Test 5', 'Fifth Test for forums', 1);
   INSERT INTO forums (forum_title, forum_description, publisher) VALUES ('TITLE Test 6', 'Sixth Test for forums', 9);
   
   -- Admin Forum Manage table inserts
   INSERT INTO adminsforummanage (admin_id, forum_id) VALUES (2, 1); 
   INSERT INTO adminsforummanage (admin_id, forum_id) VALUES (3, 2);
   INSERT INTO adminsforummanage (admin_id, forum_id) VALUES (1, 3);
   INSERT INTO adminsforummanage (admin_id, forum_id) VALUES (2, 4); 
   INSERT INTO adminsforummanage (admin_id, forum_id) VALUES (1, 4); 
   
   -- Status table inserts
   INSERT INTO status (status_name, description) VALUES ('Open', 'Status is Open');
   INSERT INTO status (status_name, description) VALUES ('Closed', 'Status is Closd');
   INSERT INTO status (status_name, description) VALUES ('Mitigated', 'Status is Mitigated');
   INSERT INTO status (status_name, description) VALUES ('Under Investigation', 'Status is Under Investigation');
   
   -- Severity Level table inserts
   INSERT INTO severitylevel (title, description) VALUES ('Low', 'Level is Low');
   INSERT INTO severitylevel (title, description) VALUES ('Medium', 'Level is Medium');
   INSERT INTO severitylevel (title, description) VALUES ('High', 'Level is High');
   INSERT INTO severitylevel (title, description) VALUES ('Critical', 'Level is Critical');
   
   -- Threats table inserts
   INSERT INTO threats (threat_name, status, severity_level) VALUES ('Email Scam', 4, 2);
   INSERT INTO threats (threat_name, status, severity_level) VALUES ('DDoS', 3, 1);
   INSERT INTO threats (threat_name, status, severity_level) VALUES ('Data Breach', 2, 4);
   INSERT INTO threats (threat_name, status, severity_level) VALUES ('SQL Injection', 1, 3);
   
   -- Vulnerabilities table inserts
   INSERT INTO vulnerabilities (vulnerability_name, descriptions, date, severity_level, status) VALUES ("Vul NAME 1", "Test 1 for Vul", '2023-10-23', 1, 1);
   INSERT INTO vulnerabilities (vulnerability_name, descriptions, date, severity_level, status) VALUES ("Vul NAME 2", "Test 2 for Vul", '2023-10-23', 2, 2);
   INSERT INTO vulnerabilities (vulnerability_name, descriptions, date, severity_level, status) VALUES ("Vul NAME 3", "Test 3 for Vul", '2023-10-23', 3, 3);
   INSERT INTO vulnerabilities (vulnerability_name, descriptions, date, severity_level, status) VALUES ("Vul NAME 4", "Test 4 for Vul", '2023-10-23', 4, 4);
   
   
   -- Alert Table inserts
   INSERT INTO alert (alert_date, threat, vulnerability) VALUES ('2023-10-23', 1, 2);
   INSERT INTO alert (alert_date, threat, vulnerability) VALUES ('2023-10-23', 4, 1);
   INSERT INTO alert (alert_date, threat, vulnerability) VALUES ('2023-10-23', 3, NULL);
   INSERT INTO alert (alert_date, threat, vulnerability) VALUES ('2023-10-23', NULL, 3);
   
   -- Alert View table inserts
   INSERT INTO alertview (alert_id, employee_id, administrator_id) VALUES (1, 2, NULL);
   INSERT INTO alertview (alert_id, employee_id, administrator_id) VALUES (2, NULL, 1);
   INSERT INTO alertview (alert_id, employee_id, administrator_id) VALUES (3, 3, 3);
   INSERT INTO alertview (alert_id, employee_id, administrator_id) VALUES (3, 2, NULL);
   INSERT INTO alertview (alert_id, employee_id, administrator_id) VALUES (4, 1, 2);
   
   -- Attack Vector table inserts
   INSERT INTO attackvectors (description) VALUES ('1st Attack Vector'),('2nd Attack Vector'), ('3rd Attack Vector');
   
   -- Malicious Actor table inserts
   INSERT INTO maliciousactors (alias, ma_description) VALUE ('Jack Sparrow', '1st Attacker'); 
   INSERT INTO maliciousactors (alias, ma_description) VALUE ('Mickey', '2nd Attacker');
   INSERT INTO maliciousactors (alias, ma_description) VALUE ('Pooh', '3rd Attacker');
   
   -- Attackers List table inserts
   INSERT INTO attackerslist (vector_id, actor_id) VALUE (1, 3), (2, 2), (3,1);
   
   -- Threat Campaign table inserts
   INSERT INTO threatscampaigns (campaign_name, description) VALUES ('Voyage', '1st Campaign');
   INSERT INTO threatscampaigns (campaign_name, description) VALUES ('Trojan', '2nd Campaign');
   INSERT INTO threatscampaigns (campaign_name, description) VALUES ('Odyssey', '3rd Campaign');
   
   -- Campaign Attack table inserts
   INSERT INTO campaignattack (vector_id, campaign_id) VALUES (3, 2), (1, 3), (2,1);
   
   -- Reports table inserts 
   INSERT INTO reports (title, submitted_by, threat, vulnerability, publication_date, description, status) VALUES ('1st Forum', 1, 2, NULL, '2023-10-23', '1st Forum Inserted', 1);
   INSERT INTO reports (title, submitted_by, threat, vulnerability, publication_date, description, status) VALUES ('2nd Forum', 2, 3, 1, '2023-10-23', '2nd Forum Inserted', 2);
   INSERT INTO reports (title, submitted_by, threat, vulnerability, publication_date, description, status) VALUES ('3rd Forum', 3, NULL, 2, '2023-10-23', '3rd Forum Inserted', 4);
   
   -- Campaign Reports table inserts
   INSERT INTO campaignreports (campaign_id, report_id) VALUES (1, 1);
   INSERT INTO campaignreports (campaign_id, report_id) VALUES (2, 3);
   INSERT INTO campaignreports (campaign_id, report_id) VALUES (3, 2);
   
   -- Comments table inserts
   INSERT INTO comments (comment, posted_forum, publisher) VALUES ('Comment Test1', 1, 1);
   INSERT INTO comments (comment, posted_forum, publisher) VALUES ('Comment Test2', 1, 2);
   INSERT INTO comments (comment, posted_forum, publisher) VALUES ('Comment Tes3', 1, 3);
   INSERT INTO comments (comment, posted_forum, publisher) VALUES ('Comment Tes4', 2, 1);
   
   -- CT Threats table inserts
   INSERT INTO ctthreats (campaign_id, threat_id) VALUES (1, 3), (2, 2), (3,1);
   
   -- Devices table inserts
   INSERT INTO devices(user_log) VALUES (1), (2), (3);
   
   -- Device Attacked table inserts
   INSERT INTO deviceattacked (actor_id, device_id) VALUES (1, 1), (3, 2), (2, 3);
   
   -- Discovery Method table inserts
   INSERT INTO discoverymethod (description, title) VALUES ('1st DM test', 'Test 1');
   INSERT INTO discoverymethod (description, title) VALUES ('2nd DM test', 'Test 2');
   INSERT INTO discoverymethod (description, title) VALUES ('3rd DM test', 'Test 3');
   
   -- Discover List table inserts
   INSERT INTO discoverlist (discovery_id, threat_id, vulnerability_id) VALUES (1, 1, NULL), (2, NULL, 2), (3, 3, 3);
   
   -- Discovery Method Report List tables inserts
   INSERT INTO dmreportlist (report_id, discovery_id) VALUES (1, 1), (2, 3), (3, 2);
   
   -- Solutions table inserts
   INSERT INTO solutions (solution_name, solution) VALUES ('Solution 1', '1st Solution'), ('Solution 2', '2nd Solution'), ('Solution 3', '3rd Solution');
   
   -- Employee Solutions tables inserts
   INSERT INTO employeesolutions (employee_id, solution_id) VALUES (1, 1), (1, 2), (2, 3);
   
   -- Forum Report table insert
   INSERT INTO forumreport (forums_id, report_id) VALUES (1, 1), (2, 2), (3, 3);
   
   -- Forum Solutions table insert
   INSERT INTO forumsolutions (forum_id, solution_id) VALUES (1, 2), (2, 3), (3, 1);
   
   -- Services table insert
   INSERT INTO services (service_name) VALUES ('Service 1'), ('Service 2'), ('Service 3');
   
   -- Forum Services table insert
   INSERT INTO forumsservices (forum_id, service_id) VALUES (1, 2), (2, 1), (3, 3);
   
   -- Forum User View table insert
   INSERT INTO forumuserview (forum_id, user_id) VALUES (1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3);
   
   -- Harm User table insert
   INSERT INTO harmuser (user_id, threat_id, vulnerability_id) VALUES (1, 2, NULL), (2, 1, 3), (3, NULL, 2);
   
   -- Infected Devices table insert
   INSERT INTO infecteddevices (device_id, threat_id) VALUES (1, 3), (1, 2), (3, 1);
   
   -- Malicious Attacker table insert 
   INSERT INTO malattacker (report_id, mactor_id) VALUES (1, 3), (2, 2), (3, 1);
   
   -- Patter table insert
   INSERT INTO patterns (threat_pattern, vulnerability_pattern) VALUES ('1st Threat Pattern', NULL);
   INSERT INTO patterns (threat_pattern, vulnerability_pattern) VALUES (NULL, '1st Vulnerability Pattern');
   INSERT INTO patterns (threat_pattern, vulnerability_pattern) VALUES ('2nd Threat Pattern', '2nd Vulnerability Pattern');
   
   -- Pattern List table insert
   INSERT INTO patternlist  (pattern_id, threat_id, vulnerability_id) VALUES (1, 1, NULL), (2, NULL, 3), (3, 2, 2);
   
   -- Private Forum table insert
   INSERT INTO privateforum (forum_id) VALUES (1), (3), (5);
   
   -- Public Forum table insert
   INSERT INTO publicforum (forum_id) VALUES (2), (4), (6);
   
   -- Profiles table insert
   INSERT INTO profiles (account_id, alias) VALUES (1, 'Spongebob'), (2, 'Patrick'), (3, 'Sandy');
   
   -- Report Access table insert
   INSERT INTO reportaccess (report_id, admin_id, employee_id) VALUES (1, 1, NULL), (2, NULL, 1), (3, 3, 3);
   
   -- Services Tested table insert
   INSERT INTO servicestested (service_id, employee_id) VALUES (1, 1), (2, 2), (3, 3);
   
   -- Solved table insert
   INSERT INTO solved (solution_id, vulnerability_id, threat_id) VALUES (1, NULL, 3), (2, 1, NULL), (3, 2, 2);
   
   
   -- Team Analyze Campaign table insert
   INSERT INTO teamanalyzecampaign (campaign_id, teams_id) VALUES (1, 3), (2, 2), (3, 1);
   
   -- Threats/Vulnerabilities Analysis table insert
   INSERT INTO tv_analysis (admin_id, employee_id, threat_id, vulnerability_id) VALUES (1, NULL, 3, NULL), (NULL, 1, 2, 2), (2, 2, 1, 1);
   
   -- Threats/Vulnerabilities Report table insert
   INSERT INTO tvreportlist (report_id, threat_id, vulnerability_id) VALUES (1, 1, 1), (2, NULL, 2), (3, 3, NULL);
   
   -- User Comments table insert
   INSERT INTO usercomments (user_registered_id, comment_id) VALUES (1, 1), (2, 2), (3, 3), (1, 4);
   
   -- User Service Used table insert
   INSERT INTO userserviceused (user_id, service_id) VALUES (1, 1), (1, 2), (2, 1), (2, 3), (3, 2), (3, 3);