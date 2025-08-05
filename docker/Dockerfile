FROM pytorch/pytorch:2.7.1-cuda12.8-cudnn9-runtime
#python 3.11

ARG PYTORCH_VERSION=v2.7.1
ARG UID=1000
ARG ARG_USER_NAME=webui
ARG VENV_NAME="sparktts"
ARG HF_ENDPOINT=https://hf-mirror.com
ARG HUGGINGFACE_MODEL="SparkAudio/Spark-TTS-0.5B"

ENV HF_ENDPOINT=${HF_ENDPOINT}
ENV USER=$ARG_USER_NAME
ENV VENV=$VENV_NAME
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

ENV DEBIAN_FRONTEN=noninteractive
ENV PYTHONUNBUFFERED=1
SHELL ["/bin/bash", "--login", "-c"]
ENV TZ=Asia/Shanghai
# 更新并安装需要的程序
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    sed -i -e 's#archive.ubuntu.com#mirrors.ustc.edu.cn#g' -e 's#security.ubuntu.com#mirrors.ustc.edu.cn#g' /etc/apt/sources.list \
    && apt-get update -y --fix-missing \
    && apt-get install -y git build-essential curl wget ffmpeg unzip git git-lfs sox libsox-dev tar bash vim rubberband-cli \
    ca-certificates cmake libasound-dev \
    portaudio19-dev libportaudio2 libportaudiocpp0 \
    && DEBIAN_FRONTEND=noninteractive apt install -y tzdata \
    && apt-get clean && git lfs install && git config --global --add safe.directory '*' \
    && python -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple && useradd -l -u $UID -U -m -s /bin/bash ${USER}

ENV CONDA_DEFAULT_ENV=${VENV}
ENV PATH=/opt/conda/bin:/opt/conda/envs/${VENV}/bin:$PATH

WORKDIR /opt/Spark-TTS
# Copy the requirements file for Python dependencies
COPY ./docker/requirements.txt ./docker/
# Install Python dependencies using aliyun's PyPI mirror and clean up cache to reduce image size
RUN --mount=type=cache,target=/root/.cache/pip  \
  python -m pip install --no-cache-dir -r docker/requirements.txt -i https://mirrors.aliyun.com/pypi/simple
COPY ./docker/ ./docker
COPY ./Spark-TTS/ .
RUN rm -rf /root/.cache/pip && conda clean --all && chown -R ${USER}:${USER} /opt/Spark-TTS && chmod +x ./docker/entrypoint.sh \
  && sed -i -e 's#"https://huggingface.co#"https://hf-mirror.com#g' /opt/conda/lib/python3.1*/site-packages/huggingface_hub/constants.py 

#COPY ./pretrained_models/ /opt/Spark-TTS/pretrained_models

USER ${USER}
ENV HOME=/home/${USER}
WORKDIR $HOME

RUN /opt/conda/bin/python3.11 -m venv  --system-site-packages ${VENV} \
 && echo "source $HOME/${VENV}/bin/activate" >> ${HOME}/.bashrc && source $HOME/${VENV}/bin/activate
# && bash ./docker/patch.sh
ENV LD_LIBRARY_PATH=/opt/conda/lib/python3.11/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH
# ENV NLTK_DATA=/app/Speech-AI-Forge/models/nltk_data
WORKDIR /opt/Spark-TTS
ENV GRADIO_SERVER_NAME="0.0.0.0"
EXPOSE 7860 8080
ENTRYPOINT ["./docker/entrypoint.sh"]

