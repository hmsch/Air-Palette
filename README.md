# ichack19-ICH

Draw by moving your hands, let AI recognize your drawings. 

Requires a Kinect, Windows, Python 3.6.? (Keras, ...), Processing, Kinect v2 library for Processing.

## Run 
The neural net is already trained and the weights are saved in ```weights.h5```.

Both ``` drawing_rec.py ``` (classifies drawings) and the ```Drawing/drawing.pde``` (handles game logic and user interaction) need to run inorder to play the game. They communicate using sockets. So the Processing program needs the IP address (if not localhost) of the machine running the Python script. 

## Controls
- There are three main hand shapes the Kinect will recognise- open palms, closed fists, and 'lasso' (two fingers). Open palms represents 'pen down'- drawing mode. Closed fists will not draw, and Lasso clears the screen. Each hand operates independent, only clearing work by the hand that requested the clear. 
- Colours can be controlled  by placing your hand in the appropriate region, as can the other on screen buttons. 
- In order to exit the game, simply form a cross with your forearms in front of you, with your fist closed.

## Gameplay
- You have 60 seconds to draw a sketch of the item suggested to you at the top of the screen. At the end of the 60 seconds, the image will be passed to a neural network, which will try to guess what you drew. 

## Alternative uses
- Using the kinetic drawing implemenation as a scratchpad for Pictionary - playing against your friends! 
- We have created an android app to facilitate this, which provides functionality to input players names, generate challenges and keep score of those who've guessed correctly the most often.
##Education
- We believe this sort of technology could be used as a teaching tool in primary school education. Teaching motor skills, shapes and words and spelling all at once, it could be a versatile and fun teaching tool. Exposure to some of the more basic parts of the source code (some of the processing code is accessible) could also be a introductory tool to computer science and coding for older (lower secondary students).

## Extensions/Continuations
- The first thing that we would want to do to extend this project would certainly be training the neural network on further images, extending its vocabulary and the number of images it can recognise. This is both time and space limited but would benefit the project massively. 
- Other possible extensions include improving the drawing functionality, including the provision of erasing previously drawn lines, and perhaps even being able to export the images to variously places, including possibly the pictionary app example we have produced. 


Data used for training the neural net: https://console.cloud.google.com/storage/browser/quickdraw_dataset/full/numpy_bitmap 

Loading data and training the neural net: https://github.com/subarnop/Kiddo
