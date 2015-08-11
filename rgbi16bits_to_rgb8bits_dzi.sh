#!/bin/bash

# The input image is an RGBI UINT16 obtained from pansharpening made with OTB

# The output is an RGB UINT8 in DZI format

IN=$1
OUT=$2
vips --vips-progress extract_band $IN ${IN%%.*}_BAND_RED.v 0
vips --vips-progress extract_band $IN ${IN%%.*}_BAND_GREEN.v 1
vips --vips-progress extract_band $IN ${IN%%.*}_BAND_BLUE.v 2
vips --vips-progress extract_band $IN ${IN%%.*}_BAND_INFRA.v 3
vips --vips-progress linear ${IN%%.*}_BAND_GREEN.v ${IN%%.*}_BAND_GREEN_09.v 0.9 0
vips --vips-progress linear ${IN%%.*}_BAND_INFRA.v ${IN%%.*}_BAND_INFRA_01.v 0.1 0
vips --vips-progress add ${IN%%.*}_BAND_GREEN_09.v ${IN%%.*}_BAND_INFRA_01.v ${IN%%.*}_BAND_GREEN.v
vips --vips-progress bandjoin "${IN%%.*}_BAND_RED.v ${IN%%.*}_BAND_GREEN.v ${IN%%.*}_BAND_BLUE.v" ${IN%%.*}_RGB.v
vips --vips-progress scale ${IN%%.*}_RGB.v ${IN%%.*}_RGB_UINT8.v
vips --vips-progress gamma ${IN%%.*}_RGB_UINT8.v ${IN%%.*}_RGB_UINT8_GAMMA.v
vips --vips-progress dzsave ${IN%%.*}_RGB_UINT8_GAMMA.v $OUT

# cleanup
#rm ${IN%%.*}_BAND_*.v
#rm ${IN%%.*}_RGB.v
