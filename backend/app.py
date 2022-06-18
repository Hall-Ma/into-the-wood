import os
from keras import backend as k
import tensorflow as tf
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image as img
from tensorflow.keras.utils import img_to_array
from tensorflow.keras.applications.resnet50 import preprocess_input
import numpy as np
from flask import Flask, request, jsonify, render_template
from PIL import Image

model = load_model("resNet50_16_batches_best.h5")

app = Flask(__name__)


@app.route('/', methods=["POST"])
def upload():
    if (request.method == "POST"):
        imagefile = request.files['file']
        path = os.path.join(os.getcwd() +"/"+ imagefile.filename)
        imagefile.save(path)
        prediction = identifyImage(path)
        os.remove(path)
        return jsonify({
            "prediction": prediction
        })


def identifyImage(img_path):
    class_names = ['Maple', 'Birch', 'Oak', 'Hornbeam', 'Chestnut', 'Linden']
    image = img.load_img(img_path, target_size=(224, 224))
    x = img_to_array(image)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)
    preds = model.predict(x)
    predicted_percentage = round(100 * np.max(preds), 2)
    predicted_tree_name = class_names[np.argmax(preds[0], axis=-1)]
    return {
        "predicted tree": predicted_tree_name,
        "predicted_percentage": str(predicted_percentage)
    }


# @app.route('/')
# def index():
#     # A welcome message to test our server
#     return "<h1>Welcome to our medium-greeting-api Test!</h1>"

port = int(os.environ.get('PORT', 5000))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port, debug=True)
