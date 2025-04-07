#include "headers.p4"

// Defining backend server
const bit<32> BACKENDS[2] = {0x0a000001, 0x0a000002}; // 10.0.0.1, 10.0.0.2

parser MyParser(packet_in packet, out headers hdr) {
    state start {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            0x0800: parse_ipv4;
            default: accept;
        }
    }
    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            6: parse_tcp;  // TCP
            default: accept;
        }
    }
    state parse_tcp {
        packet.extract(hdr.tcp);
        transition accept;
    }
}

control MyIngress(inout headers hdr, inout metadata meta) {
    action forward_to_backend(bit<32> backend_ip) {
        // Simple DSR: Rewrite destination IP
        hdr.ipv4.dstAddr = backend_ip;
    }

    table vip_routing {
        key = {
            hdr.ipv4.dstAddr: exact;
        }
        actions = {
            forward_to_backend;
            NoAction;
        }
        default_action = NoAction;
    }

    apply {
        // If packet is for VIP (192.168.1.100), forward to backend
        if (hdr.ipv4.dstAddr == 0xc0a80164) { // 192.168.1.100
            // Simple round-robin (replace with Maglev later)
            bit<32> backend = BACKENDS[(hdr.tcp.srcPort % 2)];
            forward_to_backend.execute(backend);
        }
    }
}

control MyDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.tcp);
    }
}

// our Main pipeline
V1Switch(
    MyParser(),
    MyIngress(),
    MyDeparser()
) main;
