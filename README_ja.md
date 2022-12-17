# People Detection ROS2 Docker

![people_detection_ros2_docker](https://img.shields.io/badge/people_detection_ros2-docker-blue)

[en](./README.md) / ja

これはDockerコンテナ内でpeople_detection_ros2を実行するための環境を提供するリポジトリです。

このリポジトリが依存するパッケージは以下の通りです :
- [dbolya/yolact](https://github.com/dbolya/yolact/tree/master)
- [Rits-Interaction-Laboratory/people_detection_ros2](https://github.com/Rits-Interaction-Laboratory/people_detection_ros2)


## 動作要件

---

- Docker


## ビルド方法

---

依存パッケージの取得 :
```bash
bash startup.sh
```

Docker Imageの作成 :
```bash
docker build -t people_detection_ros2_docker .
```

コンテナの作成 :
```bash
docker run -it --name ${コンテナ名} --gpus all --net host people_detection_ros2_docker:latest
```

## ノードの起動

---

dockerコンテナ内にて以下を実行 :
```bash
bash /run.bash
```