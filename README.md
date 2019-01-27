# ichack19-ICH

Draw by moving your hands, let AI recognize your drawings. 

Requires a Kinect, Windows, Python 3.6.? (Keras, ...), Processing.

## Run 
The neural net is already trained and the weights are saved in ```weights.h5```.

Both ``` drawing_rec.py ``` (classifies drawings) and the ```Drawing/drawing.pde``` (handles game logic and user interaction) need to run inorder to play the game. They communicate using sockets. So the Processing program needs the IP address (if not localhost) of the machine running the Python script. 

## Controls
- There are three main hand shapes the Kinect will recognise- open palms, closed fists, and 'lasso' (two fingers). Open palms represents 'pen down'- drawing mode. Closed fists will not draw, and Lasso clears the screen. Each hand operates independent, only clearing work by the hand that requested the clear. 
- Colours can be controlled  by placing your hand in the appropriate region, as can the other on screen buttons. 
- In order to exit the game, simply form a cross with your forearms in front of you, with your fist closed.
- ??

Data used for training the neural net: https://console.cloud.google.com/storage/browser/quickdraw_dataset/full/numpy_bitmap 

Loading data and training the neural net: https://github.com/subarnop/Kiddo
