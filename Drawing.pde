// REQUIRES
// https://github.com/ThomasLengeling/KinectPV2

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

void setup() {
  size(1920, 1080, P3D);
  background(255);

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
}

void draw() {

  //image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      //draw different color for each hand state
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }
  text(frameRate, 50, 50);
}

//draw hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 30, 30);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Closed:
    noFill();
    break;
  case KinectPV2.HandState_Lasso:
    background(255);
    noFill();
    break;
  case KinectPV2.HandState_NotTracked:
    noFill();
    break;
  }
}
