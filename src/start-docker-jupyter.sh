#!/bin/bash

echo "Running jupyter notebooks in docker. Open a browser to http://localhost:8888"

sudo docker run -it -p 8888:8888 -p 6006:6006 -v /media/sf_shared:/root/sharedfolder lprisan/dl-docker-loadcaffe:cpu sh -c 'jupyter notebook --ip=0.0.0.0 --no-browser --notebook-dir=/root/sharedfolder/paper-JLA-deep-teaching-analytics/notebooks'

