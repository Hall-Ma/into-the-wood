import os
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image as img
from tensorflow.keras.utils import img_to_array
from keras import backend as k
import numpy as np
import tensorflow as tf
from PIL import Image
from datetime import datetime
from tensorflow.keras.applications.resnet50 import ResNet50, decode_predictions, preprocess_input
from flask import Flask, Blueprint, request, render_template, jsonify

model = load_model("resNet50_16_batches_best.h5")

app = Flask(__name__)


@app.route('/uploades', methods=["GET", "POST"])
def upload():
    if (request.method == "POST"):
        imagefile = request.files['file']
        path = os.path.join(os.getcwd() + '\\uploades\\' + imagefile.filename)
        imagefile.save(path)
        prediction = identifyImage(path)
        os.remove(path)
        return jsonify({"message": "Image uploaded!",
                        "upload_time": datetime.now(),
                        "prediction": prediction
                        })


def identifyImage(img_path):
    class_names = ['Ahorn', 'Birke', 'Eiche', 'Hainbuche', 'Kastanie', 'Linde']
    image = img.load_img(img_path, target_size=(224, 224))
    x = img_to_array(image)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)
    preds = model.predict(x)
    predicted_percentage = round(100 * np.max(preds),2)
    predicted_tree_name = class_names[np.argmax(preds[0], axis=-1)]
    return {
        "predicted tree": predicted_tree_name,
        "predicted_percentage": str(predicted_percentage)
    }


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
