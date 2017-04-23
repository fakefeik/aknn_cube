#!/bin/bash

sudo apt-get install libhdf5-dev
sudo apt-get install libflann-dev

cd flann-app
mkdir build
cd build
cmake ..
make

datasets_link="http://people.cs.ubc.ca/~mariusm/uploads/FLANN/datasets/"
# wget ${datasets_link}sift100K.h5
wget ${datasets_link}sift10K.h5

./flann-app
