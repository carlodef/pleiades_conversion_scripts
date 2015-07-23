#!/bin/sh

# On boucantrin, an execution of the script create_dzi_from_tiff.sh takes less
# than 1 minute for an image of size 40000x17000, if the files are local. As
# soon as the files are on a remote disk, mounted with sshfs, the running time
# becomes huge (still not finished after one hour...). This is due to writing
# many very small files through ssh.

# As a workaround, the input files are copied locally to be processed, then the
# output files are copied back to the remote disk with a tarpipe.

# list the Pléiades panchro images we have
# cd $HOME
# find nas/pleiades/satellite_images/pleiades -name "*.JP2.TIF" | grep -v "napier.broken" > list_pleiades_images_on_the_nas.txt

LIST_OF_PATHS_TO_TIFF=$1
TMP=$HOME/tmp

# For each image, copy it locally, create the dzi image then copy the dzi image
# to the nas with a tarpipe
for tif in $(cat $LIST_OF_PATHS_TO_TIFF); do
    echo $tif

    # useful paths
    nas_dir=$HOME/nas/`dirname $tif`
    file=`basename $tif`
    dzi=${file%%.*}_16BITS.dzi
    dzi_files=${file%%.*}_16BITS_files

    # if the dzi file exists, skip
    if [ -s $nas_dir/$dzi ]; then
        echo "already exists, skip"
    else
        # copy the tif image locally
        rsync -P $nas_dir/$file $TMP

        # do the job
        /bin/bash code/pleiades_conversion_scripts/create_16bits_dzi_from_tiff.sh $TMP/$file

        # move the output back to the nas
        cp $TMP/$dzi $nas_dir
        cd $TMP
        tar c $dzi_files | ssh nas "cd /volume1/`dirname $tif`; tar --warning=no-timestamp -xf -"
        cd -

        # cleanup
        rm $HOME/tmp/$file
        rm $HOME/tmp/$dzi
        rm -r $HOME/tmp/$dzi_files
    fi
done
