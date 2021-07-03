#!/bin/bash
sed -e 's/\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\).*$/\1/' projet.log > test.txt
filename='test.txt'
a=0
c=0
declare -A b
while read line; do
       a=$((a+1))
       score=$(curl -G -s https://api.abuseipdb.com/api/v2/check --data-urlencode "ipAddress=$line"  -d maxAgeInDays=90  -d verbose -H "Key: 56348a879ca27fd5912ffcb2e7e86d78cd9d099e7c79f29e2a16e09888d471c1cf1fa23a638c40cb"  -H "Accept>
       n=$(curl -G -s https://api.abuseipdb.com/api/v2/check --data-urlencode "ipAddress=$line"  -d maxAgeInDays=90  -d verbose -H "Key: 56348a879ca27fd5912ffcb2e7e86d78cd9d099e7c79f29e2a16e09888d471c1cf1fa23a638c40cb"  -H "Accept: ap>
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
echo "Le pourcentage des @IP bloquees est : "$(((100*c)/a)) % >>rap.txt;

for KEY in "${!b[@]}"; do
  # Print the KEY value
  echo $KEY >> rap.txt;
  echo  $(((b[$KEY]*100)/c)) % >> rap.txt;
done
sendEmail -f seres@gmail.com -t seres@gmail.com -u rapport  -m rap.txt -s smtp.googlemail.com:587 -xu zakariaezaoui -xp psswd -o tls=yes -a rap.txt






