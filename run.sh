#!/bin/bash

PRETRAINED_MODELS="$HOME/Public/AI/SpeechAIForgeDocker/models/Spark-TTS-0.5B"
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

docker run -d -it --name spark-tts -p 7861:7860 \
    $DEVICE_RUN \
    --network=${DOCKER_NET} \
    -v ${PRETRAINED_MODELS}:/opt/Spark-TTS/pretrained_models/Spark-TTS-0.5B \
    -v /tmp:/opt/Spark-TTS/example/results \
    spark-tts:latest
:<<'REM'
curl -X POST "http://127.0.0.1:8087/v1/audio/speech"  -H "Content-Type: application/json"  -d '{ "input": "Hello, 中文、日文和英文混合测试。this is a test of the MeloTTS API. 久しぶりです。最近何をしていますか？ CosyVoice迎来全面升级，提供更准、更稳、更快、 更好的语音生成能力。CosyVoice is undergoing a comprehensive upgrade, providing more accurate, stable, faster, and better voice generation capabilities.", "voice": "步非烟女", "response_format": "wav","speed": 1.0 }' --output /tmp/output.wav;mpv /tmp/output.wav
# curl  "http://127.0.0.1:8087/v1/audio/voices" |jq .

REM
