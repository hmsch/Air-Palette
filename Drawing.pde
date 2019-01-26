// REQUIRES
// https://github.com/ThomasLengeling/KinectPV2

import KinectPV2.KJoint;
import KinectPV2.*;
import processing.svg.*;

KinectPV2 kinect;

ArrayList<SkeletonData> skeletondata;
color writeCol;

void setup() {
  size(1920, 1080);
    
  beginRecord(SVG, "frame-####.svg");
  
  background(255);
  writeCol = color(255,0,0);
  
  skeletondata = new ArrayList<SkeletonData>();

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();

}

void draw() {

  // tint(255, 127); // doesn't work... :(
  //`image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      KJoint right = joints[KinectPV2.JointType_HandRight];
      KJoint left = joints[KinectPV2.JointType_HandLeft];

      if (i >= skeletondata.size()) {
        SkeletonData skd = new SkeletonData();
        skd.right = new PVector(right.getX(), right.getY());
        skd.left = new PVector(left.getX(), left.getY());
        skeletondata.add(skd);
      } else {
        SkeletonData skd = skeletondata.get(i);

        noFill();
        strokeWeight(10);
        stroke(writeCol);
        
        if (right.getState() == KinectPV2.HandState_Open) {       
          line(skd.right.x, skd.right.y, right.getX(), right.getY());
          skd.right = new PVector(right.getX(), right.getY());
        } else if (right.getState() == KinectPV2.HandState_Lasso) {
          background(255);
        }
        
        if (left.getState() == KinectPV2.HandState_Open) {
          line(skd.left.x, skd.left.y, left.getX(), left.getY());
          skd.left = new PVector(left.getX(), left.getY());
        } else if (left.getState() == KinectPV2.HandState_Lasso) {
          background(255);
        }
        
        paletteCheck(left.getX(), left.getY());
        paletteCheck(right.getX(), right.getY());
        
      }
    }
      
  }
  
  noStroke();
  fill(255, 0, 0);
  rect(4*width/5, 0, width/5, height/5);
  fill(0, 255, 0);
  rect(4*width/5, height/5, width/5, 2*height/5);
  fill(0, 0, 255);
  rect(4*width/5, 2*height/5, width/5, 3*height/5);
  fill(255, 165, 0);
  rect(4*width/5, 3*height/5, width/5, 4*height/5);
  fill(0, 0, 0);
  rect(4*width/5, 4*height/5, width/5, height);
    
  text(frameRate, 50, 50);
}

void paletteCheck(float x, float y) {

  if ( (x >= 4*width / 5)
    && (x < width)) {
      if ((y >= 0) && (y < height/5)) {
        //RED
        writeCol = color(255,0,0);
      } else if ((y >= height/5) && (y < 2*height/5)) {
        //GREEN
        writeCol = color(0,255,0);
      } else if ((y >= 2*height/5) && (y < 3*height/5)) {
        //BLUE
        writeCol = color(0,0,255);
      } else if ((y >= 3*height/5) && (y < 4*height/5)) {
        //ORANGE
        writeCol = color(255,165,0);
      } else if ((y >= 4*height/5) && (y < height)) {
        // end record
        endRecord();
        println("Finished.");
        exit();
      }
  }

}

void mouseClicked() {
  endRecord();
  println("Finished.");
  exit();
}
