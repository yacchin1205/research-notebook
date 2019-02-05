# research-notebook [![Build Status](https://travis-ci.org/yacchin1205/research-notebook.svg?branch=master)](https://travis-ci.org/yacchin1205/research-notebook)

My Jupyter notebook for my research...

# How to start the container

To start the notebook server on port 8888, run the following command.
(Set your notebook directory on the host to `/my-notebook-dir-on-host`)

```
$ docker run -d --name jupyter -p 8888:8888 -v /my-notebook-dir-on-host:/home/jovyan yacchin1205/research-notebook
```

