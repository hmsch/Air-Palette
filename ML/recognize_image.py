from matplotlib.image import imread
from keras.models import load_model
import numpy as np

image = imread('banana.png')
print(image)
print(image.shape)

def rgb2gray(rgb):
    return np.dot(rgb[...,:3], [0.299, 0.587, 0.114])

gray = rgb2gray(image)
print("gray")
print(gray)
print(gray.shape)

x = np.zeros((1,28,28,1))
x[0,:,:,0] = gray
print(x)

model = load_model('weights.h5')
y_prob = model.predict(x)
y_classes = y_prob.argmax(axis=-1)
print("prediction ", y_classes)
