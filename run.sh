#!/bin/bash

# Location to save the MSCOCO data.
MSCOCO_DIR="${HOME}/im2txt/data/mscoco"

# Build the preprocessing script.
cd research/im2txt
bazel build //im2txt:download_and_preprocess_mscoco

# Run the preprocessing script.
bazel-bin/im2txt/download_and_preprocess_mscoco "${MSCOCO_DIR}"






# Location to save the Inception v3 checkpoint.
INCEPTION_DIR="${HOME}/im2txt/data"
mkdir -p ${INCEPTION_DIR}

wget "http://download.tensorflow.org/models/inception_v3_2016_08_28.tar.gz"
tar -xvf "inception_v3_2016_08_28.tar.gz" -C ${INCEPTION_DIR}
rm "inception_v3_2016_08_28.tar.gz"


# Directory containing preprocessed MSCOCO data.
MSCOCO_DIR="${HOME}/im2txt/data/mscoco"

# Inception v3 checkpoint file.
INCEPTION_CHECKPOINT="${HOME}/im2txt/data/inception_v3.ckpt"

# Directory to save the model.
MODEL_DIR="${HOME}/im2txt/model"

# Build the model.
cd research/im2txt
bazel build -c opt //im2txt/...

# Run the training script.
bazel-bin/im2txt/train \
  --input_file_pattern="${MSCOCO_DIR}/train-?????-of-00256" \
  --inception_checkpoint_file="${INCEPTION_CHECKPOINT}" \
  --train_dir="${MODEL_DIR}/train" \
  --train_inception=false \
  --number_of_steps=1000000







MSCOCO_DIR="${HOME}/im2txt/data/mscoco"
MODEL_DIR="${HOME}/im2txt/model"

# Ignore GPU devices (only necessary if your GPU is currently memory
# constrained, for example, by running the training script).
export CUDA_VISIBLE_DEVICES=""

# Run the evaluation script. This will run in a loop, periodically loading the
# latest model checkpoint file and computing evaluation metrics.
bazel-bin/im2txt/evaluate \
  --input_file_pattern="${MSCOCO_DIR}/val-?????-of-00004" \
  --checkpoint_dir="${MODEL_DIR}/train" \
  --eval_dir="${MODEL_DIR}/eval"







MODEL_DIR="${HOME}/im2txt/model"

# Run a TensorBoard server.
tensorboard --logdir="${MODEL_DIR}"


# Restart the training script with --train_inception=true.
bazel-bin/im2txt/train \
  --input_file_pattern="${MSCOCO_DIR}/train-?????-of-00256" \
  --train_dir="${MODEL_DIR}/train" \
  --train_inception=true \
  --number_of_steps=3000000  # Additional 2M steps (assuming 1M in initial training).