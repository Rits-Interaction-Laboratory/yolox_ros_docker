FROM nvcr.io/nvidia/pytorch:20.10-py3

RUN cat /etc/os-release

ENV DEBIAN_FRONTEND=noninteractive

#RUN apt -y update && apt -y install build-essential libbz2-dev libdb-dev \
#  libreadline-dev libffi-dev libgdbm-dev liblzma-dev \
#  libncursesw5-dev libsqlite3-dev libssl-dev \
#  zlib1g-dev uuid-dev tk-dev wget curl gnupg2 lsb-release locales python3.6 python3-pip
RUN apt -y update && \
    apt -y install \
      curl \
      gnupg2 \
      lsb-release \
      libssl-dev \
      zlib1g-dev \
      libbz2-dev \
      libreadline-dev \
      libsqlite3-dev \
      liblzma-dev \
      python-openssl 

 ENV HOME /root
 ENV PYENV_ROOT $HOME/.pyenv
 ENV PATH $PYENV_ROOT/bin:$PATH
 RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
 RUN echo 'eval "$(pyenv init --path)"' >> ~/.bashrc && \
     eval "$(pyenv init -)"
 RUN CFLAGS=-I/usr/include \
     LDFLAGS=-L/usr/lib \
     env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install -v 3.6.8 && \
     pyenv global 3.6.8

# setup lang
#RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
#ENV LANG en_US.UTF-8

# install ROS2 Dashing
#RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
#  sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list' && \
#  apt update && apt install -y ros-dashing-ros-base python3-colcon-common-extensions && \
#  python3 -m pip install --upgrade pip && python3 -m pip install -U argcomplete

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' && \
    apt update && apt install -y ros-dashing-desktop && \ 
    # python3-colcon-common-extensions && \
    /root/.pyenv/versions/3.6.8/bin/pip install --upgrade pip && pip install -U argcomplete


# install CUDA
#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.1.105-1_amd64.deb && \
#  dpkg -i cuda-repo-ubuntu1804_10.1.105-1_amd64.deb && \
#  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && \
#  apt-get update && apt-get -y install cuda-10-1

# install ROS2 plugin
RUN apt install -y ros-dashing-cv-bridge 


# install python packages
ENV PYTHONPATH /root/.pyenv/versions/3.6.8/lib/python3.6/site-packages/:$PYTHONPATH
RUN /root/.pyenv/versions/3.6.8/bin/pip install cython numpy && \
    /root/.pyenv/versions/3.6.8/bin/pip install opencv-python pycocotools empy lark_parser catkin-pkg colcon-common-extensions
RUN /root/.pyenv/versions/3.6.8/bin/pip install torch==1.8.2+cu111 torchvision==0.9.2+cu111 torchaudio==0.8.2 -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html

COPY ./run.bash /run.bash

# setup yolact
COPY ./yolact /yolact
RUN cd /yolact && \
    git clone https://github.com/dbolya/yolact.git
RUN mkdir -p /yolact/yolact/weights
COPY /settings/model_dl.sh /yolact/yolact/weights/model_dl.sh
RUN cd /yolact/yolact/weights && \ 
    sh model_dl.sh
COPY /settings/change_yolact_path.sh /change_yolact_path.sh
RUN sh /change_yolact_path.sh
ENV PYTHONPATH /yolact:$PYTHONPATH

# setup people_detection_ros2
COPY ./ros2_ws /ros2_ws
COPY ./params.yml /params.yml
RUN rm -rf /opt/conda 
RUN . /opt/ros/dashing/setup.sh && cd /ros2_ws  && /bin/bash -c "/root/.pyenv/versions/3.6.8/bin/python3 -m colcon build --base-paths src/people_detection_ros2" && \
    echo "# ROS2 Settings" >> ~/.bashrc && \
    . install/setup.sh && echo "source /opt/ros/dashing/setup.bash" >> ~/.bashrc && \
    echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

# install powerline-shell
RUN /root/.pyenv/versions/3.6.8/bin/pip install powerline-shell
RUN mkdir -p /root/Programs/Settings && \
    touch /root/Programs/Settings/powerlineSetup_CRLF.txt && \
    touch /root/Programs/Settings/powerlineSetup.txt 
COPY settings/powerline/powerlineSetup.txt /root/Programs/Settings/powerlineSetup_CRLF.txt
RUN sed "s/\r//g" /root/Programs/Settings/powerlineSetup_CRLF.txt > /root/Programs/Settings/powerlineSetup.txt && \
    cat /root/Programs/Settings/powerlineSetup.txt >> /root/.bashrc
RUN mkdir -p /root/.config/powerline-shell 
COPY settings/powerline/config.json /root/.config/powerline-shell/config.json

CMD ["/bin/bash"]
