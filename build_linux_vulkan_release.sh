#!/usr/bin/env bash

set echo off

cmake -E make_directory build/linux_release
cd build/linux_release
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../../install/linux_release $@ ../..
make -j `getconf _NPROCESSORS_ONLN`
make install

set echo on
