#!/bin/bash
if command -v isc-dhcp-server >/dev/null 2>&1; then
	sudo apt --purge remove isc-dhcp-server -y
fi

if command -v proftpd >/dev/null 2>&1; then
    sudo apt --purge remove proftpd -y
fi

if command -v bind9 >/dev/null 2>&1; then
    sudo apt --purge remove bind9 -y
fi

if command -v bind9utils >/dev/null 2>&1; then
    sudo apt --purge remove bind9utils -y
fi

if command -v dnsutils >/dev/null 2>&1; then
    sudo apt --purge remove dnsutils -y
fi