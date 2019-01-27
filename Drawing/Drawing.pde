// REQUIRES
// https://github.com/ThomasLengeling/KinectPV2

import KinectPV2.KJoint;
import KinectPV2.*;
import interfascia.*;

KinectPV2 kinect;

import processing.net.*; 
Client myClient;

Table table;
String[] list;
int rows;
GUIController c;
IFButton b1;

ArrayList<PairLineList> skeletondata;


void setup() {
  size(1920, 1080);
  
  //myClient = new Client(this, "127.0.0.1", 5204);
  
  c = new GUIController (this);
  PFont font = loadFont("LaoMN-48.vlw"); //<>//
  textFont(font, 32);
  
  IFLookAndFeel colorScheme = new IFLookAndFeel(this,IFLookAndFeel.DEFAULT);
  colorScheme.baseColor = color(239, 35, 60);
  colorScheme.highlightColor = color(217, 4, 41);
  colorScheme.textColor = color(43,45,66);
  c.setLookAndFeel(colorScheme);
  b1 = new IFButton ("Generate Category", 20, 10);
  b1.setSize(160,60);
  b1.addActionListener(this);
  c.add(b1);
  
  
  table = loadTable("categories.csv", "header");
  rows = table.getRowCount();
  //println(table.getRowCount() + " total rows in table"); 
  list = new String[table.getRowCount()];
  int counter = 0;
  for (TableRow row : table.rows()) {

    String category = row.getString("categories");
    list[counter] = category;

    counter ++;
    //println(category);
  }
   
  background(255);
   //<>//
  skeletondata = new ArrayList<PairLineList>();

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();

}

void draw() {

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
        
        if (rightJoint.getState() == KinectPV2.HandState_Open) {
          PVector vec = new PVector(rightJoint.getX(), rightJoint.getY());
          skd.rightColNow = positionCheck(vec, skd.rightColNow);
          Line rightLine = new Line(vec, skd.rightColNow);
          skd.right.add(rightLine);
        } else if (rightJoint.getState() == KinectPV2.HandState_Lasso) {
          skd.right = new ArrayList<Line>();
          //skd.left = new ArrayList<Line>();
        } else if (rightJoint.getState() == KinectPV2.HandState_Closed) {
          Line rightLine = new Line(new PVector(rightJoint.getX(), rightJoint.getY()), color(255));
          skd.right.add(rightLine);
        }
        
        if (leftJoint.getState() == KinectPV2.HandState_Open) {
          PVector vec = new PVector(leftJoint.getX(), leftJoint.getY());
          skd.leftColNow = positionCheck(vec, skd.leftColNow);
          Line leftLine = new Line(vec, skd.leftColNow);
          skd.left.add(leftLine);
        } else if (leftJoint.getState() == KinectPV2.HandState_Lasso) {
          //skd.right = new ArrayList<Line>();
          skd.left = new ArrayList<Line>();
        } else if (leftJoint.getState() == KinectPV2.HandState_Closed) {
          Line leftLine = new Line(new PVector(leftJoint.getX(), leftJoint.getY()), color(255));
          skd.left.add(leftLine);
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
  fill(255, 0, 0);  // RED
  rect(9*width/10, 0, width/10, height/5);
  fill(0, 255, 0);  // GREEN
  rect(9*width/10, height/5, width/10, 2*height/5);
  fill(0, 0, 255);  // BLUE
  rect(9*width/10, 2*height/5, width/10, 3*height/5);
  fill(255, 255, 0);  // YELLOW
  rect(9*width/10, 3*height/5, width/10, 4*height/5);
  fill(0, 255, 255);  // CYAN
  rect(9*width/10, 4*height/5, width/10, height);
  
  fill(255, 0, 255);  // MAGENTA
  rect(0, 0, width/10, height/5);
  fill(255, 165, 0);  // ORANGE
  rect(0, height/5, width/10, 2*height/5);
  fill(128, 0, 128);  // PURPLE
  rect(0, 2*height/5, width/10, 3*height/5);
  fill(255, 105, 180);  // PINK
  rect(0, 3*height/5, width/10, 4*height/5);
  fill(165, 42, 42);  // BROWN
  rect(0, 4*height/5, width/10, height);

  PImage pi = get(width/10, 0, width/8, height);
  pi.resize(28, 28);
  pi.filter(GRAY);
  pi.filter(INVERT);
  pi.loadPixels();

  for (int i = 0; i < 28*28; i++) {
    //myClient.write(pi.pixels[i]);
    //print((pi.pixels[i] & 0xFF) + "  ");
  }
  //println();
  // myClient.write(pi.pixels);

}

color positionCheck(PVector vec, color deflt) {
  
  float x = vec.x;
  float y = vec.y;
  
  if ( (x >= 9*width / 10)
    && (x < width)) {
      if ((y >= 0) && (y < height/5)) {
        //RED
        return color(255,0,0);
      } else if ((y >= height/5) && (y < 2*height/5)) {
        //GREEN
        println("GREEN");
        return color(0,255,0);
      } else if ((y >= 2*height/5) && (y < 3*height/5)) {
        //BLUE
        return color(0,0,255);
      } else if ((y >= 3*height/5) && (y < 4*height/5)) {
        //YELLOW
        return color(255,255,0);
      } else if ((y >= 4*height/5) && (y < height)) {
        //CYAN
        return color(0,255,255);
      }
  } else if ( (x >= 0)
    && (x < width / 10)) {
      if ((y >= 0) && (y < height/5)) {
        //MAGENTA
        return color(255,0,255);
      } else if ((y >= height/5) && (y < 2*height/5)) {
        //ORANGE
        return color(255, 165, 0);
      } else if ((y >= 2*height/5) && (y < 3*height/5)) {
        //PURPLE
        return color(0,0,255);
      } else if ((y >= 3*height/5) && (y < 4*height/5)) {
        //PINK
        return color(255, 105, 180);
      } else if ((y >= 4*height/5) && (y < height)) {
        //BROWN
        return color(165, 42, 42);
      }
  }
  return deflt;

}

void actionPerformed(GUIEvent e) {
  textSize(22);
  fill(217, 4, 14, 100);
  background(255);
  int n = (int) random(0, rows);
  text(list[n], 200, 40);
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
