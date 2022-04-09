import tensorflow as tf
converter = tf.lite.TFLiteConverter.from_keras_model_file(
    'D:\RAJ\DMCE_sem8\Major Project\trial1\clickncook\assets\mobilenet1\mobilenetv2Model.h5')  # Your model's name
model = converter.convert()
file = open('workingmodel.tflite', 'wb')
file.write(model)
