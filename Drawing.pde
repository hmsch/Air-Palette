// REQUIRES
// https://github.com/ThomasLengeling/KinectPV2

import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

ArrayList<SkeletonData> skeletondata;

void setup() {
  size(1920, 1080, P2D);
  background(255);
  
  skeletondata = new ArrayList<SkeletonData>();

  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
}

void draw() {

  image(kinect.getColorImage(), 0, 0, width, height);

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
        
        if (right.getState() == KinectPV2.HandState_Open) {
          noFill();
          strokeWeight(10);
          stroke(255, 0, 0);
          
          line(skd.right.x, skd.right.y, right.getX(), right.getY());
          skd.right = new PVector(right.getX(), right.getY(), right.getZ());
          
          line(skd.left.x, skd.left.y, left.getX(), left.getY());
          skd.left = new PVector(left.getX(), left.getY()); 
        }
      }
    }
  }
  text(frameRate, 50, 50);
}
