Now that we have our quantized models, we can test them and check their accuracy!

First, let's load the weights quantized model. For this, we need to allocate the tensors for predictions:

```

weights_tflite_model_file = 'converted_model.tflite'

interpreter = tf.lite.Interpreter(model_path=weights_tflite_model_file)
interpreter.allocate_tensors()

input_index = interpreter.get_input_details()[0]["index"]
output_index = interpreter.get_output_details()[0]["index"]
```{{execute}}

Now, let's do a simple batch of 15 images (for performance reasons), and iterate to check its metrics: 

```
import time
start_time = time.time()
predictions = []

test_labels, test_imgs = [], []
debug = 0
image_batch, label_batch = next(iter(test_examples_dataset))
for img, label in zip(image_batch, label_batch):
    debug += 1
    if debug % 5 == 1:
        print(f'I am treating image {debug} with label {label}')
    if debug == 15:
        break
    interpreter.set_tensor(input_index, np.array([img]))
    interpreter.invoke()
    predictions.append(interpreter.get_tensor(output_index))
    test_labels.append(label.numpy())
    test_imgs.append(img)


print(f'Predictions calculated in {time.time() - start_time} seconds')
```{{execute}}

We now have all the predictions. Let's calculate accuracy, sensitivity, and specificity:

```
ok_value = 0
wrong_value = 0
true_positives = 0
total = 0
true_negatives = 0
false_positives = 0
false_negatives = 0
for predictions_array, true_label in zip(predictions, test_labels):
    predicted_label = np.argmax(predictions_array)
    if predicted_label == true_label:
        ok_value += 1
        if CLASS_NAMES[int(true_label)] == 'NORMAL':
            true_negatives += 1
        else:
            true_positives += 1
    else:
        wrong_value += 1
        if CLASS_NAMES[predicted_label] == 'NORMAL':
            false_negatives +=1
        else:
            false_positives += 1
    total += 1


print(f'Accuracy: {(true_positives + true_negatives) / total} \n ')
print(f'Sensitivity: {true_positives/ (true_positives + false_negatives)} \n ')
print(f'Specificity: {true_negatives / (true_negatives + false_positives)}')

```{{execute}}

Our model is very good: it probably could be improved, but to have something in 30 minutes is incredible!

Now let's check the weights and activations quantized model:

```

weights_tflite_model_file = 'converted_model_int8.tflite'

interpreter = tf.lite.Interpreter(model_path=weights_tflite_model_file)
interpreter.allocate_tensors()

input_index = interpreter.get_input_details()[0]["index"]
output_index = interpreter.get_output_details()[0]["index"]
```{{execute}}

As before, let's do a simple batch of 15 images (again, for performance reasons), and iterate to check its metrics: 

```
import  time
start_time = time.time()
predictions = []

test_labels, test_imgs = [], []
debug = 0
image_batch, label_batch = next(iter(test_examples_dataset))
for img, label in zip(image_batch, label_batch):
    debug += 1
    if debug % 5 == 1:
        print(f'I am treating image {debug} with label {label}')
    if debug == 15:
        break
    interpreter.set_tensor(input_index, np.array([img]))
    interpreter.invoke()
    predictions.append(interpreter.get_tensor(output_index))
    test_labels.append(label.numpy())
    test_imgs.append(img)


print(f'Predictions calculated in {time.time()  -  start_time} seconds')
```{{execute}}

We now have all the predictions. Let's calculate accuracy, sensitivity, and specificity:

```
ok_value = 0
wrong_value = 0
true_positives = 0
total = 0
true_negatives = 0
false_positives = 0
false_negatives = 0
for predictions_array, true_label in zip(predictions, test_labels):
    predicted_label = np.argmax(predictions_array)
    if predicted_label == true_label:
        ok_value += 1
        if CLASS_NAMES[int(true_label)] == 'NORMAL':
            true_negatives += 1
        else:
            true_positives += 1
    else:
        wrong_value += 1
        if CLASS_NAMES[predicted_label] == 'NORMAL':
            false_negatives +=1
        else:
            false_positives += 1
    total += 1


print(f'Accuracy: {(true_positives + true_negatives) / total} \n ')
print(f'Sensitivity: {true_positives/ (true_positives + false_negatives)} \n ')
print(f'Specificity: {true_negatives / (true_negatives + false_positives)}')

```{{execute}}

We can see that although the weights optimized model is a little smaller and better, the INT8 model is much faster. The idea behind INT8 quantization is to lose precision (a little bit) to gain speed.

Now, let's move on to learning how to deploy this into an Android app.