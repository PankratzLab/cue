# docker build -t cue .
FROM registry.codeocean.com/codeocean/miniconda3:4.7.10-python3.7-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends bcftools=1.7-2 
RUN apt-get install -y --no-install-recommends build-essential=12.4ubuntu1 
RUN apt-get install -y --no-install-recommends libbz2-dev=1.0.6-8.1ubuntu0.2 
RUN apt-get install -y --no-install-recommends zlib1g-dev=1:1.2.11.dfsg-0ubuntu2
RUN apt-get install -y --no-install-recommends libgl1-mesa-glx 
RUN apt-get install -y --no-install-recommends libglib2.0-0 
RUN apt-get install -y --no-install-recommends libsm6 
RUN apt-get install -y --no-install-recommends libxrender1 
RUN apt-get install -y --no-install-recommends libxext6 
RUN apt-get install -y --no-install-recommends tabix 
RUN apt-get install -y --no-install-recommends git

RUN rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

RUN pip install -U --no-cache-dir \
    setuptools==58.0.0 \
    wheel
# RUN pip install -U --no-cache-dir \
RUN pip install -U --no-cache-dir bitarray==1.6.3 
RUN pip install -U --no-cache-dir cachetools==4.1.0 
RUN pip install -U --no-cache-dir cython==0.29.21 
RUN pip install -U --no-cache-dir intervaltree==3.1.0 
RUN pip install -U --no-cache-dir joblib==0.16.0 
RUN pip install -U --no-cache-dir matplotlib==3.2.1 
RUN pip install -U --no-cache-dir numpy==1.18.5 
RUN pip install -U --no-cache-dir opencv-python==4.5.1.48 
RUN pip install -U --no-cache-dir pandas==1.0.5 
# https://github.com/cython/cython/issues/5539 switching from 2.0.4 to 2.0.6
RUN pip install -U --no-cache-dir pycocotools==2.0.6 
RUN pip install -U --no-cache-dir pyfaidx==0.5.9.5 
RUN pip install -U --no-cache-dir pysam==0.16.0.1 
RUN pip install -U --no-cache-dir pytabix==0.1 
RUN pip install -U --no-cache-dir python-dateutil==2.8.1 
RUN pip install -U --no-cache-dir pyyaml==5.3.1 
RUN pip install -U --no-cache-dir seaborn==0.11.0 
RUN pip install -U --no-cache-dir setuptools-scm==6.4.2 
RUN pip install -U --no-cache-dir torch==1.5.1 
RUN pip install -U --no-cache-dir torchvision==0.6.1 
RUN pip install -U --no-cache-dir jupyter

RUN python3 -m pip install Truvari


WORKDIR /app
# https://stackoverflow.com/questions/36996046/how-to-prevent-dockerfile-caching-git-clone
# prevent cached git clone if repo main is updated
# Github rate limits quite often
# ADD https://api.github.com/repos/PankratzLab/NGS-TL/git/refs/heads/main version.json
# use time instead
ADD https://worldtimeapi.org/api/ip time.tmp

RUN git clone https://github.com/jlanej/cue.git
WORKDIR /app/cue
RUN wget --directory-prefix=data/models/ https://storage.googleapis.com/cue-models/latest/cue.v2.pt


ENV PYTHONPATH "${PYTHONPATH}:/app/cue"


CMD ["/bin/bash"]


