#!/bin/sh

# input TIF file, output DZI file
TIF=$1
DZI=${TIF%%.*}.16BITS.dzi

# input grey levels are between 0 and 4095 (12 bits), stored on 16 bits. To get
# a 16-bits png file displayable in a web-browser these grey level must be
# multiplied by 16. For some reason this behavious is obtained with vips by
# asking a multiplication by 4096.
vips linear $TIF $TIF.v 4096 0

# dzi file generation
vips dzsave $TIF.v $DZI

# cleanup
rm $TIF.v
