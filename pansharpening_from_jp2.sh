#!/bin/sh

# Create a TIFF pansharpened image, from the panchromatic and multi-spectral
# JP2 images. It seems that it does not work with TIFF inputs, but only with JP2.

IN_P=$1
IN_MS=$2
OUT=$3

otbcli_BundleToPerfectSensor -progress 1 -ram 2048 -mode phr -inp $IN_P -inxs $IN_MS -out "$OUT?writegeom=false&gdal:co:TILED=YES&gdal:co:COMPRESS=DEFLATE&gdal:co:PREDICTOR=2&gdal:co:BIGTIFF=IF_SAFER&gdal:co:PROFILE=GDALGeoTIFF" uint16
