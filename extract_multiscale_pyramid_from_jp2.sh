#!/bin/sh

# creates a multi-resolution pyramid TIFF from a single JP2 image,
# using opj_dump (from open_jpeg) and otbcli_ExtractROI (from Orfeo ToolBox).

# It produces 5 files, a1.tif to a5.tif, in the directory of the input image:
# a1.tif is the input image downsampled by a factor 2¹
# a2.tif is the input image downsampled by a factor 2²
# a3.tif is the input image downsampled by a factor 2³
# a4.tif is the input image downsampled by a factor 2⁴
# a5.tif is the input image downsampled by a factor 2⁵

# additionally it create a link a0.tif to the TIFF version of the input JP2
# image, which is supposed to exist already.

# path to the input JP2 image
IN=$1  

# create link to the TIFF version of the input image
DIR=$(dirname $IN)
IMG=$(basename $IN)
ln -s $IMG.TIF $DIR/a0.tif

# get the image size from the JP2 header 
SZX=$(opj_dump -i $IN | grep "x1=" | awk -F '[,=]' '{print $2}')
SZY=$(opj_dump -i $IN | grep "x1=" | awk -F '[,=]' '{print $4}')

# alternative way to get the image size, using the DIM*.XML file
DIM=${IMG/IMG/DIM}  # replace 'IMG' by 'DIM' in the filename
DIM=${DIM/JP2/XML}  # replace 'JP2' by 'XML' in the filename
DIM=${DIM/_R1C1/}  # remove '_R1C1' from the filenmae
SZX=`cat $DIR/$DIM | grep NCOLS | cut -f2 -d'>' | cut -f1 -d'<'`
SZY=`cat $DIR/$DIM | grep NROWS | cut -f2 -d'>' | cut -f1 -d'<'`
echo $SZX $SZY

# compute the image pyramid
for i in {1..5}; do
    otbcli_ExtractROI -ram 16000 -startx 0 -starty 0 -sizex $SZX -sizey $SZY -in "$IN?&resol=$i" -out "$DIR/a$i.tif?&writegeom=false&gdal:co:TILED=YES&gdal:co:COMPRESS=DEFLATE&gdal:co:PREDICTOR=2&gdal:co:BIGTIFF=IF_SAFER&gdal:co:PROFILE=GDALGeoTIFF" uint16
done
