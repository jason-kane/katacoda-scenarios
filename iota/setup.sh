#!/usr/bin/env bash
git clone https://github.com/axel-sirota/getting-started-with-tensorflow-lite.git tflite
cp -R tflite/jupyter_code/pneumonia_saved_model pneumonia_saved_model
cp tflite/jupyter_code/converted_model.tflite converted_model_int8.tflite
python3 -m pip install --no-cache-dir --upgrade pip
python3 -m pip install --no-cache-dir --upgrade -r tflite/requirements.txt
