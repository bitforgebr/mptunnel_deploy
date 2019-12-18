# Introdução

Este repositório serve para distribuição da solução já compilada do [mptunnel](https://github.com/bitforgebr/mptunnel). Os binários fornecidos aqui estão compilados para Ubuntu e poderão ser executados em um ambiente montado conforme descrito abaixo.

## Montagem (Ubuntu)

Atualizar o database dos pacotes do apt.

```
apt update
```

Instalar as seguintes ferramentas e dependências.

```
apt install git
apt install libev-dev
apt install socat
```

Baixar este repositório.

```
git clone https://github.com/bitforgebr/mptunnel_deploy && cd mptunnel_deploy
```

Configurar um ou mais scripts que irão iniciar os processos mpclient e mpserver, além das bridges, configuradas usando a ferramenta socat. O teste de tudo local está localizado em sample.start.sh.

### Caso de uso: Brasil localhost

Este caso de uso contém quatro máquinas, todas locais, com os IPs 169.57.153.183, 169.57.153.180, 169.57.153.179, 169.57.153.181. O mpclient irá rodar na máquina 183 e através da 183, 180 e 179 irá conectar na máquina 181, onde estará rodando o mpserver. Na máquina 181 também estará rodando o udpserver, o servidor de teste. Através da 183 será possível conectar ao mpclient pelo udpclient e testar o ambiente.

```
                               .------ 180:socat ------.
                              /                         \
 *:udpclient --- 183:mpclient -------- 183:socat ------- 181:mpserver --- 181:udpserver
                              \                         /
                               `------ 179:socat ------`

# 169.57.153.183 (poc_brasil_localhost_183.sh)
./mpclient 4000 client.sample.conf&
socat udp-listen:4001 udp4:169.57.153.181:2000&

# client_poc_brasil_localhost.conf
169.57.153.183 4001
169.57.153.180 4002
169.57.153.179 4003

# 169.57.153.180 (poc_brasil_localhost_180.sh)
socat udp-listen:4002 udp4:169.57.153.181:2000&

# 169.57.153.179 (poc_brasil_localhost_179.sh)
socat udp-listen:4003 udp4:169.57.153.181:2000&

# 169.57.153.181 (poc_brasil_localhost_181.sh)
./mpserver 2000 localhost 6666&
./udpserver 6666&

# any machine
./udpclient 169.57.153.183 4000
```

