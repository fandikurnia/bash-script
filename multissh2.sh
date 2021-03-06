#!/bin/bash 
# created by Fandi Kurnia 
# Stupid Person 
# Inspired by saka yoga 

#########################################################
#############     FUNCTION FOR      #####################
#############     List All hosts    #####################
#########################################################
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
###########     FUNCTIONS  EXECUTE SSH COMMAND      #####
#########################################################

execute_commands() 
{ 
  #privatekey="/Users/fahrezafauzi/fandi-dropbox/bash-script/privateopenssh"
  privatekey="/home/fandikurnia/.ssh/id_rsa"
  echo $FILE
  hasil=$(sed -n "${choice}p" < $FILE)
  echo "hasil : $hasil "
  IP=$(awk '{print $2}' <<< "$hasil") 
  echo "IP adalah " $IP
  PORT=$(awk '{print $3}' <<< "$hasil")
  echo "PORT : " $PORT
  user=$(awk '{print $4}' <<< "$hasil")
  #echo "Masukan Port SSH : " read sshport 
  echo "User adalah " $user 
  
  #echo "ssh -v $user\@$IP \n" 
  ssh -p $PORT -i $privatekey $user\@$IP
  #break 
  echo "Please Wait Process will be new initialized.. Thanks"  
  sleep 2 
}
#########################################################
###########     MAIN FUNCTION HERE                  #####
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
