import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf
from keras.preprocessing import image
from sklearn.model_selection import train_test_split

#from utils import load_data

categories = ['acer', 'alder', 'ash', 'beech', 'birch', 'oak']


def show_result():
    (feature, labels) = load_data()
    x_train, x_test, y_train, y_test = train_test_split(feature, labels, test_size=0.1)

    model = tf.keras.models.load_model('mymodel.h5')
    model.evaluate(x_test, y_test, verbose=1)

    # shows wrong listed categories -- alternative
    # y_prob = model.predict(x_test)
    # y_classes = y_prob.argmax(axis=-1)
    #
    # fig, ax = plt.subplots(6, 8, subplot_kw=dict(xticks=[], yticks=[]), figsize=(10, 8))
    # fig.tight_layout(pad=2)
    # for i, axi in enumerate(ax.flat):
    #     color = 'black'
    #     if y_classes[i] != y_test[i]: color = 'r'
    #     axi.imshow(x_test[i], cmap='gray_r')
    #     axi.set_title(categories[y_classes[i]], color=color)

    prediction = model.predict(x_test)

    plt.figure(figsize=(9, 9))

    for i in range(9):
        plt.subplot(3, 3, i + 1)
        plt.imshow(x_test[i])
        plt.xlabel('Actual:' + categories[y_test[i]] + '\n' + 'Predicted:' + categories[np.argmax(prediction[i])])
        plt.xticks([])
    plt.show()


def load_image(img_path, show=False):
    img = image.load_img(img_path, target_size=(256, 256))
    img_tensor = image.img_to_array(img)  # (height, width, channels)
    img_tensor = np.expand_dims(img_tensor,
                                axis=0)  # (1, height, width, channels), add a dimension because the model expects this shape: (batch_size, height, width, channels)
    img_tensor /= 255.  # imshow expects values in the range [0, 1]

    if show:
        plt.imshow(img_tensor[0])
        plt.axis('off')
        plt.show()

    return img_tensor


def show_classification(img_path):
    # load model
    model = tf.keras.models.load_model('newModel.h5')

    # load a single image
    new_image = load_image(img_path, True)

    # check prediction
    pred = model.predict(new_image)
    print(categories[np.argmax(pred)])


#show_result()
show_classification("oak_example.jpg")
show_classification("oak_example_1.jpg")
show_classification("eiche_3.png")
