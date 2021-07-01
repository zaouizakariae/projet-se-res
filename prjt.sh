#!/bin/bash
sed -e 's/\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\).*$/\1/' projet.log > test.txt
filename='test.txt'
a=0
c=0
declare -A b
while read line; do
       a=$((a+1))
       score=$(curl -G -s https://api.abuseipdb.com/api/v2/check --data-urlencode "ipAddress=$line"  -d maxAgeInDays=90  -d verbose -H "Key: 56348a879ca27fd5912ffcb2e7e86d78cd9d099e7c79f29e2a16e09888d471c1cf1fa23a638c40cb"  -H "Accept: application/json"| jq --raw-output '.data.abuseConfidenceScore')
       n=$(curl -G -s https://api.abuseipdb.com/api/v2/check --data-urlencode "ipAddress=$line"  -d maxAgeInDays=90  -d verbose -H "Key: 56348a879ca27fd5912ffcb2e7e86d78cd9d099e7c79f29e2a16e09888d471c1cf1fa23a638c40cb"  -H "Accept: application/json"| jq --raw-output '.data.countryName')
       if (( !${#b[$n]} )); then
         b[$n]=0;
       fi

echo $n;

 echo $score;
       if [ $score -ge 25 ]; then
          c=$((c+1))
          b[$n]=$((b[$n]+1))

         echo $line >> abuse.txt
          sudo iptables -A INPUT -s $line -j DROP
        fi
done < $filename
for KEY in "${!b[@]}"; do
  # Print the KEY value
  echo $KEY >> rap.txt;
  # Print the VALUE attached to that KEY
  echo "Le pourcentage des adresses IP bloquees est :" $(((b[$KEY]*100)/c)) % >>rap.txt;
done
echo $(((100*c)/a)) % >>rap.txt;
SMTPFROM=seres12001200@gmail.com
SMTPTO=seres12001200@gmail.com
SMTPSERVER=smtp.googlemail.com:587
SMTPUSER=zakariaezaoui
SMTPPASS=zaka1200
SUBJECT="Rapport"
FILE='rap.txt'
sudo sendEmail -f  $SMTPFROM -t $SMTPTO -m "rapport" -u $SUBJECT -s $SMTPSERVER -a $FILE -xu $SMTPUSER -xp $SMTPPASS -o tls=yes
