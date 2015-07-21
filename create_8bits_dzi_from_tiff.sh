#!/bin/sh

# input TIF file, output DZI file
TIF=$1
DZI=${TIF%%.*}.dzi

# gamma correction and simplest color balance to 8 bits with otbcli_Convert
UINT=${TIF%%.*}.UINT8.TIF
otbcli_Convert -progress 1 -ram 4096 -type linear -type.linear.gamma 1.5 -hcp.high .1 -hcp.low .1 -in $TIF -out "$UINT?writegeom=false&gdal:co:TILED=YES&gdal:co:BIGTIFF=IF_SAFER&gdal:co:PROFILE=BASELINE" uint8

# alternative with otbcli_Rescale, without gamma correction
# otbcli_Rescale -progress 1 -in $TIF -out $UINT uint8

# dzi file generation with vips
vips dzsave $UINT $DZI
rm $UINT
