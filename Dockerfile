###########################################################################################
# STAGE 1: Build a cuda-enabled base image
###########################################################################################
FROM ubuntu:18.04 as nvidia_base

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt update --fix-missing && apt install -y wget curl bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion systemd python3-dev default-libmysqlclient-dev net-tools iputils-ping vim htop && \
    rm /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python

# Setup NVIDIA Base
RUN apt update && apt install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

ENV NCCL_VERSION 2.4.2
ENV CUDA_VERSION 10.0.130
ENV CUDNN_VERSION 7.5.1.10

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

ENV CUDA_PKG_VERSION 10-0=$CUDA_VERSION-1
# For libraries in the cuda-compat-*
RUN apt update && apt install -y --no-install-recommends \
    cuda-cudart-$CUDA_PKG_VERSION \
    cuda-compat-10-0 \
    cuda-libraries-$CUDA_PKG_VERSION \
    cuda-libraries-dev-$CUDA_PKG_VERSION \
    cuda-nvml-dev-$CUDA_PKG_VERSION \
    cuda-nvtx-$CUDA_PKG_VERSION \
    cuda-minimal-build-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
    libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 \
    libnccl2=$NCCL_VERSION-1+cuda10.0 \
    libnccl-dev=$NCCL_VERSION-1+cuda10.0 && \
    apt-mark hold libcudnn7 libcudnn7-dev && \
    apt-mark hold libnccl2 libnccl-dev && \
    ln -s cuda-10.0 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/opt/cmake-3.14.3/bin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs${LIBRARY_PATH:+:${LIBRARY_PATH}}

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

###########################################################################################
# STAGE 2: Install dependencies
###########################################################################################
FROM nvidia_base as vlsp

# Install cmake
WORKDIR /opt/cmake

RUN echo "\nDownloading and building CMake...\n" && \
    apt update && apt install -y qtbase5-dev libncurses5-dev && \
    wget https://github.com/Kitware/CMake/releases/download/v3.14.3/cmake-3.14.3.tar.gz && \
    tar xvzf cmake-3.14.3.tar.gz && cd /opt/cmake/cmake-3.14.3 && \
    ./configure --qt-gui && \
    ./bootstrap && make -j $(nproc) && make install -j $(nproc)

# Install necessary packages
RUN pip3 uninstall -y numpy enum34 && \
    wget https://github.com/numpy/numpy/archive/v1.16.3.zip -O numpy.zip && \
    unzip numpy.zip && cd numpy-1.16.3 && \

###########################################################################################
# STAGE 3: Install other packages
###########################################################################################
# Todo:
# Checkout enviroment 
# copy requirement and install 
WORKDIR /opt/packages
RUN pip3 install torchvision==0.5.0 && torch==1.4.0 && \
    pip3 install https://github.com/trungtv/vi_spacy/raw/master/packages/vi_spacy_model-0.2.1/dist/vi_spacy_model-0.2.1.tar.gz && \
    pip install pyvi
COPY ["./", "/vlsp"]
WORKDIR /vlsp
RUN pip3 install -r requirements.txt

###########################################################################################
# STAGE 4: Default commands
###########################################################################################
CMD ["/bin/bash"]

