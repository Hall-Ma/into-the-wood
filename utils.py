import os
import numpy as np
import cv2
import pickle

data_dir = './data/trees'
categories = ['acer', 'alder', 'ash', 'beech', 'birch', 'oak']
data = []


def make_data():
    for category in categories:
        path = os.path.join(data_dir, category)  # ./data/trees/acer
        label = categories.index(category)

        for img_name in os.listdir(path):
            image_path = os.path.join(path, img_name)
            image = cv2.imread(image_path)

            try:
                image = cv2.resize(image, (224, 224))
                image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

                image = np.array(image, dtype=np.float32)

                data.append([image, label])

            except Exception as e:
                print(img_name, e)

    print("Total number of photos:", len(data))

    pik = open('data.pickle', 'wb')
    pickle.dump(data, pik)
    pik.close()


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

# make_data()
