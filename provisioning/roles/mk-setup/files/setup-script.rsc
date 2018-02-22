/user remove admin
/ip address add interface=ether2 address=172.25.0.254/24
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1
/ip dns 
set allow-remote-requests=yes
set servers=8.8.8.8
/system ntp client set server-dns-names=time.google.com
/ppp secret add name=vagrant password=vagrant service=any disabled=no local-address=192.168.16.5 remote-address=192.168.16.6
/interface ovpn-server server
set cipher=blowfish128,aes128,aes192,aes256
set default-profile=default-encryption
set certificate=server.crt_0
set enabled=yes
set require-client-certificate=yes
/ip firewall filter 
add action=accept chain=input comment="OpenVPN" disabled=no dst-port=1194 protocol=tcp
/ip firewall mangle add chain=forward action=sniff-tzsp sniff-target=192.168.16.6 sniff-target-port=37008 passthrough=yes
/ip firewall mangle add chain=input  action=sniff-tzsp sniff-target=192.168.16.6 sniff-target-port=37008 passthrough=yes
/system package update install