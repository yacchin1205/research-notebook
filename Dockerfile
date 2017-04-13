FROM jupyter/scipy-notebook
MAINTAINER https://twitter.com/yacchin1205

USER root
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

### for TensorFlow
RUN pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.0.1-cp35-cp35m-linux_x86_64.whl

### for python-fitbit
RUN git clone https://github.com/orcasgit/python-fitbit /tmp/python-fitbit && \
    cd /tmp/python-fitbit && \
    pip install -r requirements/base.txt && \
    pip install -r requirements/dev.txt && \
    pip install -r requirements/test.txt && \
    python3 setup.py install

# extensions for jupyter
## nbextensions_configurator
RUN pip install jupyter_nbextensions_configurator  six \
    https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master

USER $NB_USER
RUN mkdir -p $HOME/.local/share && \
    jupyter contrib nbextension install --user
