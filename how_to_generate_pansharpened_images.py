#!/usr/bin/env python
# This Python file uses the following encoding: utf-8

import subprocess
import os
import sys
import re

def main(pleiades_dir):
    """
    """
    for f in os.listdir(pleiades_dir): 
        ff = os.path.join(pleiades_dir, f)
        if os.path.isdir(ff):

            # list ms images
            p = subprocess.Popen("find %s -not \( -path *_files -prune \) -type f -name \"*_MS_*.JP2\"" % ff, shell=True, stdout=subprocess.PIPE)
            ms_files = p.stdout.read().splitlines()
            if not ms_files:
                print "no MS images in dataset %s" % f
            else:
                # list pan images
                p = subprocess.Popen("find %s -not \( -path *_files -prune \) -type f -name \"*_P_*.JP2\"" % ff, shell=True, stdout=subprocess.PIPE)
                pan_files = p.stdout.read().splitlines()

                for ms in ms_files:
                    date_ms = re.split('_', os.path.basename(ms))[3]
                    # search for the pan file with the same date
                    matching_pan = None
                    for pan in pan_files:
                        if re.split('_', os.path.basename(pan))[3] == date_ms:
                            matching_pan = pan
                            break
                    if matching_pan is None:
                        print "no matching panchro image found"
                    else:
                        # replace _P_ by _PXS_ in the img filename
                        tmp = re.split('_', os.path.basename(pan))
                        tmp[2] = 'PXS'
                        pxs = os.path.join(os.path.dirname(pan), '_'.join(tmp))

                        # change the JP2 extension to TIF
                        pxs = re.sub('JP2', 'TIF', pxs)
                        print "bash /home/carlo/code/pleiades_conversion_scripts/pansharpening_from_jp2.sh %s %s %s" % (pan, ms, pxs)
                        #subprocess.call("bash /home/carlo/code/pleiades_conversion_scripts/pansharpening_from_jp2.sh %s %s %s" % (pan, ms, pxs), shell=True)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print 'usage: %s pleiades_dir' % sys.argv[0]
    else:
        main(sys.argv[1])
