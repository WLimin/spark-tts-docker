# spark-tts-docker

docker 镜像，提供[Spark-TTS](https://github.com/SparkAudio/Spark-TTS)的 webui.py 支持。容器外本地卷存放模型文件。
## 下载模型到 pretrained_models/Spark-TTS-0.5B 路径。
`bash
echo "Download SparkAudio/Spark-TTS-0.5B..."
MODEL_REPO_URL="https://hf-mirror.com"
MODEL_REPO_ID="SparkAudio/Spark-TTS-0.5B"
LOCAL_BASE_DIR="Spark-TTS-0.5B"
MOOD_ZOOM="pretrained_models"
REQUIRED_FILES=( "BiCodec/config.yaml" "BiCodec/model.safetensors" "config.yaml" "LLM/added_tokens.json" "LLM/config.json" "LLM/merges.txt" \
 "LLM/model.safetensors" "LLM/special_tokens_map.json" "LLM/tokenizer_config.json" "LLM/tokenizer.json" "LLM/vocab.json" "README.md" \
 "wav2vec2-large-xlsr-53/config.json" "wav2vec2-large-xlsr-53/preprocessor_config.json" "wav2vec2-large-xlsr-53/pytorch_model.bin" \
 "wav2vec2-large-xlsr-53/README.md" )
MAIN="main"
mkdir -p ${MOOD_ZOOM}/${LOCAL_BASE_DIR}/
REQUIRED_URL="${MODEL_REPO_URL}/${MODEL_REPO_ID}/resolve/${MAIN}"
for Required_File in ${REQUIRED_FILES[@]}; do
    wget -c ${REQUIRED_URL}/${Required_File} -O ${MOOD_ZOOM}/${LOCAL_BASE_DIR}/${Required_File}
done
`
## 构建模型镜像
./build.sh

## 运行容器

./run.sh

打开 http://localhost:7860/。
