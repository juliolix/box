#!/bin/bash
#Firewall FireLix 
#Be happy Joao :) uncle Julio Martins!
#bash <(curl -s http://mywebsite.com/myscript.txt)


# Limpa todas as regras do Firewall

iptables -F 
iptables -X
iptables -F -t nat
iptables -X -t nat
iptables -F -t mangle
iptables -X -t mangle



# Protege contra synflood
echo "1" > /proc/sys/net/ipv4/tcp_syncookies

# Protecao contra ICMP Broadcasting 
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# Protecoes diversas contra portscanners, ping of death, ataques DoS, pacotes danificados e etc.
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD --protocol tcp --tcp-flags ALL SYN,ACK -j DROP
iptables -A INPUT -m state --state INVALID -j DROP
iptables -N VALID_CHECK
iptables -A VALID_CHECK -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
iptables -A VALID_CHECK -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -A VALID_CHECK -p tcp --tcp-flags ALL ALL -j DROP
iptables -A VALID_CHECK -p tcp --tcp-flags ALL FIN -j DROP
iptables -A VALID_CHECK -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A VALID_CHECK -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A VALID_CHECK -p tcp --tcp-flags ALL NONE -j DROP


# Bloqueia qualquer conectividade da Internet para o servidor
iptables -P INPUT  DROP
iptables -P FORWARD DROP 
iptables -P OUTPUT ACCEPT



# Libera a navegacao do servidor 
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT



# Libera tudo para o Primario 
IP_PRIMARIO="167.114.185.133"
iptables -A INPUT -s 0.0.0.0/0 -d $IP_PRIMARIO -j ACCEPT


# Libera portas
PORTAS="80,30"
iptables -A INPUT -p tcp -m multiport --dport $PORTAS -j ACCEPT
iptables -A INPUT -p udp -m multiport --dport $PORTAS -j ACCEPT


# Libera ping
iptables -A INPUT -p icmp -j ACCEPT 

echo " "
echo "======================> AS REGRAS FORAM INJETADAS CONFORME ABAIXO <============================"
echo " "

# LISTA AS REGRAS PARA VISUALIZAR
iptables -L -n
