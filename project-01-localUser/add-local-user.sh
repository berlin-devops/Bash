#!/bin/bash

rootID='0';
rootName='root';
userName=$(id -un);

UID_userName="Your UID is ${UID}\nYour username is: ${userName}";

if [[ "${UID}" -eq "${rootID}" ]];
then
    printf "${UID_userName}\nYou're root\n";

    # Creates a user account on local system
    # Runner will be prompted for account name & password

    # Ask for user's name
    # read -p => prompt for stdin => store in var "userName"
    read -p "Enter new user's username: " userName;
    #printf "${userName}";

    # Ask for real name or Ticket number in COMMENT
    read -p "Enter new user's real name: " COMMENT;

    # Ask for password
    read -p "Enter new user's password: " password;

    # Create user
    # Using adduser command
    # adduser [--uid id] [--firstuid id] [--comment comment] 
    # adduser [--allow-all-names] [--allow-bad-names] 
    # "${VAR}" => Allow spaced comments to be stored into a var
    useradd -c "${COMMENT}" -m ${userName};

    # Check whether user is added successfully
    if [[ ${?} -eq 0 ]];
    then
        printf "\nuser account: ${userName}\nreal name: ${COMMENT}\nhas been successfully added...\nProceeding to create password for: ${userName}...";
    elif [[ ${?} -ne 0 ]];
    then
        printf "\nCreation of user: ${userName} has failed...Skipping...\n"
        exit 1;
    fi;

    # Set password for the user
    # CANNOT set password using passwd....
    echo "${userName}:${password}" | sudo chpasswd;
    if [[ ${?} -eq 0 ]];
    then
        printf "\n${userName}'s password has been created successfully...Proceeding to expire ${userName}'s account on first logon...\n"
    else
        printf "\n${userName}'s password could NOT be created...\nMake sure you're root...\n"
        exit 1;
    fi;

    # Force user to change password on 1st logon
    passwd -e ${userName};
    if [[ ${?} -eq 0 ]];
    then
        printf "\n${userName}'s password has been expired by design...${userName} must change password upon first logon\n"
    else
        printf "\n${userName}'s password has NOT been expired by design...\nMake sure you're root running this script\n"
    fi;
    
    # Define exit code == 0 if succeeded
    exit 0;
elif [[ "${UID}" -ne "${rootID}" ]];
then
    printf "${UID_userName}\nYou aren't root\nSkipping execution...\n";
    
    exit 1;
fi;