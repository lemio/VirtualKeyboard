/*
Run this code in Processing https://processing.org/
Go to Sketch> Import Library> Add Library>Search for Geomerative by Richard Marxer > Install

More information on this library can be found here https://github.com/rikrd/geomerative
A video on how to create a new keyboard/remote can be seen here 

From Figma (example file here: https://www.figma.com/file/Mo5mncsrGZIj3dw6PJIuI5/VirtualKeyboard?type=design&node-id=3%3A341&mode=design&t=D5gGNGl8mI5BNPrr-1)
* Export the visual appearance of the keyboard as png (x1)
* For the interaction of the remote, every layer/vector name will be what key it will press
* Export the interaction layer as svg


*/
//Select what file should be selected
static final String name = "AppleRemote"; // CC-BY-SA 4.0 https://www.figma.com/community/file/981941474926725619/%EF%A3%BF-TV-Remote
//static final String name = "keyboard"; // CC-BY-SA 4.0 https://www.figma.com/community/file/830795415201514469/microsoft-windows-10-virtual-keyboard

import geomerative.*;

import java.awt.*;
import java.awt.event.KeyEvent;
//Create a new Robot class https://docs.oracle.com/javase/8/docs/api/java/awt/Robot.html
Robot robot;

import javax.swing.*;

import processing.awt.PSurfaceAWT;
import processing.awt.PSurfaceAWT.SmoothCanvas;

RShape keyboardVector;
PImage keyboardBitmap;

long timeOut = 0; //Timer for checking if the character needs to be repeated
static final long firstRepeatTime = 500; //(Delay untill Repeat, milliseconds) Time for repeating a character when longpressing a button usually the first character takes a bit more time than later 
static final long repeatTime = 200; //(Key Repeat Rate, milliseconds) Time for repeating a character when longpressing a button

long nextDraw = 0; //Timer for checking if the screen needs to be redrawn
static final long drawDelay = 300; //How long the key should look pressed after releasing it, to make it more visible in screen recoding.

boolean wasPressed = false; //Variable to check the previous press state
int lastPressed = 0; //The character that was last pressed

PSurface initSurface() {
  
  PSurface pSurface = super.initSurface();
  //If you want to see the keyboard presses, we need to disable the on-screen-keyboard functionality (block comment untill <<<
    
  ( (SmoothCanvas) ((PSurfaceAWT)surface).getNative()).getFrame().enableInputMethods(false);
  ( (SmoothCanvas) ((PSurfaceAWT)surface).getNative()).getFrame().setFocusable(false);
  ( (SmoothCanvas) ((PSurfaceAWT)surface).getNative()).getFrame().setFocusableWindowState(false);
  ( (SmoothCanvas) ((PSurfaceAWT)surface).getNative()).getFrame().removeNotify();
  
  // <<<*/
  //THIS IS IMPORTANT FOR MAC (otherwise the window will get the focus when pressed on)
  ( (SmoothCanvas) ((PSurfaceAWT)surface).getNative()).getFrame().setType(Window.Type.POPUP);
  
  //Ucomment this if you want to not have the borders around the remote
  //( (SmoothCanvas) ((PSurfaceAWT)surface).getNative()).getFrame().setUndecorated(true);
  return pSurface;
}

void setup() {
  RG.init(this);
  try
  {
    robot = new Robot();
  }
  catch (AWTException e) {
    throw new RuntimeException("Unable to Initialize", e);
  } 
  //Make the window resizeable
  surface.setResizable(true);
  
  //Make it always on top
  surface.setAlwaysOnTop(true);
  
  //Load the vector file (interactive layer)
  keyboardVector = RG.loadShape(name.concat(".svg"));
  
  //Load the raster file (visual layer)
  keyboardBitmap = loadImage(name.concat(".png"));
  
  //Resize the canvas to match the vector shape size
  surface.setSize(round(keyboardVector.width), round(keyboardVector.height));
  
}

void draw() {
  //When the mouse is pressed
  if  (mousePressed ) {
    //Check if the mouse was pressed before, and repeatTime (default 200ms) is passed.
    if ((millis() - timeOut) > 0 && timeOut != 0 && lastPressed != 0) {
      //And timeout is not passed, 
      robot.keyPress(lastPressed);
      timeOut = millis() + repeatTime;
    }
  }else{
  timeOut = 0;
  }
  //wasPressed is used to make the visual highlighting of buttons slighly longer than the actual button press
  //This is beneficial for screen recording purposes.
  if ((millis() - nextDraw) > 0) {
    wasPressed = false;
  }
  //Draw the vector shape (this will not be visible but purely for making the remote interactive
  keyboardVector.draw();
  //Draw the raster image 
  image(keyboardBitmap, 0, 0);
  //Get the point of the cursor at the moment, and create an RPoint out of it
  RPoint p = new RPoint(mouseX, mouseY);
  for (int i=0; i<keyboardVector.children[0].countChildren(); i++) {
     /**
     If the point is in one of the shapes
     Source: https://github.com/rikrd/geomerative/blob/master/src/geomerative/RShape.java
     * Use this to return a specific tangent on the curve.  It returns true if the point passed as a parameter is inside the shape.  Implementation taken from: http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
     * @param p  the point for which to test containment.
     * @return boolean, true if the point is in the path.
     * */
    if (keyboardVector.children[0].children[i].contains(p)) {
      
      if  (mousePressed || wasPressed) {
        /*
        If the mouse was pressed or is pressed show the active button highlighted
        */
        noFill();
        tint(255, 255);
        image(keyboardBitmap, 0, 0);
        strokeWeight(3);
        tint(100, 100);
        stroke(255, 255, 255, 127);
        keyboardVector.children[0].children[i].draw();
        tint(255, 255);
      }
    }
    String id = keyboardVector.children[0].children[i].name;
    
    boolean pressed = false;
    //All key codes can be found here: https://docs.oracle.com/javase/8/docs/api/java/awt/event/KeyEvent.html
    switch (id){
        case "up":
          if (keyCode == KeyEvent.VK_UP){
            pressed = keyPressed;
          }
        break;
        case "down":
          if (keyCode == KeyEvent.VK_DOWN){
            pressed = keyPressed;
          }
        break; 
        case "left":
          if (keyCode == KeyEvent.VK_LEFT){
            pressed = keyPressed;
          }
        break; 
        case "right":
          if (keyCode == KeyEvent.VK_RIGHT){
            pressed = keyPressed;
          }
        break; 
        case "enter":
          if (keyCode == KeyEvent.VK_ENTER){
            pressed = keyPressed;
          }
        break; 
        case "space":
          if (key == ' '){
            pressed = keyPressed;
          }
        break; 
        default:
          if (key == id.charAt(0)){
            pressed = keyPressed;
          }
        break;
    }
    
    if (pressed){
    strokeWeight(10);
        tint(100, 100);
        stroke(255, 255, 255, 127);
        keyboardVector.children[0].children[i].draw();
        tint(255, 255);
    }
  }
  //Draw the cursor on top of the remote, this will help the video recording to be more clear/visual.
   drawCursor();
}

void drawCursor(){
  //fill the circle with white with 100/255 Alpha level
  fill(255,255,255,100);
  //Set the stroke to be 3 pixels
  strokeWeight(3);
  //Make the stroke black with 100/255 Alpha level
  stroke(0,0,0,100);
  //Draw the cursor with 40 by 40 pixels
  ellipse(mouseX,mouseY,40,40);
}

void mousePressed() {
  
  RPoint p = new RPoint(mouseX, mouseY);
  for (int i=0; i<keyboardVector.children[0].countChildren(); i++) {
    if (keyboardVector.children[0].children[i].contains(p)) {
      String id = keyboardVector.children[0].children[i].name;
      println(id);

      if (id.length()> 0) {
        int currentKey =  java.awt.event.KeyEvent.getExtendedKeyCodeForChar(id.charAt(0));  
        switch (id) {
        case "up":
          currentKey = KeyEvent.VK_UP;
          break;
        case "down":
          currentKey = KeyEvent.VK_DOWN;
          break;
          case "left":
          currentKey = KeyEvent.VK_LEFT;
          break;
        case "right":
          currentKey = KeyEvent.VK_RIGHT;
          break;
          case "enter":
          currentKey = KeyEvent.VK_ENTER;
          break;
          case "space":
          currentKey = KeyEvent.VK_SPACE;
          break;
        }
        wasPressed = true;
        timeOut = millis() + firstRepeatTime;
        nextDraw = millis() + drawDelay;
        //String letter = id.substring(id.length() - 1);
        
        robot.keyPress(currentKey);
        /*
        if (currentKey == '2'){
          robot.keyRelease(currentKey);
        }*/
        lastPressed = currentKey;
      }
    }
  }
}
void mouseReleased() {
  
  /*
  For the preset buttons 2 and 3 we added 5 and 6 as a unpress button. 
  So when long-pressing 2 it will look like 22222222222225
  
  Currently this is commented out, since this is a niche use
  
  if (lastPressed > 0) {
    robot.keyRelease(lastPressed);
    if (lastPressed == '2'){
      robot.keyPress('5');
      robot.keyRelease('5');
    }
    if (lastPressed == '3'){
      robot.keyPress('6');
      robot.keyRelease('6');
    }
  }*/
}

void keyPressed(){
  

}
void keyReleased() {
  
  keyCode = ' ';
}
