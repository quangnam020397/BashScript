#!/bin/bash

git clone https://github.com/Simonwep/openvpn-pihole.git
cd openvpn-pihole

sudo docker-compose up -d


docker run -d \
  --name=openvpn-as \
  --cap-add=NET_ADMIN \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Ho_Chi_Minh \
  -p 943:943 \
  -p 9443:9443 \
  -p 1194:1194/udp \
  -v ./data:/config \
  --restart unless-stopped \
  ghcr.io/linuxserver/openvpn-as


version: "2.1"

services:
  wireguard:
    image: ghcr.io/linuxserver/wireguard
    container_name: wireguard
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Ho_Chi_Minh
      - SERVERURL=wireguard.domain.com #optional
      - SERVERPORT=51820 #optional
      - PEERS=1 #optional
      - PEERDNS=auto #optional
      - INTERNAL_SUBNET=10.13.13.0 #optional
      - ALLOWEDIPS=0.0.0.0/0 #optional
    volumes:
      - ./path/to/appdata/config:/config
      - ./lib/modules:/lib/modules
    ports:
      - 51820:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped


docker run \
  --name=openvpn-as \
  --cap-add=NET_ADMIN \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Singapore \
  -p 943:943 \
  -p 9443:9443 \
  -p 1194:1194/udp \
  -v /home/quangnam_113322/openvpn/config:/config \
  --restart unless-stopped \
  ghcr.io/linuxserver/openvpn-as



docker run -d \
  --name=wireguard \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Ho_Chi_Minh \
  -e SERVERURL=192.168.99.106 `#optional` \
  -e SERVERPORT=51820 `#optional` \
  -e PEERS=1 `#optional` \
  -e PEERDNS=auto `#optional` \
  -e INTERNAL_SUBNET=10.13.13.0 `#optional` \
  -e ALLOWEDIPS=0.0.0.0/0 `#optional` \
  -p 51820:51820/udp \
  -v /path/to/appdata/config:/config \
  -v /lib/modules:/lib/modules \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart always \
  ghcr.io/linuxserver/wireguard



  base=https://github.com/docker/machine/releases/download/v0.16.0 && curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine && sudo mv /tmp/docker-machine /usr/bin/docker-machine && chmod +x /usr/bin/docker-machine


export CLIENTNAME="mac_open_key1"
# with a passphrase (recommended)
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
# without a passphrase (not recommended)
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass



version: '3'
# https://github.com/kylemanna/docker-openvpn/blob/master/docs/docker-compose.md

services:
   openvpn:
     cap_add:
       - NET_ADMIN
     container_name: vpn_openvpn
     image: kylemanna/openvpn
     ports:
       - "1194:1194/udp"
       - "1194:1194/tcp"
     environment:
      #  - VIRTUAL_PORT=${VIRTUAL_PORT_OPENVPN}
      #  - VIRTUAL_HOST=${VIRTUAL_HOST_OPENVPN}
      #  - LETSENCRYPT_HOST=${LETSENCRYPT_HOST_VPN}
      #  - LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}
      #  - OPENVPN_PROVIDER=${OPENVPN_PROVIDER}
      #  - OPENVPN_USERNAME=${OPENVPN_USERNAME}
      #  - OPENVPN_PASSWORD=${OPENVPN_PASSWORD}
      # - LOCAL_NETWORK=192.168.0.0/24
       OPENVPN_OPTS: --inactive 3600 --ping 10 --ping-exit 60 -–log-driver json-file --log-opt max-size=10m
     volumes:
       - /etc/localtime:/etc/localtime:ro
       - /etc/timezone:/etc/timezone:ro
       - ./openvpn_data:/etc/openvpn
     restart: always
     networks:
       vpn-net:
         ipv4_address: 172.110.1.3
     logging:
       driver: "json-file"
       options:
         max-size: "10m"
         max-file: "3"

   pihole:
     image: pihole/pihole
     container_name: vpn_pihole
     cap_add:
       - NET_ADMIN     
     dns:
       - 127.0.0.1
       - 1.1.1.1
     depends_on:
       - openvpn
     ports:
       #- "553:53/tcp"
       #- "553:53/udp"
       - "8081:80/tcp"
     environment:
       WEBPASSWORD: fcvFjLIO2hWhkFCi
# #1 Digitalcourage | #2 Chaos Computer Club
       DNS1: 1.1.1.1
       DNS2: 8.8.8.8
     volumes:
       - ./pihole:/etc/pihole
       - ./pihole/dnsmasq.d:/etc/dnsmasq.d
       - /etc/localtime:/etc/localtime:ro
       - /etc/timezone:/etc/timezone:ro
     restart: always
     networks:
       vpn-net:
         ipv4_address: 172.110.1.4     
     logging:
       driver: "json-file"
       options:
         max-size: "5m"
         max-file: "3"

# docker network create --driver=bridge --subnet=172.110.1.0/24 --gateway=172.110.1.1 vpn-net
networks:
  vpn-net:
    external: true