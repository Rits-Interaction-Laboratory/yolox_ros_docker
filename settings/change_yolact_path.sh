# target files
config_F="/yolact/yolact/data/config.py"

detection_F="/yolact/yolact/layers/functions/detection.py"
multibox_loss_F="/yolact/yolact/layers/modules/multibox_loss.py"
box_utils_F="/yolact/yolact/layers/box_utils.py"
output_utils_F="/yolact/yolact/layers/output_utils.py"

augmentations_F="/yolact/yolact/utils/augmentations.py"
functions_F="/yolact/yolact/utils/functions.py"

yolact_F="/yolact/yolact/yolact.py"

# change path name 
## data/config.py, yolact.py
sed -i 's/from backbone/from yolact.backbone/g' ${config_F} ${yolact_F}

## layers/functions/detection.py, layers/box_utils.py, layers/output_utils.py, yolact.py
sed -i 's/from utils/from yolact.utils/g' ${detection_F} ${box_utils_F} ${output_utils_F} ${yolact_F}

## layers/functions/detection.py, layers/modeles/multibox_loss.py, layers/box_utils.py, layers/output_utils.py, utils/augmentations.py, yolact.py
sed -i 's/from data/from yolact.data/g' ${detection_F} ${multibox_loss_F} ${box_utils_F} ${output_utils_F} ${augmentations_F} ${yolact_F}

## utils/functions.py, yolact.py
sed -i 's/from layers/from yolact.layers/g' ${functions_F} ${yolact_F}