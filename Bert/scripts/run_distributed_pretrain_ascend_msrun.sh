#!/bin/bash
# Copyright 2024 Huawei Technologies Co., Ltd
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

echo "=============================================================================================================="
echo "Please run the script as: "
echo "bash run_distributed_pretrain_ascend_msrun.sh DATA_DIR"
echo "for example: bash run_distributed_pretrain_ascend_msrun.sh /path/dataset"
echo "It is better to use absolute path."
echo "=============================================================================================================="
export RANK_SIZE=8
export DEPLOY_MODE=0
export GE_USE_STATIC_MEMORY=1
ulimit -s 302400
cd ..
msrun --bind_core=True --worker_num=8 --local_worker_num=8 \
      --master_port=8118 --log_dir=msrun_log --join=True --cluster_time_out=300 \
      run_pretrain.py --data_dir=$1 --distribute=true --epoch_size=40 \
      --enable_save_ckpt=true --do_shuffle=true --enable_data_sink=true \
      --data_sink_steps=100 --accumulation_steps=1 --allreduce_post_accumulation=true \
      --save_checkpoint_path=./ckpt --save_checkpoint_num=1 --config_path=../../pretrain_config.yaml &> log.txt &
