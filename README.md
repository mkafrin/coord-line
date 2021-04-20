# coord-line
A development tool for FiveM and RedM that enables you to very easily create lines of equidistant coordinates. Useful for things like generating a point for every parking space, or getting the exact center coordinate between two points.

### How to use
This tool is very simple to use. First download this repository and unzip it into your resources folder. Next, start the resource in your server console (if your server is already running you have to run `refresh` first). Once that is done, there are a few commands you can run, which are as follows:
- /coordline start
  - Starts a new coord-line
- /coordline end
  - Ends the current coord-line
- /coordline save
  - Saves the current coord-line (if completed) to a coordlines.txt file in the coord-line folder
- /coordline last
  - If you have saved a coord-line, this will start a new one with the same properties of the one you last saved

When you start a new coord-line, you will see a green sphere where you are looking in game. This represents your "startPoint". You can either press E to set it or press and hold E to set an "anchor point" and then release E elsewhere, and the "startPoint" will be set exactly in the middle of the "anchor point" and where you released E. The green sphere will now stay in place and a red sphere will appear, representing the "endPoint", and a blue line will connect the two. This line is the "coord-line" or line upon which the coordinates will be placed. You can set your "endPoint" in the same way as the "startPoint".

Now a purple sphere will appear in the center of the line. This is a coordinate, as the default number of coordinates on a coord-line is 1. To change this number, just use your scroll wheel.

If you need to move your startPoint or endPoint, you can do that using the arrow keys to move the point left, right, forward, or back. R moves the point up and F moves it down. G will try and place the point on the ground. To select which point you are moving, you use the numbers 1 (startPoint), 2 (endPoint), and 3 (both). You can also hold ctrl down while moving the point to go slower.

The heading of the coord-line will be represented by an arrow over each coord. To change the heading, use shift + scroll wheel. You can also use ctrl here to slow the rotation down.

And that's it! Once you are satisfied with your coordline, just use `/coordline save`, fill in a name, choose an output format, and check out the `coordlines` folder in the coord-line resource folder.
