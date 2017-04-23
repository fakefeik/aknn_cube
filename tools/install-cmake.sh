#!/bin/bash

mkdir ~/temp
cd ~/temp
wget https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz
tar xzvf cmake-3.7.2.tar.gz
cd cmake-3.7.2/

./bootstrap
make -j4
sudo make install
