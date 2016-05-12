#!/bin/sh

# Convert CNES jp2 files to tiled tiff, using opj_dump (from open_jpeg) and
# otbcli_ExtractROI (from Orfeo ToolBox), or some alternatives (commented).
# Carlo de Franchis, 2015

# interface
IN=$1
OUT=$2

# get the image size with opj_dump
SZX=$(opj_dump -i $IN | grep "x1=" | awk -F '[,=]' '{print $2}')
SZY=$(opj_dump -i $IN | grep "x1=" | awk -F '[,=]' '{print $4}')

# alternative with 'identify' from imagemagick (very slow)
# tmp=$(tempfile)
# identify $IN | awk '{print $3}' > $tmp
# SZX=`cat $tmp | cut -f1 -d'x'`
# SZY=`cat $tmp | cut -f2 -d'x'`
# rm $tmp

# convert the image to tiled TIF (bigtiff if safer) with OTB
otbcli_ExtractROI -ram 4000 -startx 0 -starty 0 -sizex $SZX -sizey $SZY -in $IN -out "$OUT?writegeom=false&gdal:co:TILED=YES&gdal:co:COMPRESS=DEFLATE&gdal:co:PREDICTOR=2&gdal:co:BIGTIFF=IF_SAFER&gdal:co:PROFILE=GDALGeoTIFF" uint16

# alternative with gdal only
# gdal_translate $IN $OUT -ot UInt16 -of GTiff -co "TILED=YES" -co "COMPRESS=DEFLATE" -co "PREDICTOR=2" -co "BIGTIFF=IF_SAFER" -co "PROFILE=GDALGeoTIFF"

# alternative with opj_decompress (produces single tile TIF)
# opj_decompress -i $IN -o "$OUT.TMP.TIF"

# alternative if your version of otbcli_ExtractROI doesn't accept gdal options
# otbcli_ExtractROI -ram 4000 -startx 0 -starty 0 -sizex $SZX -sizey $SZY -in $IN -out "$OUT.TMP.TIF" uint16


# single tiled TIF files can be retiled later with gdal
# gdal_translate -of GTiff -co "TILED=YES" -co "COMPRESS=DEFLATE" -co "PREDICTOR=2" -co "BIGTIFF=IF_SAFER" -co "PROFILE=GDALGeoTIFF" "$OUT.TMP.TIF" $OUT
