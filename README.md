# turtlebotBootstrap

## Specify the username
Standard username is turtlebot, this can be changes in the variable USER in the beginning of the script. The user must already exist on the system and it need sudoer rights. 

## Salt master url and finger
To connect to the salt master, you need to specify the master url and the master finger in the minion config. You can find the minion config in the salt folder. 

## install
To install all the required packages and configurations launch ./install.sh as the user you want to  run the application afterwards. Note, you need to enter the password of the user in the beginning to give sudoer right for the installation.. 
