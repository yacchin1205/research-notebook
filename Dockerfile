FROM jupyter/notebook:4.2.0
MAINTAINER https://twitter.com/yacchin1205

### Prepare PIP
RUN pip2 install distribute

### Python2 kernel with matplotlib, etc...
RUN apt-get update && \
    apt-get install -y --no-install-recommends libav-tools \
                 libpng-dev libfreetype6-dev libatlas-base-dev \
                 libopenblas-base libopenblas-dev libjpeg-dev \
                 gfortran libhdf5-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip2 install pandas matplotlib numpy && \
    pip2 install seaborn scipy && \
    pip2 install scikit-learn scikit-image sympy cython patsy \
                 statsmodels cloudpickle dill bokeh h5py

ADD conf/sitecustomize.py /tmp/
RUN cat /tmp/sitecustomize.py >> /usr/lib/python2.7/sitecustomize.py

### for Google BigQuery
RUN pip2 install --upgrade google-api-python-client oauth2client

### for analyzing EEG data
RUN pip2 install --upgrade mne

### for py-pursuit
RUN pip2 install git+https://github.com/yacchin1205/py-pursuit.git