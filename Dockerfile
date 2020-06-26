FROM gcr.io/kubeflow-images-public/tensorflow-2.1.0-notebook-cpu:1.0.0
LABEL maintainer='Merelda Wu'

USER root

RUN apt-get update && apt-get install -y --fix-missing \
    vim \
    openjdk-11-jdk \
    curl \
    build-essential \
    cmake \
    gfortran \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libavcodec-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    software-properties-common \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*

RUN cd ~ && \
    mkdir -p dlib && \
    git clone -b 'v19.9' --single-branch https://github.com/davisking/dlib.git dlib/ && \
    cd  dlib/ && \
    python setup.py install --yes USE_AVX_INSTRUCTIONS

WORKDIR /app
RUN pip install --upgrade pip
RUN pip install python-dotenv openpyxl opencv-python face_recognition kubeflow-kale

# RUN conda install nodejs

RUN jupyter labextension install jupyterlab_vim && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install @lckr/jupyterlab_variableinspector && \
    jupyter labextension install kubeflow-kale-labextension

ENV NB_PREFIX /

CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX}"]
