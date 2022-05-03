import os
import numpy as np
import cv2
import pickle

data_dir = './data/trees'
categories = ['acer', 'alder', 'ash', 'beech', 'birch', 'douglas_fir', 'oak', 'pine', 'spruce', 'yew']
data = []


def make_data():
    for category in categories:
        path = os.path.join(data_dir, category)  # ./data/trees/acer
        label = categories.index(category)

        for img_name in os.listdir(path):
            image_path = os.path.join(path, img_name)
            image = cv2.imread(image_path)

            cv2.imshow('iamge sdfsdf', image)
            break

        break

    cv2.waitKey(0)
    cv2.destroyAllWindows()


make_data()


def load_data():
    pick = open('data.pickle', 'rb')
    data = pickle.load(pick)
    pick.close()

    np.random.shuffle(data)

    feature = []
    labels = []

    for img, label in data:
        feature.append(img)
        labels.append(label)

    feature = np.array(feature, dtype=np.float32)
    labels = np.array(labels)

    feature = feature / 255.0

    return [feature, labels]
