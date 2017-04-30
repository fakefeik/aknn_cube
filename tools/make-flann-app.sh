#!/bin/bash

sudo apt-get install libhdf5-dev
sudo apt-get install libflann-dev

cd flann-app

if [ ! -d build ]; then
    mkdir build
fi

cd build
cmake ..
make

datasets_link="http://people.cs.ubc.ca/~mariusm/uploads/FLANN/datasets/"
dataset_name="sift10K.h5"
# dataset_name="sift100K.h5"

if [ ! -f $dataset_name ]; then
    wget $datasets_link$dataset_name
fi

cp $dataset_name dataset.h5

./flann-app
