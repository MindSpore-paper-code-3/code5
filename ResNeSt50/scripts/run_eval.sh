#!/bin/bash
# Copyright 2021 Huawei Technologies Co., Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================

if [ $# != 2 ]
then
    echo "Usage: bash run_eval.sh [OUT_DIR] [RESUME_PATH]"
    exit 1
fi

out_dir=$1
resume_path=$2

cores=`cat /proc/cpuinfo|grep "processor" |wc -l`
echo "The number of logical core" $cores

export DEVICE_ID=0
export RANK_ID=0
export RANK_SIZE=1

rm -rf EVAL_LOG
mkdir ./EVAL_LOG
cd ./EVAL_LOG || exit
echo "Start testing for rank 0, device 0, directory is EVAL_LOG"

env > env.log
cd ../../

python eval.py  \
--outdir $out_dir \
--resume_path $resume_path > ./scripts/EVAL_LOG/log.txt 2>&1 &
