# people_detection_ros2_docker

このリポジトリは2つの外部リポジトリに依存しています <br>
 - [dbolya/yolact](https://github.com/dbolya/yolact/tree/master)
 - [Rits-Interaction-Laboratory/people_detection_ros2](https://github.com/Rits-Interaction-Laboratory/people_detection_ros2)

## 導入

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

**yolactのclone** <br>

```
cd ~/people_detection_ros2_docker/yolact
git clone git@github.com:dbolya/yolact.git
```

### yolactの設定

**重みファイルの作成** <br>

```
cd ~/people_detection_ros2_docker/yolact/yolact
mkdir weights
# ダウンロードしてきた yolact_darknet53_54_800000.pth をweights直下に配置
```

**import時のpath変更** <br>

`from data.config import cfg, mask_type` <br>
のようになっている部分を <br>
`from yolact.data.config import cfg, mask_type` <br>
といったように先頭に `yolact` をつける必要がある <br>
変更対象ファイルは以下の通り : <br>

```
data/config.py

layers/functions/detection.py
layers/modeles/multibox_loss.py
layers/box_utils.py
layers/output_utils.py

utils/augmentations.py
utils/functions.py

yolact.py
```

## 実行

以下コマンドを実行 : <br>

```
# 以下ビルドコマンドは初回および変更時に実行
$ docker build -t people_detection_ros2_docker .

# コンテナに入る
$ docker run -it --gpus all --net host people_detection_ros2_docker

# dockerコンテナ内にて実行
$ bash /run.bash
```

## その他

2021/07/26 rubidium内よりアップロード
