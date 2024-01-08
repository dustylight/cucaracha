FROM ubuntu:23.04

# skip disruptive prompting
ENV DEBIAN_FRONTEND=noninteractive

# ubuntu additional packages
RUN apt-get update && apt-get install -y locales curl wget vim sudo file git nodejs
RUN locale-gen en_US.UTF-8

# nvidia drivers
RUN apt-get install -y build-essential gcc dirmngr ca-certificates software-properties-common apt-transport-https dkms && \
  curl -fSsL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub | gpg --dearmor | tee /usr/share/keyrings/nvidia-drivers.gpg > /dev/null 2>&1 && \
  echo 'deb [signed-by=/usr/share/keyrings/nvidia-drivers.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /' | tee /etc/apt/sources.list.d/nvidia-drivers.list && \
  apt-get update && apt-get install -y cuda-drivers-535 

# python
RUN apt-get install -y python3 python3-pip python3-venv

# mecab
RUN apt-get install -y mecab libmecab-dev mecab-ipadic-utf8 unidic-mecab && \
  git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && cd ./mecab-ipadic-neologd && \
  ./bin/install-mecab-ipadic-neologd -n -y && cd - && rm -rf /usr/src/mecab-ipadic-neologd
RUN echo 'dicdir = /usr/lib/aarch64-linux-gnu/mecab/dic/mecab-ipadic-neologd' > /usr/local/etc/mecabrc

# juman++
RUN apt-get update && apt-get install -y libboost-all-dev && wget http://lotus.kuee.kyoto-u.ac.jp/nl-resource/jumanpp/jumanpp-1.02.tar.xz && tar -xf jumanpp-1.02.tar.xz && cd ./jumanpp-1.02 && ./configure && make && make install && cd ../ && wget http://www.phontron.com/kytea/download/kytea-0.4.7.tar.gz && tar -xzf kytea-0.4.7.tar.gz && cd ./kytea-0.4.7 && ./configure && make && make install && cd ../ && rm -rf jumanpp-1.02* kytea-0.4.7*
 
# some cleaning
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# add user 'venus'
RUN groupadd -g 1001 venus && useradd -u 1001 -g venus -m -s /usr/bin/bash venus && echo 'venus ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/venus

# create some folders for venus
RUN mkdir /opt/venv /opt/workspace && chown venus:venus /opt/venv /opt/workspace

# copy some files
COPY requirements.txt run.sh /

# user is now 'venus'
USER venus
WORKDIR /home/venus

# venv
RUN python3 -m venv /opt/venv && . /opt/venv/bin/activate && pip install --no-cache-dir --upgrade pip setuptools wheel \
  jupyterlab jupyterlab-vim jupyterlab_code_formatter jupyterlab-git lckr-jupyterlab-variableinspector jupyterlab-widgets ipywidgets import-ipynb \
  -r /requirements.txt

# rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && . ~/.cargo/env

# spacy dics
RUN python -m spavy download ja_core_news_sm ja_core_news_md

# port
EXPOSE 8888

# env
ENV SHELL=/usr/bin/bash

# start jupyterlab
CMD ["/run.sh"]

# EOF
