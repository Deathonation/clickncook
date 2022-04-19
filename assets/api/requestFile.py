from __future__ import division, print_function
from matplotlib.font_manager import json_dump, json_load
import requests
import sys
import os
import glob
import pandas as pd
import re
from matplotlib.pyplot import axis
import numpy as np
import tensorflow as tf
import keras
from keras.applications.imagenet_utils import preprocess_input, decode_predictions
from keras.models import load_model
from keras.preprocessing import image
import json

imgpath = r"D:\RAJ\DMCE_sem8\Major Project\modelTraining\testing\dhokla.jpg"
img = image.load_img(imgpath, target_size=(224, 224))
img_array = image.img_to_array(img)
img_array_expanded_dims = np.expand_dims(img_array, axis=0)
mobile = keras.applications.mobilenet_v2.preprocess_input(
    img_array_expanded_dims)
print(mobile.shape)
data = {
    "img": json.dumps(mobile.tolist())
}
# print(json_data)
output = requests.post("http://127.0.0.1:5000/modelapi/",
                       data=data)
print(output)
