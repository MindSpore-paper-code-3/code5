#!/bin/bash
# Copyright 2022 Huawei Technologies Co., Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================

echo "=============================================================================================================="
echo "Please run the script as: "
echo "bash run_single_train_gpu.sh [DEVICE_ID] [EPOCH_SIZE] [LR] [DATASET] [PRE_TRAINED] [PRE_TRAINED_EPOCH_SIZE]"
echo "for example: bash run_single_train_gpu.sh 0 400 0.025 coco /opt/retinanet-200_7329.ckpt(optional) 200(optional)"
echo "It is better to use absolute path."
echo "================================================================================================================="

if [ $# != 4 ] && [ $# != 6 ]
then
    echo "Usage: bash run_single_train_gpu.sh [DEVICE_ID] [EPOCH_SIZE] [LR] [DATASET] \
[PRE_TRAINED](optional) [PRE_TRAINED_EPOCH_SIZE](optional)"
    exit 1
fi

echo "After running the script, the network runs in the background. The log will be generated in LOGx/log.txt"

export DEVICE_ID=$1
EPOCH_SIZE=$2
LR=$3
DATASET=$4
PRE_TRAINED=$5
PRE_TRAINED_EPOCH_SIZE=$6

rm -rf LOG$1
mkdir ./LOG$1
cp ../*.py ./LOG$1
cp ../*.yaml ./LOG$1
cp -r ../src ./LOG$1
cd ./LOG$1 || exit

echo "start training for device $1"
env > env.log

if [ $# == 4 ]
then
python train.py  \
      --run_platform="GPU" \
      --batch_size=16 \
      --distribute=False  \
      --lr=$LR \
      --dataset=$DATASET \
      --device_num=1  \
      --device_id=$DEVICE_ID  \
      --epoch_size=$EPOCH_SIZE > train_log.txt 2>&1 &
fi

if [ $# == 6 ]
then
  python train.py  \
        --run_platform="GPU" \
        --batch_size=16 \
        --distribute=False  \
        --lr=$LR \
        --dataset=$DATASET \
        --device_num=1  \
        --device_id=$DEVICE_ID  \
        --pre_trained=$PRE_TRAINED \
        --pre_trained_epoch_size=$PRE_TRAINED_EPOCH_SIZE \
        --epoch_size=$EPOCH_SIZE > train_log.txt 2>&1 &
fi
cd ..