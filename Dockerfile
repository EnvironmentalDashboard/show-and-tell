FROM ubuntu:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    git \
    python \
    python-pip \
    python-setuptools

RUN pip install tf-nightly

# Checkout tensorflow/models at HEAD
RUN git clone https://github.com/tensorflow/models.git /tensorflow_models

# install  bazel
RUN apt-get install -y --no-install-recommends pkg-config zip zlib1g-dev unzip curl && \
		curl -OL https://github.com/bazelbuild/bazel/releases/download/0.19.2/bazel-0.19.2-installer-linux-x86_64.sh && \
		chmod +x bazel-0.19.2-installer-linux-x86_64.sh && \
		./bazel-0.19.2-installer-linux-x86_64.sh --user && \
		pip install nltk && \
		python -m nltk.downloader -d /usr/local/share/nltk_data all

#RUN /root/bin/bazel build //im2txt:download_and_preprocess_mscoco &&	/tensorflow_models/research/im2txt/im2txt/data/download_and_preprocess_mscoco.sh

ADD . /src

CMD /src/test.py
