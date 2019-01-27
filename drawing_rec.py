from matplotlib.image import imread
from keras.models import load_model
import numpy as np
import socket
import time


# import ML model
model = load_model('ML/weights_5.h5')
buffer = np.array([]);

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 5024               # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)
while True:
    data = conn.recv(4096)
    if not data: break
    data_array = np.fromstring(data, dtype=int, sep=' ')
    print("data shape", data_array.shape)
    buffer = np.append(buffer, data_array)
    if buffer.size < 784:
        print("waiting for more data :", buffer.size)
        continue
    data_array = buffer[:784]
    buffer = buffer[784:]
    print(data_array)
    img = np.reshape(data_array, (-1, 28)) / 255.0
    x = np.zeros((1,28,28,1))
    x[0,:,:,0] = img
    prediction = model.predict(x)
    print("prediction ", prediction)
    y_classes = prediction.argmax(axis=-1)
    if prediction[0][y_classes[0]] > 0.5:
        print('sent class !')
        # apple, banana, candle, fish, ladder
        conn.send(str.encode((str(y_classes[0]))))
    elif prediction[0][y_classes[0]] > 0.30:
        print('sent class ?')
        # not so sure but maybe
        # apple, banana, candle, fish, ladder
        conn.send(str.encode((str(chr(y_classes[0] + 48 + 10)))))
    else:
        print('unknown')
        conn.send(str.encode('-'))
conn.close()
# optionally put a loop here so that you start
# listening again after the connection closes






# ['full_numpy_bitmap_apple', 'full_numpy_bitmap_banana', 'full_numpy_bitmap_bicycle', 'full_numpy_bitmap_broom', 'full_numpy_bitmap_butterfly', 'full_numpy_bitmap_candle', 'full_numpy_bitmap_cloud', 'full_numpy_bitmap_donut', 'full_numpy_bitmap_duck', 'full_numpy_bitmap_fish', 'full_numpy_bitmap_ladder', 'full_numpy_bitmap_rabbit', 'full_numpy_bitmap_snowflake']
