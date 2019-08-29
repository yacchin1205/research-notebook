FROM jupyter/scipy-notebook:latest
MAINTAINER https://twitter.com/yacchin1205

USER root

### Japanese fonts
RUN apt-get update && apt-get install -y fonts-takao && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

### Prepare PIP
RUN conda install --quiet --yes pip && \
    pip install --upgrade -I setuptools

### for Google BigQuery
RUN pip install --upgrade google-api-python-client oauth2client

### for Google DataStore
RUN pip install --upgrade google-cloud-datastore

### for analyzing EEG data
RUN pip install --upgrade mne

### for py-pursuit
RUN pip install git+https://github.com/yacchin1205/py-pursuit.git

### for AutoPrait
RUN git clone https://github.com/abbshr/implement-of-AutoPlait-algorithm.git /tmp/autoplait && \
    cd /tmp/autoplait/codes/autoplait/ && make && \
    mv /tmp/autoplait/codes/autoplait /opt/

### for TensorFlow with Keras
RUN pip install tensorflow keras

### for python-fitbit
RUN git clone https://github.com/orcasgit/python-fitbit /tmp/python-fitbit && \
    cd /tmp/python-fitbit && \
    pip install -r requirements/base.txt && \
    pip install -r requirements/dev.txt && \
    pip install -r requirements/test.txt && \
    python3 setup.py install

### for pymongo
RUN apt-get update && apt-get install -y gnupg2 && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    pip install pymongo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

### for hmmlearn
RUN pip install hmmlearn && conda install --quiet --yes graphviz

### for GPy
RUN pip install gpy

### for basemap
RUN apt-get update && apt-get install -y libgeos-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENV GEOS_DIR=/usr
RUN cd /tmp && wget https://github.com/matplotlib/basemap/archive/v1.2.0rel.tar.gz && \
    tar xf v1.2.0rel.tar.gz && \
    cd /tmp/basemap-1.2.0rel && pip install . pyproj==1.9.6

# extensions for jupyter
## nbextensions_configurator
RUN pip install jupyter_nbextensions_configurator && \
    pip --no-cache-dir install six \
    https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master \
    hide_code \
    git+https://github.com/NII-cloud-operation/Jupyter-i18n_cells.git \
    https://github.com/NII-cloud-operation/Jupyter-LC_run_through/tarball/master \
    git+https://github.com/NII-cloud-operation/Jupyter-multi_outputs \
    git+https://github.com/NII-cloud-operation/Jupyter-LC_index.git

# Utilities
RUN pip install papermill && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install -y google-chrome-stable && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir ansible awscli python-docx \
    git+https://github.com/yacchin1205/convert-eprime.git && \
    apt-get update && apt-get install -y openssh-client openssh-server curl expect && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN conda install -c conda-forge --quiet --yes opencv

# Face Recognition
RUN apt-get -y update && apt-get install -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    software-properties-common \
    zip \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*
RUN cd ~ && \
    mkdir -p dlib && \
    git clone -b 'v19.9' --single-branch https://github.com/davisking/dlib.git dlib/ && \
    cd  dlib/ && \
    python setup.py install --yes USE_AVX_INSTRUCTIONS
RUN pip install face_recognition

# PyMC
RUN pip install pymc pymc3

# Theme for jupyter
ADD conf /tmp/
RUN mkdir /tmp/sample-notebooks
ADD sample-notebooks /tmp/sample-notebooks
RUN chown $NB_USER -R /tmp/sample-notebooks

USER $NB_USER
RUN mkdir -p $HOME/.jupyter/custom/ && \
    cp /tmp/custom.css $HOME/.jupyter/custom/custom.css

RUN mkdir -p $HOME/.ipython/profile_default/startup && \
    cp /tmp/nbnotifier.py $HOME/.ipython/profile_default/startup/nbnotifier.py

RUN mkdir -p $HOME/.local/share && \
    jupyter nbextensions_configurator enable --user && \
    jupyter contrib nbextension install --user && \
    jupyter run-through quick-setup --user && \
    jupyter nbextension install --py lc_multi_outputs --user && \
    jupyter nbextension enable --py lc_multi_outputs --user && \
    jupyter nbextension install --py notebook_index --user && \
    jupyter nbextension enable --py notebook_index --user

RUN mv /tmp/sample-notebooks $HOME/
