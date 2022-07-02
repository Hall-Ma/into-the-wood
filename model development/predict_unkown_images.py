import os

import cv2
import numpy as np
from keras.optimizers import Adam
from keras.models import load_model
from keras_preprocessing.image import ImageDataGenerator
from keras.applications.resnet import preprocess_input
from matplotlib import pyplot as plt

if __name__ == '__main__':

    class_names = ['Maple', 'Birch', 'Oak', 'Hornbeam', 'Chestnut', 'Linden']

    absolute_path = os.path.abspath(__file__)
    file_directory = os.path.dirname(absolute_path)
    parent_directory = os.path.dirname(file_directory)
    model_path = os.path.join(parent_directory, 'app_development\\backend\\resNet50_16_batches_best.h5')

    data_generator = ImageDataGenerator(preprocessing_function=preprocess_input)

    prediction_set = data_generator.flow_from_directory(
        directory='prediction_examples',
        target_size=(224, 224),
        class_mode=None,
        shuffle=False,
        batch_size=32,
        seed=123
    )

    model = load_model(model_path)

    model.compile(optimizer=Adam(lr=0.0001),
                  loss='categorical_crossentropy',
                  metrics=['accuracy'])
    model.evaluate(prediction_set)
    prediction_set.reset()

    pred = model.predict_generator(prediction_set)

    predicted_class_indices = np.argmax(pred, axis=1)

    TEST_DIR = 'prediction_examples/'

    # >> 84 % accuracy of this dateset

    def get_title(class_name, percentage):
        return "{}: {:.2f}%".format(class_name, np.max(percentage) * 100)


    fig = plt.figure(figsize=(20, 30))

    for i in range(0, prediction_set.n):
        imgBGR = cv2.imread(TEST_DIR + prediction_set.filenames[i])
        imgRGB = cv2.cvtColor(imgBGR, cv2.COLOR_BGR2RGB)
        fig.add_subplot(11, 7, i + 1)
        plt.title(get_title(class_names[predicted_class_indices[i]], pred[i]))
        plt.axis('off')
        plt.imshow(imgRGB)

    plt.show()

