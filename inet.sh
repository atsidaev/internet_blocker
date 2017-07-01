#/bin/sh

rule_nat="-p tcp -j DNAT --to-destination=192.168.1.1:8088"
rule_fw="-p tcp --dport=443 -j DROP"

if [ "$1" == "disable" ]
then
	while iptables -t nat -D PREROUTING $rule_nat; do echo; done
	while iptables -D FORWARD $rule_fw; do echo; done
else
	iptables -t nat -I PREROUTING 1 $rule_nat
	iptables -I FORWARD 1 $rule_fw
fi
