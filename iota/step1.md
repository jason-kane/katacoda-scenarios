Now that we have a SavedModel object stored, the first thing you need to do to convert it to a TensorFlow Lite model is to instantiate the converter:

```
import numpy as np
import os
import pathlib
import matplotlib.pylab as plt
import tensorflow as tf
import tensorflow_hub as hub
import tensorflow_datasets as tfds
tfds.disable_progress_bar()
from tqdm import tqdm
AUTOTUNE = tf.data.experimental.AUTOTUNE

SAVED_MODEL = "pneumonia_saved_model"
converter = tf.lite.TFLiteConverter.from_saved_model(SAVED_MODEL)
```{{execute}}

Remember we can create a converter from a SavedModel, a ConcreteFunction, or a Keras model!

## Post-Training Quantization on Weights

The simplest form of post-training quantization quantizes weights from floating point to 8 bits of precision. This technique is enabled as an option in the TensorFlow Lite converter. At inference, weights are converted from 8 bits of precision to floating point and computed using floating-point kernels. This conversion is done once and cached to reduce latency.

```
converter.optimizations = [tf.lite.Optimize.DEFAULT]
```{{execute}}

This optimization was done doing a ponderation between optimizing for size and latency. If we wanted to only optimize for size we could do the following:

```
converter.optimizations = [tf.lite.Optimize.OPTIMIZE_FOR_SIZE]
```

Just like that, we could convert our model and it will be quantized:

```
tflite_model = converter.convert()
tflite_model_file = 'converted_model.tflite'

with open(tflite_model_file, "wb") as f:
    f.write(tflite_model)

print('Done quantizing')
```{{execute}}

That was amazingly simple and quick: quantizing a model sounds complex, and is fancy on the backend, but is super easy to implement.

## Checking the Size Reduction

Let's verify that the quantized model is smaller:

```
from pathlib import Path

saved_model = Path(SAVED_MODEL)
full_model_size = sum(f.stat().st_size for f in saved_model.glob('**/*') if f.is_file() )/(1024*1024)
print(f'Full model size {full_model_size} MB')
converted_model = Path(tflite_model_file)
converted_model_size = converted_model.stat().st_size / (1024*1024)
print(f'Converted model size {converted_model_size} MB')


```{{execute}}

We can see that we gained almost 80% in size by one simple quantization. Awesome!