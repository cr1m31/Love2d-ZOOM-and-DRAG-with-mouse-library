# Love2d-ZOOM-and-DRAG-with-mouse-library
ZOOM and DRAG with mouse library, written in Lua inside Love2d
_____________________________________________________________________________
You can drag (transform) the world with the left mouse button,
also zoom in and out with the mouse wheel.
The zoom will focus on the mouse cursor.

code inspired by javidx9 (one lone coder) 
https://github.com/OneLoneCoder/videos/blob/master/OneLoneCoder_PanAndZoom.cpp

See the MIT license.
This program comes with ABSOLUTELY NO WARRANTY.
I am not be responsible of what you will do with this code.  
_________________________________________________________________________________________________________
It is made for a tutorial on YT: TBD

The symbolic concept is that you have multiple dimensions, like parallel dimensions in this program.

Since we are in 2D here, i will replace the word "dimension" by "space",
to avoid confusion between two dimensions (2D) and parallel dimension.

Here, we have basically the screen and the world spaces, both have an horizontal x and vertical y axis (2 dimensions).

We create some function to make a portal between screen and world spaces.
The portal is the function and the link between spaces is the offset...
