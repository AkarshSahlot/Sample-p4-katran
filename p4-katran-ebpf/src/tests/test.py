from scapy.all import *

# we are Sending a TCP packet to VIP (192.168.1.100)
pkt = Ether() / IP(dst="192.168.1.100") / TCP(sport=1234, dport=80)
sendp(pkt, iface="eth0")  # Replace with your interface
