# VirtualKeyboard

A virtual on-screen keyboard for interacting with user interfaces emulating hardware interfaces. With an SVG as it's definition for the remote behaviour.

![youtube](https://github.com/lemio/VirtualKeyboard/assets/877056/3b69efc4-a421-4dcf-91b5-02ab18f281c5)


## Installation

(unmute video to hear voiceover)

https://github.com/lemio/VirtualKeyboard/assets/877056/c5626590-4e65-4d4e-9893-851b965d3ae8

* Install processing
* Install geomerative library
* Allow permissions for controlling the keyboard from processing


## How to customize it


(unmute video to hear voiceover)

https://github.com/lemio/VirtualKeyboard/assets/877056/b723be49-a1e1-4145-b4b2-dc87d6f782e9



* Open Figma (or any other vector based editor)
* Create one frame for the visual appearance and one for the interactions, give them the same name
* Within the frame for interactions name the elements that you want to interact with according to the buttons on the keyboard; for example (a-z) lowercase, (0-9), left, right, up, down, enter, space.
* Export the frame for interactions as SVG with include "id" attribute checked (this is not by default!), save this in the folder of the Processing Sketch.
* Export the frame for visuals as PNG with x1 scale (this needs to be x1 since it will be mapped to the interactive file), save this in the folder of the Processing Sketch.
* Change the `static final String name = "keyboard";` to the filename you gave the frames and comment all the other out.
* Run the processing sketch to test (check Installation if you run into issues).
