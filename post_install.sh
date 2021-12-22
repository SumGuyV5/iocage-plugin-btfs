#!/bin/sh -x
IP_ADDRESS=$(ifconfig | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}')

fetch https://github.com/SumGuyV5/iocage-plugin-btfs/releases/download/1.6.0/go-btfs-1.6.0.pkg

pkg install -y go-btfs-1.6.0.pkg
rm go-btfs-1.6.0.pkg

sysrc btfs_enable=YES

INIT=$(btfs init)

btfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://'"${IP_ADDRESS}"':5001", "http://0.0.0.0:5001"]'
btfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "GET", "POST"]'

btfs config --json Addresses.API '"/ip4/'"${IP_ADDRESS}"'/tcp/5001"'

btfs config profile apply storage-host

service btfs start

echo -e "${INIT}.\n"  > /root/PLUGIN_INFO
echo -e "btfs now installed.\n" >> /root/PLUGIN_INFO
echo -e "\nPlease open your web browser and go to http://${IP_ADDRESS}:5001/hostui to configure btfs.\n" >> /root/PLUGIN_INFO
echo -e "\nYou can also go to http://${IP_ADDRESS}:5001/webui \n" >> /root/PLUGIN_INFO