// REQUIRES
// https://github.com/ThomasLengeling/KinectPV2

import KinectPV2.KJoint;
import KinectPV2.*;
import interfascia.*;

KinectPV2 kinect;

import processing.net.*; 

Table table;
String[] list;
int rows;
GUIController c;
IFButton b1;
String wordToDraw;
int time;
boolean reset;
Client myClient;

ArrayList<PairLineList> skeletondata;


void setup() {
  size(1920, 1080);
  
  reset = false;
    
  /*c = new GUIController (this);
  PFont font = loadFont("LaoMN-48.vlw"); //<>//
  textFont(font, 32);
  
  IFLookAndFeel colorScheme = new IFLookAndFeel(this,IFLookAndFeel.DEFAULT);
  colorScheme.baseColor = color(239, 35, 60);
  colorScheme.highlightColor = color(217, 4, 41);
  colorScheme.textColor = color(43,45,66);
  c.setLookAndFeel(colorScheme);
  b1 = new IFButton ("", width/2-450, 25);
  b1.setSize(160,60);
  b1.addActionListener(this);
  c.add(b1);*/
  
  
  table = loadTable("categories.csv", "header");
  rows = table.getRowCount();
  //println(table.getRowCount() + " total rows in table"); 
  list = new String[table.getRowCount()];
  int counter = 0;
  for (TableRow row : table.rows()) {

    String category = row.getString("categories");
    list[counter] = category;

    counter++;
    //println(category);
  }
  
  wordToDraw = "";
   
  background(255);
   //<>//
  skeletondata = new ArrayList<PairLineList>();

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
  
  myClient = new Client(this, "146.169.204.139", 5024);

  time = 60;

}

void draw() {

  if (reset) {
    int wait = millis()/1000 + 3;
    while (wait > millis()/1000);
    time = millis()/1000 + 60;
    reset = false;
  }
  
  background(255);

  //tint(255, 127); // doesn't work... :(
  //image(kinect.getColorImage(), 0, 0, width, height);
 
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) { //<>//
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      KJoint rightJoint = joints[KinectPV2.JointType_HandRight];
      KJoint leftJoint = joints[KinectPV2.JointType_HandLeft];

      if (i >= skeletondata.size()) {
        PairLineList skd = new PairLineList();
        skd.right.add(new Line(new PVector(rightJoint.getX(), rightJoint.getY()), color(255)));
        skd.left.add(new Line(new PVector(leftJoint.getX(), leftJoint.getY()), color(255)));
        skeletondata.add(skd);
      } else {
        PairLineList skd = skeletondata.get(i);
        
        PVector right = new PVector(rightJoint.getX(), rightJoint.getY());
        skd.rightColNow = positionCheck(right, skd.rightColNow);

        if (rightJoint.getState() == KinectPV2.HandState_Open) {
          Line rightLine = new Line(right, skd.rightColNow);
          skd.right.add(rightLine);
        } else if (rightJoint.getState() == KinectPV2.HandState_Lasso) {
          skd.right = new ArrayList<Line>();
          //skd.left = new ArrayList<Line>();
        } else if (rightJoint.getState() == KinectPV2.HandState_Closed) {
          Line rightLine = new Line(right, color(255));
          skd.right.add(rightLine);
        }
        
        PVector left = new PVector(leftJoint.getX(), leftJoint.getY());
        skd.leftColNow = positionCheck(left, skd.leftColNow);
        
        if (leftJoint.getState() == KinectPV2.HandState_Open) {
          Line leftLine = new Line(left, skd.leftColNow);
          skd.left.add(leftLine);
        } else if (leftJoint.getState() == KinectPV2.HandState_Lasso) {
          //skd.right = new ArrayList<Line>();
          skd.left = new ArrayList<Line>();
        } else if (leftJoint.getState() == KinectPV2.HandState_Closed) {
          Line leftLine = new Line(left, color(255));
          skd.left.add(leftLine);
        }
                     
        if (right.x < left.x) {
          time = millis() / 1000;
        }
                                
        noStroke();
        fill(0);
        ellipse(leftJoint.getX(), leftJoint.getY(), 50, 50);
        ellipse(rightJoint.getX(), rightJoint.getY(), 50, 50);    
        
      }
    }
  }
  
  for (PairLineList pll : skeletondata) {       
    drawVectors(pll.right);
    drawVectors(pll.left);  
  }
  
  noStroke();
  fill(#503047);  // BLACK
  rect(9*width/10, 0, width/10, height/5);
  fill(#4D9DE0);  // BLUE
  rect(9*width/10, height/5, width/10, 2*height/5);
  fill(#FC9E4F);  // ORANGE
  rect(9*width/10, 2*height/5, width/10, 3*height/5);
  fill(#E15554);  // RED
  rect(9*width/10, 3*height/5, width/10, 4*height/5);
  fill(#E1BC29);  // ORANGE
  rect(9*width/10, 4*height/5, width/10, height);
  
  //fill(255, 165, 0);  // ORANGE
  //rect(0, 0, width/10, height/5);
  fill(#1D3461);  // DARK BLUE
  rect(0, height/5, width/10, 2*height/5);
  fill(#3BB273);  // GREEN
  rect(0, 2*height/5, width/10, 3*height/5);
  fill(#7768AE);  // VIOLET
  rect(0, 3*height/5, width/10, 4*height/5);
  fill(#2C3D55);  // BLACK
  rect(0, 4*height/5, width/10, height);
  
  fill(0);
  stroke(0);
  strokeWeight(50);
  textSize(128);
  text(str(time - (millis() / 1000)), width/2-50, 100);
    
  textSize(64);
  text("New Word", 10, 60);
  
  /*strokeWeight(2);
  stroke(0);
  fill(220);
  rect(0, 0, 400, height/5);*/
  
  fill(0);
  stroke(0);
  strokeWeight(50);
  textSize(64);
  text(wordToDraw, 20, 150);
  if (millis()/1000 >= time) {
    
      PImage pi = get(width/10, 0, 8*width/10, height);
      //pi.save("uncropped.jpg");
      pi.resize(28, 28);
      //pi.save("resized.jpg");
      pi.filter(GRAY);
      //pi.save("gray.jpg");
      pi.filter(INVERT);
      //pi.save("gray+invert.jpg");
      pi.loadPixels();

      String s = "";
      for (int i = 0; i < 28*28; i++) {
        s += (pi.pixels[i] & 0xFF) + " ";
        // print((pi.pixels[i] & 0xFF) + "  ");
      }
      
      myClient.clear();
      myClient.write(s);
      // myClient.write(pi.pixels);
    
      int dataIn = 10;
  
      while (myClient.available() == 0);
      if (myClient.available() > 0) {
        dataIn = myClient.read();
        myClient.clear();
        //println(dataIn);
      }
      
      //pi.save("file-" + dataIn + ".jpg");
      //println(dataIn);
      
      fill(0);
      stroke(0);
      strokeWeight(50);
      textSize(300); 
      
      switch (dataIn) {
          case 48:
            text("apple!", width/3, height/2);
            break;
          case 49:
            text("banana!", width/4, height/2);
            break;
          case 50:
            text("candle!", width/3, height/2);
            break;
          case 51:
            text("fish!", width/3, height/2);
            break;
          case 52:
            text("ladder!", width/3, height/2);
            break;
          case 58:
            text("maybe\n apple", width/3, height/2);
            break;
          case 59:
            text("maybe\n banana", width/4, height/2);
            break;
          case 60:
            text("maybe\n candle", width/3, height/2);
            break;
          case 61:
            text("maybe\n fish", width/3, height/2);
            break;
          case 62:
            text("ladder!", width/3, height/2);
            break;
          case 45:
          default:
            text("unknown...", width/8, height/2);
            break;    
      }
      
      reset = true;
      
  }
}

color positionCheck(PVector vec, color deflt) {

  float x = vec.x;
  float y = vec.y;

  if (x > 0 && x < 400 && y > 0 && y < height/5) {
    int n = (int) random(0, rows);
    wordToDraw = list[n];
  }
  
  if ( (x >= 9*width / 10)
    && (x < width)) {
      if ((y >= 0) && (y < height/5)) {
        // BLACK
        return #503047;
      } else if ((y >= height/5) && (y < 2*height/5)) {
        // BLUE
        return #4D9DE0;
      } else if ((y >= 2*height/5) && (y < 3*height/5)) {
        // ORANGE
        return #FC9E4F;
      } else if ((y >= 3*height/5) && (y < 4*height/5)) {
        // RED
        return #E15554;
      } else if ((y >= 4*height/5) && (y < height)) {
        // YELLOW
        return #E1BC29;
      }
  } else if ( (x >= 0)
    && (x < width / 10)) {
      if ((y >= 0) && (y < height/5)) {
        // ORANGE
        //return color(255, 165, 0);
      } else if ((y >= height/5) && (y < 2*height/5)) {
        // DARK BLUE
        return #1D3461;
      } else if ((y >= 2*height/5) && (y < 3*height/5)) {
        // GREEN
        return #3BB273;
      } else if ((y >= 3*height/5) && (y < 4*height/5)) {
        // VIOLET
        return #7768AE;
      } else if ((y >= 4*height/5) && (y < height)) {
        // BLACK
        return #2C3D55;
      }
  }
  return deflt;

}

void drawVectors(ArrayList<Line> line_list){
  noFill();
  strokeWeight(50);  
  for (int i = 1; i < line_list.size(); i++) {
    Line from = line_list.get(i);
    Line to = line_list.get(i-1);
    if (to.col != color(255)) {
      stroke(to.col);
      line(from.line.x, from.line.y, to.line.x, to.line.y);
    }
  }
}
