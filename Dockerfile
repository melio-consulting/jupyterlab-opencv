FROM jupyter/scipy-notebook:17aba6048f44
LABEL maintainer='Merelda Wu'

USER root

RUN apt-get update && apt-get install -y \
    vim \
    openjdk-11-jdk \
    curl

WORKDIR /app
RUN pip install python-dotenv openpyxl opencv-python

RUN jupyter labextension install jupyterlab_vim && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install @lckr/jupyterlab_variableinspector && \
    jupyter labextension install @jupyterlab/plotly-extension
