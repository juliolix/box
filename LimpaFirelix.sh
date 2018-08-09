#!/bin/bash
#Firewall FireLix 
#Be happy Joao :) uncle Julio Martins!
#curl -Ss https://raw.githubusercontent.com/juliolix/box/master/LimpaFireLix.sh | bash 


# Limpa todas as regras do Firewall

iptables -F 
iptables -X
iptables -F -t nat
iptables -X -t nat
iptables -F -t mangle
iptables -X -t mangle

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
