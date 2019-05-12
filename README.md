# sniffnlog
Sniffer using tcpdump but can log a large amount of packets. By default, packets are logged in /sniff/YEAR/MONTH/DAY/. Inside this, the script will create folder for each protocol you chosed. The magic of this, sniffnlog will start multiple instance of tcpdump inside different screen session so you can have completely different configuration of tcpdump per protocol.

Setup
--
Do it as root.
```
cd /root
git clone https://github.com/JackScripter/sniffnlog.git
chmod 700 sniffnlog/*
crontab -e
```
Add the following line:
```
0 0 * * * bash /root/sniffnlog/cronme.sh
```

Configuration
--
If you look inside sniffnlog.sh, you can edit ROTATE and BUFFER values.

ROTATE: Create a new pcap file after X second. It's 600 (10 min) by default. I suggest you to adapt this value to your needs.

BUFFER: Create a new pcap file when the current file reach X size. It's 100Mb by default. If it reach the limit before ROTATE, it will create a new file.

DO NOT delete the file /tmp/sniffnlog_protocol_enabled. If you remove it, the script will exit on next day.

Usage
--
./sniffnlog.sh [interface] [protocols]

Protocols must be seperated by comma. Example:
```
./sniffnlog.sh eth0 l2tp,snmp,telnet,esp
```
This will create 4 screen sessions, named by protocol.
