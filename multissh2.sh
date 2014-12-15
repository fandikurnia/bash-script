#!/bin/bash 
# created by Fandi Kurnia 
# Stupid Person 
# Inspired by saka yoga 

#########################################################
### List All hosts
list_hosts()
{
echo "proceed with $FILE"
#exec 0<$FILE 
i=0
while read LINE;  
do 	
   let i++
   hostname=$(awk '{print $1}' <<< "$LINE")
   echo $i  \) $hostname 
done < $FILE 
total=$i
echo "Total" $total "server"
}
#########################################################
###########     FUNCTIONS                          #####
#########################################################

execute_commands() 
{ 
  echo $FILE
  hasil=$(head -n $choice $FILE)
  echo "hasil : $hasil "
  IP=$(awk '{print $2}' <<< "$hasil") 
  echo "IP adalah " $IP
  user=$(awk '{print $3}' <<< "$hasil")
  echo "Masukan Port SSH : " 
  read sshport 
  echo "User adalah " $user 
  echo "ssh -v $user\@$IP" 
  ssh -v -p $sshport $user\@$IP
  
  sleep 2
}
#########################################################
###########     FUNCTIONS                          #####
#########################################################

domain()
{
 list_hosts
 
 while true; do 
   clear
   list_hosts
   echo "Pilih number: " 
   read choice
   echo "Pilihan"  $choice
   echo "Jumlah Server " $total 
   renumber='^[0-9]+$'
   if ! [[ $choice =~ $renumber ]]; then 
  	clear
        list_hosts
	echo "error : $choice not a number, pilih lagi !" >&2; 
   elif [[ $choice -lt 1 ]] ||  [[ $choice -gt $total ]]; then
	clear
	list_hosts
	echo $choice "tidak ada, pilih lagi !" >&2;
   else 
  	execute_commands
   fi 
 done 
}


##########################################
# PROGRAM STARTS HERE 
#########################################

if [ $# -ne 1 ]; then 
   echo "Usage : $0 hostname_file " 
   echo ""
   echo "1. If hostname_file empty, process cancel." 
   exit 
fi 
FILE=$1 

if [ ! -f $FILE ]; then 
   echo "hostname file : $FILE does not exist!" 
   exit 1
fi 

if [ ! -s $FILE ]; then 
   echo "hostname file : $FILE is empty!" 
   exit 1
fi

domain
