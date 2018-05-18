#!/bin/sh

# Install openstack clients
function install_client {
    git clone https://github.com/openstack/python-$1client.git /root/python-$1client --depth 1
    cd /root/python-$1client
    pip install --no-cache-dir .
}

install_client openstack
for arg do
    install_client $arg
done

