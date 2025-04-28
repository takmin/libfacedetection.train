WORKDIR /root/yunet

# Install Anaconda
ENV CUDA_HOME /usr/local/cuda
RUN apt update -y && DEBIAN_FRONTEND=noninteractive apt install -y wget bzip2 git gcc vim libopencv-dev
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH

# Create the environement
COPY environment.yml .
RUN pip install --upgrade pip && \
    conda update -n base -c defaults conda && \
    conda env create -n yunet -f environment.yml && \
    conda init && \
    echo "conda activate yunet" >> /root/.bashrc

ENV CONDA_DEFAULT_ENV yunet && \
    PATH /opt/conda/envs/yunet/bin:$PATH

# Install mmcv
# RUN pip install mmcv-full==1.6.0 -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.8.0/index.html
# RUN git clone https://github.com/open-mmlab/mmcv.git
# WORKDIR /root/yunet/mmcv
# RUN git checkout v1.6.0
# RUN FORCE_CUDA=1 pip install -r requirements/optional.txt && \
#     MMCV_WITH_OPS=1 pip install -v -e .
#     python .dev_scripts/check_installation.py > check_installation.txt

WORKDIR /root/yunet

# Install libfacedetection
RUN git clone https://github.com/takuya/libfacedetection.train.git

WORKDIR /root/yunet/libfacedetection.train

# RUN conda run -n yunet python setup.py develop && \
#    pip install cython==0.29.33 yapf==0.40.1 && \
#    pip install -r requirements.txt

CMD ["/bin/bash"]