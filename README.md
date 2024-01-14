# windows-adds-automation

## Description
The goal of this project is to create an automate way to deploy Windows AD DS infrastructure with others services which Microsoft provides to their operating system.
The `utils` directory some scripts if you want to use it to do small tasks like creation of users or groups.
The `data` directory is only to store users, groups, organisation units, etc...

## Tech stack 
- Powershell
- Bash

## Tasks :
- [x] Automate connection to an AD DS ([auto-connect.ps1](https://github.com/Limerio/windows-adds-automation/blob/main/auto-connect.ps1))
- [x] Update the ip address
- [x] Add Active Directory and DHCP Services
- [x] Rename the server
- [x] Deployment of the forest
- [x] Add a scheduled task to start the init script after restart of the server
- [x] Update configuration of the DHCP
  - [x] Add an exclusion range
  - [x] Add a primary zone
  - [x] Add a scope and change the state
  - [x] Add a default option value
- [x] Create organization units
- [x] Create groups
- [x] Create users and assign to there group
- [x] Installation of a web server (Optional)
- [x] Installation of a print services (Optional)
- [x] Remove the init task
- [x] Add a bash script to be able to connect to a network directory 
