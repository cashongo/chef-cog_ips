#!/bin/bash

IPTABLES=/sbin/iptables

$IPTABLES -C INPUT -j NFLOG --nflog-group 2 || $IPTABLES -A INPUT -j NFLOG --nflog-group 2
$IPTABLES -C OUTPUT -j NFLOG --nflog-group 2 || $IPTABLES -A OUTPUT -j NFLOG --nflog-group 2
$IPTABLES -C FORWARD -j NFLOG --nflog-group 2 || $IPTABLES -A FORWARD -j NFLOG --nflog-group 2
