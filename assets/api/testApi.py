from __future__ import division, print_function
from flask import Flask, jsonify
from flask_restful import Resource, Api, reqparse

import os
from matplotlib.pyplot import axis
import numpy as np
import tensorflow as tf
import keras
from keras.applications.imagenet_utils import preprocess_input, decode_predictions
from keras.models import load_model
from keras.preprocessing import image
import urllib.request

# load  model
MODEL_PATH = r'D:\RAJ\DMCE_sem8\Major Project\trial1\clickncook\assets\mobilenet1\mobilenetv2Model.h5'
labelsPath = r"D:\RAJ\DMCE_sem8\Major Project\trial1\clickncook\assets\mobilenet1\labels.txt"
# MODEL_PATH = "https://firebasestorage.googleapis.com/v0/b/cncauthentication.appspot.com/o/Model%2Fclickncook%2Fmobilenetv2Model.h5?alt=media&token=869eda68-63d6-4a94-9b4d-138e1138c5b5"
# labelsPath = "https://firebasestorage.googleapis.com/v0/b/cncauthentication.appspot.com/o/Model%2Fclickncook%2Flabels.txt?alt=media&token=5b3c3035-ad58-4490-8d85-18cbfb52c99f"
# labels = list(urllib.request.urlopen(labelsPath).read().splitlines())
model = load_model(MODEL_PATH)
labels = open(labelsPath).read().splitlines()
print(labels)

app = Flask(__name__)
api = Api(app)

parser = reqparse.RequestParser()


class ModelApi(Resource):
    def download_image(img_link):
        img_link = str(img_link)
        download_cmd = 'wget --no-check-certificate -O food.jpg '+img_link
        os.system(download_cmd)
        post_location = img_link.split('/')[-1]
        img_name = post_location.split('&')[0]
        return "food.jpg"

    def post(self):
        parser.add_argument("img_link")
        args = parser.parse_args()
        img_name = ModelApi.download_image(args["img_link"])
        img = ModelApi.prepare_image_and_predict(img_name)
        prediction = model.predict(img)
        print("Prediction", prediction)
        index = prediction.argmax()
        print(index, labels[index])
        return jsonify(labels[index])

    def prepare_image_and_predict(img_name):
        img = image.load_img(img_name, target_size=(224, 224))
        img_array = image.img_to_array(img)
        img_array_expanded_dims = np.expand_dims(img_array, axis=0)
        mobile = keras.applications.mobilenet_v2.preprocess_input(
            img_array_expanded_dims)
        print(mobile.shape)
        return mobile


api.add_resource(ModelApi, '/modelapi/')


if __name__ == "__main__":
    app.run(debug=False)
