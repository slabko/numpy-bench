from ubuntu:20.04

copy fakeintel.c /root/
copy numpy-bench.py /root/

env PATH /opt/conda/bin:$PATH
env CONDA_VERSION py38_4.9.2
env CONDA_MD5 122c8c9beb51e124ab32a0fa6426c656
env DEBIAN_FRONTEND=noninteractive

run apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git mercurial subversion build-essential && \
    apt-get clean

run wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
    echo "${CONDA_MD5}  miniconda.sh" > miniconda.md5 && \
    if [ $(md5sum -c miniconda.md5 | awk '{print $2}') != "OK" ] ; then exit 1; fi && \
    /bin/bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh miniconda.md5 && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

run conda install numpy scipy 

run gcc -shared -fPIC -o /root/libfakeintel.so /root/fakeintel.c
env LD_PRELOAD=/root/libfakeintel.so

cmd python /root/numpy-bench.py
