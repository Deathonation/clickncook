from __future__ import division, print_function
import json
from flask import Flask
from flask_restful import Resource, Api, reqparse


import sys
import os
import glob
import matplotlib
import pandas as pd
import re
from matplotlib.pyplot import axis
import numpy as np
import tensorflow as tf
import keras
from keras.applications.imagenet_utils import preprocess_input, decode_predictions
from keras.models import load_model
from keras.preprocessing import image


# load  model
MODEL_PATH = r'D:\RAJ\DMCE_sem8\Major Project\trial1\clickncook\assets\mobilenet1\mobilenetv2Model.h5'
model = load_model(MODEL_PATH)
labelsPath = r"D:\RAJ\DMCE_sem8\Major Project\trial1\clickncook\assets\mobilenet1\labels.txt"

labels = open(labelsPath).read().splitlines()
print(labels)

app = Flask(__name__)
api = Api(app)

parser = reqparse.RequestParser()


class ModelApi(Resource):
    # _img = r"D:\RAJ\DMCE_sem8\Major Project\modelTraining\testing\pavbhaji.jpg"

    def post(self):
        parser.add_argument("img")
        args = parser.parse_args()
        # print(parser.args)
        # print("image:", (args['img']))
        image1 = np.array(json.loads(args["img"]), dtype=np.float32)
        # input = np.fromstring(image1, dtype=np.float64)
        input = image1
        # matplotlib.pyplot.imshow(arg)
        print("img shape: ", image1.shape, image1.dtype)
        # preprocessed_image = ModelApi.prepare_image(args["img"])
        prediction = model.predict(input)
        print("Prediction", prediction)
        index = prediction.argmax()
        print(index, labels[index])
        return labels[index], 200

    # def prepare_image(img):
    #     # img = image.load_img(file, target_size=(224, 224))
    #     img_array = image.img_to_array(img)
    #     img_array_expanded_dims = np.expand_dims(img_array, axis=0)
    #     mobile = keras.applications.mobilenet_v2.preprocess_input(
    #         img_array_expanded_dims)
    #     return mobile


api.add_resource(ModelApi, '/modelapi/')


if __name__ == "__main__":
    app.run(debug=True)
