# 169.57.153.183 (poc_brasil_localhost_183.sh)
./mpclient 4000 client_poc_brasil_localhost.conf&
socat udp-listen:4001 udp4:169.57.153.181:2000&
