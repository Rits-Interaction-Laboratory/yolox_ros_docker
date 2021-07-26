FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt -y update && apt -y install build-essential libbz2-dev libdb-dev \
  libreadline-dev libffi-dev libgdbm-dev liblzma-dev \
  libncursesw5-dev libsqlite3-dev libssl-dev \
  zlib1g-dev uuid-dev tk-dev wget curl gnupg2 lsb-release locales python3.6 python3-pip

# setup lang
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# install ROS2 Dashing
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
  sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list' && \
  apt update && apt install -y ros-dashing-ros-base python3-colcon-common-extensions && \
  python3 -m pip install --upgrade pip && python3 -m pip install -U argcomplete

# install CUDA
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.1.105-1_amd64.deb && \
  dpkg -i cuda-repo-ubuntu1804_10.1.105-1_amd64.deb && \
  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub && \
  apt-get update && apt-get -y install cuda-10-1

# install ROS2 plugin
RUN apt install -y ros-dashing-cv-bridge

# install python packages
RUN python3 -m pip install torch==1.7.1+cu101 torchvision==0.8.2+cu101 torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html && \
  python3 -m pip install cython numpy opencv-python pycocotools empy lark_parser

COPY ./run.bash run.bash

# setup yolact
COPY ./yolact yolact
ENV PYTHONPATH /yolact:$PYTHONPATH

# setup people_detection_ros2
COPY ./ros2_ws ros2_ws
COPY ./params.yml params.yml
RUN . /opt/ros/dashing/setup.sh && cd ros2_ws && colcon build --base-paths src/people_detection_ros2 && \
  . install/setup.sh && echo "source /opt/ros/dashing/setup.bash" >> ~/.bashrc && \
  echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

CMD ["/bin/bash"]
