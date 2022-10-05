FROM nvcr.io/nvidia/pytorch:21.10-py3
RUN cat /etc/os-release
ENV DEBIAN_FRONTEND=noninteractive


# -----Choose ROS & ROS2 distributions-----
ENV ROS2_DISTRO foxy


# -----Installation of frequently used apt-get packages-----
RUN apt-get -y update && \
    apt-get -y install \
      curl \
      vim \
      gnupg2 \
      lsb-release \
      libssl-dev \
      zlib1g-dev \
      libbz2-dev \
      libffi-dev \
      libreadline-dev \
      libsqlite3-dev \
      liblzma-dev \
      python-openssl \
      gcc


# -----Prepare pip environment-----
 ENV HOME /root
 ENV PYENV_ROOT $HOME/.pyenv
 ENV PATH $PYENV_ROOT/bin:$PATH
 RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
 RUN echo 'eval "$(pyenv init --path)"' >> ~/.bashrc && \
     eval "$(pyenv init -)"
 RUN CFLAGS=-I/usr/include \
     LDFLAGS=-L/usr/lib \
     env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install -v 3.8.12 && \
     pyenv global 3.8.12


# -----Install ROS2-----
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && \
    sh -c 'echo "deb [arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list' && \
    apt-get update && apt-get install -y ros-$ROS2_DISTRO-desktop && \ 
    # python3-colcon-common-extensions && \
    /root/.pyenv/versions/3.8.12/bin/pip install --upgrade pip && pip install -U argcomplete


# -----Install ROS2 plugin-----
RUN apt-get install -y ros-$ROS2_DISTRO-cv-bridge


# -----Install python packages-----
ENV PYTHONPATH /root/.pyenv/versions/3.8.12/lib/python3.8/site-packages/:$PYTHONPATH
RUN apt-get -y update && \
    apt-get -y install python3.8-dev
RUN /root/.pyenv/versions/3.8.12/bin/pip install cython numpy && \
    /root/.pyenv/versions/3.8.12/bin/pip install opencv-python pillow pycocotools empy lark_parser catkin-pkg colcon-common-extensions
RUN /root/.pyenv/versions/3.8.12/bin/pip install torch==1.8.2+cu111 torchvision==0.9.2+cu111 torchaudio==0.8.2 -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html
COPY ./run.bash /run.bash


# -----Setup yolact-----
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


# -----Setup people_detection_ros2-----
COPY ./ros2_ws /ros2_ws
COPY ./params.yml /params.yml
RUN rm -rf /opt/conda 
RUN . /opt/ros/$ROS2_DISTRO/setup.sh && cd /ros2_ws  && /bin/bash -c "/root/.pyenv/versions/3.8.12/bin/python3 -m colcon build --base-paths src/people_detection_ros2" && \
    echo "# ROS2 Settings" >> ~/.bashrc && \
    . install/setup.sh && echo "source /opt/ros/$ROS2_DISTRO/setup.bash" >> ~/.bashrc && \
    echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc


# -----Personal ROS settings-----
RUN echo "-----Personal ROS settings-----"
RUN mkdir -p /root/Programs/Settings
COPY settings/ros/.ros_config /.ros_config
COPY settings/ros/rosSetup.txt  /root/Programs/Settings/rosSetup_CRLF.txt
RUN sed "s/\r//g" /root/Programs/Settings/rosSetup_CRLF.txt > /root/Programs/Settings/rosSetup.txt && \
    cat /root/Programs/Settings/rosSetup.txt >> /root/.bashrc && \
    echo "" >> /root/.bashrc


# -----Install powerline-shell-----
RUN /root/.pyenv/versions/3.8.12/bin/pip install powerline-shell
RUN mkdir -p /root/Programs/Settings && \
    touch /root/Programs/Settings/powerlineSetup_CRLF.txt && \
    touch /root/Programs/Settings/powerlineSetup.txt 
COPY settings/powerline/powerlineSetup.txt /root/Programs/Settings/powerlineSetup_CRLF.txt
RUN sed "s/\r//g" /root/Programs/Settings/powerlineSetup_CRLF.txt > /root/Programs/Settings/powerlineSetup.txt && \
    cat /root/Programs/Settings/powerlineSetup.txt >> /root/.bashrc
RUN mkdir -p /root/.config/powerline-shell 
COPY settings/powerline/config.json /root/.config/powerline-shell/config.json


# -----Start setting-----
CMD ["/bin/bash"]
