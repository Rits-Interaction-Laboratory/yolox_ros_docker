# YOLOX-ROS Docker

![people_detection_docker](https://img.shields.io/badge/people_detection_ros2-docker-blue)

en / [ja](./README_ja.md)

This repository provides an environment for running people_detection_ros2 in a Docker container.

The following packages this repository depends on :
- [dbolya/yolact](https://github.com/dbolya/yolact/tree/master)
- [Megvii-BaseDetection/YOLOX](https://github.com/Megvii-BaseDetection/YOLOX.git)
- [Ar-Ray-code/YOLOX-ROS](https://github.com/Ar-Ray-code/YOLOX-ROS.git)
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
docker build -t yolox_ros_docker .
```

Creating Docker container :
```bash
docker run -it --name ${container name} --gpus all --net host yolox_ros_docker:latest
```

## After creating container

---

```bash
source /opt/ros/foxy/setup.bash
cd /ros2_ws
colcon build
. ./install/setup.bash
```

**Setting Weights**
- File Location:Z:/aarimoto/best_ckpt1.zip
- Put the weight in /ros2/src/yolox_ros/weights


## If you get an error message "TypeError: __init__() got an unexpected keyword argument 'encoding'"

---

- Go to directory
```bash
cd /opt/ros/foxy/share/ament_cmake_core/cmake/core
```
- Open File "package_xml_2_cmake.py"
```bash
vi package_xml_2_cmake.py
```
- Change **type=argparse.FileType('r', encoding='utf-8')** to **type=argparse.FileType('r')**



## Run node

---

Run the yolox-ros :
```bash
ros2 launch yolox_ros_py yolox_nano_torch_gpu_camera.launch.py
```
