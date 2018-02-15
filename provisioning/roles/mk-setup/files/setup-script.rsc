/ip address add interface=ether2 address=172.25.0.254/24
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1
/ip dns set allow-remote-requests=yes
