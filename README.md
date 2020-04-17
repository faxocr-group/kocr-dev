# Using Keras via Docker

This directory contains `Dockerfile` to make it easy to get up and running with
Keras via [Docker](http://www.docker.com/).

## Installing Docker

General installation instructions are
[on the Docker site](https://docs.docker.com/installation/), but we give some
quick links here:
* [ubuntu](https://docs.docker.com/installation/ubuntulinux/)

Here is the version I installed.
```
$ docker version
Client: Docker Engine - Community
 Version:           19.03.8
 API version:       1.40
 Go version:        go1.12.17
 Git commit:        afacb8b7f0
 Built:             Wed Mar 11 01:25:46 2020
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.8
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.12.17
  Git commit:       afacb8b7f0
  Built:            Wed Mar 11 01:24:19 2020
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.2.13
  GitCommit:        7ad184331fa3e55e52b890ea95e65ba581ae3429
 runc:
  Version:          1.0.0-rc10
  GitCommit:        dc9208a3303feef5b3839f4323d9beb36df0a9dd
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683
```

## Running the container

For GPU support install NVIDIA drivers (ideally latest) and
[nvidia-docker](https://github.com/NVIDIA/nvidia-docker). Run using

Make image and launch container
```
    $ make bash BACKEND=theano
```   

Training 0-9 images in container.
```
    $ cd ~/code/kocr/learning
    $ THEANO_FLAGS=mode=FAST_RUN,device=cuda0,floatX=float32 python train_cnn.py --train_dirs ../images/numbers/ --test_dirs ../images/samples/
```




