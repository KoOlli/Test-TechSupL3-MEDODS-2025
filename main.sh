#!/bin/bash

wget https://raw.githubusercontent.com/GreatMedivack/files/master/list.out

if [[ -z "$1" ]]; then
  ServerName="default"
else
  ServerName="$1"
fi

DateFormate=$(date '+%d_%m_%Y')

Pattern='-[0-9a-z]{8,10}-[0-9a-z]{5}'

# create SERVER_DATE_failed.out
NameFailedFile=""$ServerName"_"$DateFormate"_failed.out"
stringEr=$(grep -e "Error" -e "CrashLoopBackOff" list.out | awk '{print $1}' | sed -E "s/$Pattern$//g")
echo "$stringEr" > "$NameFailedFile"

# create SERVER_DATE_running.out
NameRunningFile=""$ServerName"_"$DateFormate"_running.out"
stringRu=$(grep -e "Running" list.out | awk '{print $1}' | sed -E "s/$Pattern$//g")
echo "$stringRu" > "$NameRunningFile"

# create SERVER_DATE_report.out
NameDateFile=""$ServerName"_"$DateFormate"_report.out"
User=$(whoami)
CountRun=$(wc -l "$NameRunningFile" | awk '{print $1}')
CountFail=$(wc -l "$NameFailedFile" | awk '{print $1}')
echo -e "Количество работающих сервисов: $CountRun\nКоличество сeрвисов с ошибками: $CountFail\nИмя системного пользователя: $User\nДата: $(date '+%d/%m/%y')" > "$NameDateFile"
chmod ugo+r "$NameDateFile"

# archiving files in SERVER_DATE
tar -cf ""$ServerName"_"$DateFormate".tar" "$ServerName"* 
mkdir archives
mv ""$ServerName"_"$DateFormate".tar" archives

# delete all files
rm ""$ServerName"_"$DateFormate""*

# checking archives
tar --test-label -f archives/""$ServerName"_"$DateFormate".tar" && echo "Backup is good!"