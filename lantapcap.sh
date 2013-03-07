#!/bin/bash
#
# lantapcap.sh 
# By JP Dunning
# www.foundstone.com
#

NET0=eth0
NET1=eth1
CAPNAME=name
CONTINUE=go

printf "\nUse LanTapCap for capturing network traffic with a LAN Tap\n"
printf "\nInterfaces:\n\n"
ifconfig -a | grep "Link encap:" | awk '{print $1}'

printf "\nSpecify interfaces for sniffing."
printf "\nInterface 1 of 2 [eth0]: "
read NET0

printf "Interface 2 of 2 [eth1]: "
read NET1

printf "Packet capture name [Capture]: "
read CAPNAME

printf "\nDisable interfaces ...\n\n"
ifconfig $NET0 down
ifconfig $NET1 down                                                                                                                                                                             

printf "Enable interfaces ...\n\n"
ifconfig $NET0 up
ifconfig $NET1 up

printf "Set interfaces to promiscuous mode ...\n\n"
ifconfig $NET0 promisc
ifconfig $NET1 promisc

sleep 1

printf "Starting capturing ...\n\n"

sleep 1

xterm -bg blue -fg white -geometry 90x10-0+0 -T "Capturing on $NET0" -e tcpdump -i $NET0 -w $CAPNAME-$NET0.pcap -v &

sleep 2

xterm -bg blue -fg white -geometry 90x10-0+120 -T "Capturing on $NET1" -e tcpdump -i $NET1 -w $CAPNAME-$NET1.pcap -v &

sleep 2

printf "\n\nPress ANY KEY to end capturing.\n\n"
read CONTINUE

printf "Produced capture file $CAPNAME-$NET0.pcap from $NET0\n\n"
printf "Produced capture file $CAPNAME-$NET1.pcap from $NET1\n\n"

printf "Halting captures ...\n\n"

if [[ ! -z $(pidof tcpdump) ]]; then kill $(pidof tcpdump); fi

printf "Merging captures ...\n\n"
mergecap $CAPNAME-$NET0.pcap $CAPNAME-$NET1.pcap -w $CAPNAME-Full.pcap

printf "Disable interfaces ...\n\n"
ifconfig $NET0 down
ifconfig $NET1 down

printf "Produced capture file $CAPNAME-$NET0.pcap from $NET0\n\n"
printf "Produced capture file $CAPNAME-$NET1.pcap from $NET1\n\n"
printf "Produced capture file $CAPNAME-Full.pcap from merging captures\n\n"
printf "... done\n"

