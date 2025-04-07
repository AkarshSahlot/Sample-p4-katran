from scapy.all import *
import os

def test_katran():
    print("Testing Katran P4 load balancer...")
    
    # here we are Sending our test packet
    pkt = Ether() / IP(dst="192.168.1.100") / TCP(dport=80)
    sendp(pkt, iface="eth0", verbose=False)
    
    # Verifying with tcpdump 
    print("Packet sent. Verify with:")
    print("sudo tcpdump -i eth0 -nn 'host 192.168.1.100'")

if __name__ == "__main__":
    test_katran()
