ARG cuda_version=9.0
ARG cudnn_version=7
FROM nvidia/cuda:${cuda_version}-cudnn${cudnn_version}-devel

ENV DEBIAN_FRONTEND=noninteractive

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      python-dev \
      libblas-dev \
      bzip2 \
      g++ \
      git \
      libtool-bin \
      vim \
      make \
      sudo \
      libopencv-dev \
      pkg-config \
      graphviz \
      libgl1-mesa-glx \
      libhdf5-dev \
      openmpi-bin \
      wget && \
    rm -rf /var/lib/apt/lists/*

# Install conda
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

RUN wget --quiet --no-check-certificate https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo "c59b3dd3cad550ac7596e0d599b91e75d88826db132e4146030ef471bb434e9a *Miniconda3-4.2.12-Linux-x86_64.sh" | sha256sum -c - && \
    /bin/bash /Miniconda3-4.2.12-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-4.2.12-Linux-x86_64.sh && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh

# Install Python packages and keras
ENV NB_USER kocr
ENV NB_UID 1000

RUN useradd -m $NB_USER && echo "kocr:kocr" | chpasswd && adduser $NB_USER sudo && \
    chown $NB_USER $CONDA_DIR -R && \
    mkdir -p /src && \
    chown $NB_USER /src

USER $NB_USER

ARG python_version=3.6

RUN conda config --append channels conda-forge
RUN conda install -y python=${python_version} && \
    pip install --upgrade pip && \
    pip install \
      sklearn_pandas \
      opencv-python \
      setuptools \
      --ignore-installed six \
      cntk-gpu && \
    conda install \
      blas \
      bcolz \
      mkl-service \
      matplotlib \
      mkl \
      nose \
      notebook \
      pandas \
      pydot \
      pygpu \
      pyyaml \
      scikit-learn \
      theano \
      h5py \
      mkdocs \
      && \
    conda clean -yt 

RUN conda install \
      keras==2.1.4

ARG theano_version=1.0.4
RUN pip install \
    Pillow==5.0.0 \
    numpy==1.14.1 \
    scipy==1.0.0 \
    h5py==2.7.1 \
    Theano==${theano_version}

RUN python -c "import keras" 2>/dev/null

RUN sed -i -e s/\"channels_last\"/\"channels_first\"/ ~/.keras/keras.json && \
    sed -i -e s/\"tensorflow\"/\"theano\"/ ~/.keras/keras.json

ADD theanorc /home/kocr/.theanorc

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENV PYTHONPATH='/src/:$PYTHONPATH'

ADD valid.py /home/src/valid.py
ADD kocr_cnn.cpp /home/src/kocr_cnn.cpp
ADD train_cnn.py /home/src/train_cnn.py
RUN cd ~ && mkdir code && cd code && \
    git clone https://github.com/faxocr/kocr.git && \
    cd kocr && git fetch origin pull/3/head:replace_preprocessing && git checkout replace_preprocessing && \
    cd ~/code/kocr/learning && mv train_cnn.py train_cnn.py.bk && cp /home/src/train_cnn.py . && \
    cd ~/code/kocr/src && cp /home/src/valid.py .  && mv kocr_cnn.cpp kocr_cnn.cpp.bk && cp /home/src/kocr_cnn.cpp . && make

WORKDIR /data

EXPOSE 8888

CMD jupyter notebook --port=8888 --ip=0.0.0.0
