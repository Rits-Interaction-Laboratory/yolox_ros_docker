# YOLOX-ROS Docker

![people_detection_docker](https://img.shields.io/badge/people_detection_ros2-docker-blue)

en / [ja](./README_ja.md)

This repository provides an environment for running people_detection_ros2 in a Docker container.

The following packages this repository depends on :
- [dbolya/yolact](https://github.com/dbolya/yolact/tree/master)
- [Rits-Interaction-Laboratory/people_detection_ros2](https://github.com/Rits-Interaction-Laboratory/people_detection_ros2)
- [Rits-Interaction-Laboratory/shigure_tools](https://github.com/Rits-Interaction-Laboratory/shigure_tools)


## Required

---

- Docker


## Building

---

Getting Dependent Packages :
```bash
bash startup.sh
```

Creating Docker Image :
```bash
docker build -t people_detection_ros2_docker .
```

Creating Docker container :
```bash
docker run -it --name ${container name} --gpus all --net host people_detection_ros2_docker:latest
```

## Run node

---

Run the following in the docker container :
```bash
bash /run.bash
```
