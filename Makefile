help:
	@cat Makefile

DATA?="${HOME}/Data"
DEVICES?=--gpus=all
DOCKER_FILE=Dockerfile
DOCKER=docker
BACKEND?=theano
PYTHON_VERSION?=3.6
CUDA_VERSION?=10.1
CUDNN_VERSION?=7
THEANO_VERSION?=1.0.4
TEST=tests/
SRC?=$(shell dirname `pwd`)


build:
	$(DOCKER) build -t keras --build-arg python_version=$(PYTHON_VERSION) --build-arg cuda_version=$(CUDA_VERSION) --build-arg cudnn_version=$(CUDNN_VERSION) --build-arg theano_version=$(THEANO_VERSION) -f $(DOCKER_FILE) .

bash: build
	$(DOCKER) run \
        -it $(DEVICES) -v $(SRC):/src/workspace -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras bash

ipython: build
	$(DOCKER) run $(DEVICES) $(CUDA_LIB) $(CUDA_SO) -it -v $(SRC):/src/workspace -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras ipython

notebook: build
	$(DOCKER) run $(DEVICES) $(CUDA_LIB) $(CUDA_SO) -it -v $(SRC):/src/workspace -v $(DATA):/data --net=host --env KERAS_BACKEND=$(BACKEND) keras

test: build
	$(DOCKER) run $(DEVICES) $(CUDA_LIB) $(CUDA_SO) -it -v $(SRC):/src/workspace -v $(DATA):/data --env KERAS_BACKEND=$(BACKEND) keras py.test $(TEST)

