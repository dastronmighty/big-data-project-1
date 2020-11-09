# How To Run:

## System Requirements

- macOS: version 10.15.2
- mysql: Ver 8.0.19 for osx10.15 on x86_64 (Homebrew)
- mongo shell: v4.2.3
- mongo git version: 6874650b362138df74be53d366bbefc321ea32d4
- Entry to sql via: `mysql.server start`
- Entry to mongo via: `mongod --dbpath=/Users/user/data/db --fork --syslog`

## Run

if you have all the necessary components you can simply ensure you are in the main directory and do the following:

\$`sudo chmod u+x give_perm.sh`  
\$`sudo ./give_perm.sh`

now the files have permissions to run.  
Then to run the entire project you can:

\$`sudo ./main.sh`

et voila
