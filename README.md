# people_detection_ros2_docker

[Shigure](https://github.com/Rits-Interaction-Laboratory/shigure_core)の人物領域検出機能である[people_detection_ros2](https://github.com/Rits-Interaction-Laboratory/people_detection_ros2)のコンテナ環境

## 必要なリポジトリ

---

 - [dbolya/yolact](https://github.com/dbolya/yolact/tree/master)
 - [Rits-Interaction-Laboratory/people_detection_ros2](https://github.com/Rits-Interaction-Laboratory/people_detection_ros2)


## Shigure関連

---

Shigureに関する情報 : https://github.com/Rits-Interaction-Laboratory/shigure_core/wiki


### ソースコード

カメラ映像
- [rs_ros2_python](https://github.com/Rits-Interaction-Laboratory/rs_ros2_python)


人物骨格推定
- [openpose_ros2](https://github.com/Rits-Interaction-Laboratory/openpose_ros2)
    - [openpose_ros2_docker](https://github.com/Rits-Interaction-Laboratory/openpose_ros2_docker)

人物領域推定
- [people_detection_ros2](https://github.com/Rits-Interaction-Laboratory/people_detection_ros2)
  - [people_detection_ros2_docker(本リポジトリ)](https://github.com/Rits-Interaction-Laboratory/people_detection_ros2_docker)

イベント検出
- [shigure_core](https://github.com/Rits-Interaction-Laboratory/shigure_core)


## 導入

---

以下コマンドを実行 : <br>

**people_detection_ros2_dockerのclone** <br>

```
git clone git@github.com:Rits-Interaction-Laboratory/people_detection_ros2_docker.git
```

**people_detection_ros2のclone** <br>

```
cd ~/people_detection_ros2_docker/ros2_ws/src/people_detection_ros2
git clone git@github.com:Rits-Interaction-Laboratory/people_detection_ros2.git
```

## 実行

---

以下コマンドを実行 : <br>

```
# 以下ビルドコマンドは初回および変更時に実行
$ docker build -t people_detection_ros2_docker .

# コンテナに入る
$ docker run -it --gpus all --net host people_detection_ros2_docker:latest

# dockerコンテナ内にて実行
$ bash /run.bash
```
