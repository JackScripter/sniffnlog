#!/bin/bash
# Wrote by JackScripter
# Last update: May 11 2019 at 19:30

if [[ "$1" =~ "-h" ]]; then
	echo "Usage: ./tcplog.sh [interface] [protocols]"
	echo "Protocols supported:"
	echo -e "- http (80, 8080, 8008)\n- https (443)\n- mysql (3306)\n- postgres (5432)\n- radius (1812, 1813)\n- tacacs (49)\n- smtp (25)\n- smtps (465)\n- pop3 (110, 995)"
	echo -e "- isakmp (500)\n- openvpn (1194)\n- sevpn (5555)\n- ipsec-nat-t (4500)\n- esp\n- ah\n- l2tp (1701)\n- tftp\n- ssh (22)\n- ftp (21)"
	echo -e "- dns (53)\n- icmp\n- syslog (514)\n- ldaps (636)\n- ldap (389)\n- bgp (179)\n- snmp (161, 162)\n- ntp (123)\n- telnet (23)\n- pxe (4011)"
	exit 1
fi

DIR1="/sniff/`date +%Y`/`date +%h`/`date +%d`"
declare -r IFNET="$1"				# Interface to sniff on as first argument.
declare -r PROTOS=`echo "$2" | tr ',' ' '`	# Protocol as second argument seperate by comma. Ex: ssh,http,ftp
declare -r ROTATE=600				# Create new pcap after X second.
declare -r BUFFER=100				# Create new pcap when filesize reach X mb

echo "$PROTOS" > /tmp/sniffnlog_protocol_enabled	# The cron script will create folder with enabled protocol. This prevent creating like 40 folders per day.
SUBDIR=`cat /tmp/sniffnlog_protocol_enabled | tr ',' ' '`

for proto in $PROTOS; do
	if [ ! -d "$DIR1/$proto" ]; then mkdir -p "$DIR1/$proto"; fi
	case "$proto" in
		# Web
		"http") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 80 or port 8080 or port 8008 -C $BUFFER -G $ROTATE;;
                "https") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 443 -C $BUFFER -G $ROTATE;;

		# Database
                "mysql") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 3306 -C $BUFFER -G $ROTATE;;
		"postgres") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 5432 -C $BUFFER -G $ROTATE;;

		# AAA
		"radius") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 1812 or port 1813 -C $BUFFER -G $ROTATE;;
		"tacacs") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 49 -C $BUFFER -G $ROTATE;;

		# Mail
                "smtp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 25 -C $BUFFER -G $ROTATE;;
                "smtps") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 465 -C $BUFFER -G $ROTATE;;
                "pop3") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 110 or port 995 -C $BUFFER -G $ROTATE;;

		# VPN
		"isakmp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 500 -C $BUFFER -G $ROTATE;;
		"openvpn") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 1194 -C $BUFFER -G $ROTATE;;
		"sevpn") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 5555 -C $BUFFER -G $ROTATE;;
		"ipsec-nat-t") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 4500 -C $BUFFER -G $ROTATE;;
		"esp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap esp -C $BUFFER -G $ROTATE;;
		"ah") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap ah -C $BUFFER -G $ROTATE;;
		"l2tp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 1701 -C $BUFFER -G $ROTATE;;

		# Standard
		"tftp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap -T tftp -C $BUFFER -G $ROTATE;;
		"ssh") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 22 -C $BUFFER -G $ROTATE;;
		"ftp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 21 -C $BUFFER -G $ROTATE;;
		"dns") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 53 -C $BUFFER -G $ROTATE;;
		"icmp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap icmp -C $BUFFER -G $ROTATE;;
		"syslog") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 514 -C $BUFFER -G $ROTATE;;
		"ldaps") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 636 -C $BUFFER -G $ROTATE;;
		"ldap") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 389 -C $BUFFER -G $ROTATE;;
		"bgp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 179 -C $BUFFER -G $ROTATE;;
		"snmp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 161 or port 162 -C $BUFFER -G $ROTATE;;
		"ntp") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 123 -C $BUFFER -G $ROTATE;;
		"telnet") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 23 -C $BUFFER -G $ROTATE;;
		"pxe") screen -dmS $proto tcpdump -i $IFNET -w /sniff/%Y/%h/%d/${proto}/%H-%M-%S.pcap port 4011 -C $BUFFER -G $ROTATE;;
	esac
done
