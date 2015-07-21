#!/bin/sh

IN=$1
OUT=$2

# GDAL can read and convert the large single-tile tif to tiled one
# here are several options for compressing the output
#gdal_translate -of GTiff -co "TILED=YES COMPRESS=LZW" out_1tile.tif out.tif
#gdal_translate -of GTiff -co "TILED=YES" -co "COMPRESS=LZW" -co "PREDICTOR=2" out_1tile.tif out.tif
gdal_translate -co "TILED=YES" -co "COMPRESS=DEFLATE" -co "PREDICTOR=2" -co "BIGTIFF=IF_SAFER" $IN $OUT
