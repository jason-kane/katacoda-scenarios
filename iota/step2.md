We can get further latency improvements, reductions in peak memory usage, and access to integer-only hardware accelerators by making sure all model math is quantized. To do this, we need to measure the dynamic range of activations and inputs with a representative dataset. So you'll simply create an input data generator and provide it to your converter:

To do this, first, let's bring back our test dataset:

```

def get_label(file_path):
  parts = tf.strings.split(file_path, os.path.sep)
  return parts[-2] == CLASS_NAMES[0]

@tf.autograph.experimental.do_not_convert
def decode_img(img):
  img = tf.image.decode_jpeg(img, channels=3)
  img = tf.image.convert_image_dtype(img, tf.float32)
  return tf.image.resize(img, [IMG_WIDTH, IMG_HEIGHT])

@tf.autograph.experimental.do_not_convert
def process_path(file_path):
  label = get_label(file_path)
  img = tf.io.read_file(file_path)
  img = decode_img(img)
  return img, label

def format_image(image, label):
    image = tf.image.resize(image, IMAGE_SIZE) / 255.0
    return  image, label

def prepare_for_training(ds, cache=True, shuffle_buffer_size=1000):
    if cache:
        if isinstance(cache, str):
            ds = ds.cache(cache)
        else:
            ds = ds.cache()
    ds = ds.shuffle(buffer_size=shuffle_buffer_size)
    ds = ds.repeat()
    ds = ds.batch(BATCH_SIZE)
    ds = ds.prefetch(buffer_size=AUTOTUNE)
    return ds

data_dir = pathlib.Path('tflite/images')
BATCH_SIZE = 32
IMG_HEIGHT = 224
IMG_WIDTH = 224
IMG_SHAPE = (IMG_HEIGHT, IMG_WIDTH, 3)
CLASS_NAMES = np.array([item.name for item in data_dir.glob('train/*') if item.name != "LICENSE.txt"])
test_ds = tf.data.Dataset.list_files(str(data_dir/'test/*/*'))
test_examples = test_ds.map(process_path, num_parallel_calls=AUTOTUNE)
test_examples_dataset = prepare_for_training(test_examples)
```{{execute}}

And now, let's define the representative dataset. This will be set to the converter to perform some inferences as it quantizes, to maintain as much precision as possible while also converting all possible weights and activations to INT8:

```
def representative_data_gen():
    for image_batch, label_batch in test_examples_dataset.take(1):
        for image in image_batch:
            yield [[image]]

len(list(representative_data_gen()))
converter.representative_dataset = representative_data_gen

```{{execute}}

The resulting model will be fully quantized but still take float input and output for convenience.

Ops that do not have quantized implementations will automatically be left in floating point. This allows conversion to occur smoothly but may restrict deployment to accelerators that support float.

### Full-Integer Quantization (Optional)

To require the converter to only output integer operations, one can specify:

```
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
```{{execute}}

However, bear in mind that if the converter cannot find a supported INT8-compatible op with your model, it *will fail*. This step is usually optional but in some cases, as when deploying to TPUs, it's required since that hardware *only* supports INT8 operations.

## Converting and Verifying the Model

Finally, let's convert our model (for performance reasons we won't run it, but feel free to try it out on your sandbox):

```
tflite_model = converter.convert()
tflite_model_file = 'converted_model_int8.tflite'

with open(tflite_model_file, "wb") as f:
    f.write(tflite_model)

print('Done quantizing with Representative Dataset')
```

## Comparing the Sizes

You would think that the new converted model is smaller, but that is not always the case. The conversion to INT8 operations is focused heavily on memory requirements and speed: 

```
from pathlib import Path

quantized_weights = Path('converted_model.tflite')
weights_quantized_size = quantized_weights.stat().st_size/(1024*1024)
print(f'Quantized for weights model size {weights_quantized_size} MB')

weights_and_activations_model = Path('converted_model_int8.tflite')
weights_and_activations_model_size = weights_and_activations_model.stat().st_size/(1024*1024)
print(f'Quantized for weights and activations size {weights_and_activations_model_size} MB')


```{{execute}}

And we can see that both sizes are similar. In the next step, we'll cover what happens with speed!