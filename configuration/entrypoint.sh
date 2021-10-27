#!/bin/bash

set -e

sudo chown -R me:me /mnt
sudo chmod -R 755 /mnt

exec "$@"