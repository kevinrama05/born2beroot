cmd=$(uname -a)
echo "#Architecture: $cmd"
cmd=$(lscpu | grep "Socket" | awk '{print $2}')
echo "#CPU physical: $cmd"
cmd=$(lscpu | grep -m 1 "CPU(s):" | awk '{print $2}')
echo "#vCPU: $cmd"
cmd1=$(free -h --si | grep "Mem" | awk '{print $2}' | sed 's/[A-Za-z]//g')
cmd2=$(free -h --si | grep "Mem" | awk '{print $4}' | sed 's/[A-Za-z]//g')
percent=$(echo "scale=2; $cmd2 / $cmd1 * 100" | bc)
gb='Gb'
echo "#Memory Usage: $cmd2/$cmd1$gb ($percent%)"
cmd1=$(df -h --si / | grep "/" | awk '{print $2}' | sed 's/[A-Za-z]//g')
cmd2=$(df -h --si / | grep "/" | awk '{print $3}' | sed 's/[A-Za-z]//g')
cmd3=$(df -h --si / | grep "/" | awk '{print $5}' | sed 's/[A-Za-z]//g')
echo "#Disk Usage: $cmd2/$cmd1$gb ($cmd3)"
cmd=$(top -bn1 | grep "Cpu(s)" | awk '{ print $8 }')
percent=$(echo "scale=2; 100 - $cmd" | bc)
echo "#CPU load: $percent%"
echo "#Last boot: $(uptime -s)"
echo -n "#LVM use: "
cmd=$(lsblk | grep -i "lvm")
if [ "$cmd" == "" ]; then
	echo "no"
else
	echo "yes"
fi
cmd=$(ss -t state established | tail -n +2 | wc -l)
echo "#Connections TCP: $cmd ESTABLISHED"
cmd1=$(w | wc -l)
cmd=$(echo "schale = 2; $cmd1 - 2")
echo "#User log: $cmd"
cmd1=$(ip addr | grep enp | grep inet | awk '{print $2}' | cut -d/ -f1)
cmd2=$(ip addr | grep enp -A 1 | grep ether | awk '{print $2}')
echo "#Network: IP $cmd1 ($cmd2)"
cmd=$(grep "COMMAND=" /var/log/sudo/sudo.log | wc -l)
echo "#Sudo: $cmd cmd"
