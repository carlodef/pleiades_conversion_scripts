#!/bin/bash

download_list=$1

for f in `cat $download_list`; do wget --content-disposition --no-check-certificate $f; done
