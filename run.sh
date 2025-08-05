#!/bin/bash

PRETRAINED_MODELS="$PWD/pretrained_models/Spark-TTS-0.5B"
# 检查专属网络是否创建
DOCKER_NET=openwebui-net
docker network ls --format '{{.Name}}' | grep "${DOCKER_NET}"
if [ $? -ne 0 ]; then
    docker network create ${DOCKER_NET}
fi

# 宿主机是否有 nvidia GPU
which nvidia-smi
if [ $? -eq 0 ]; then #有gpu支持
    NV_GPU=1
else
    NV_GPU=0
fi

if [ $NV_GPU -eq 1 ]; then #有gpu支持
  DEVICE_RUN=" --gpus all"
else
  DEVICE_RUN=" -e CUDA_ENABLED=false "
fi

docker run -d -it --name spark-tts -p 7860:7860 \
    $DEVICE_RUN \
    --network=${DOCKER_NET} \
    -v ${PRETRAINED_MODELS}:/opt/Spark-TTS/pretrained_models/Spark-TTS-0.5B \
    -v /tmp:/opt/Spark-TTS/example/results \
    spark-tts:latest
:<<'REM'


REM
