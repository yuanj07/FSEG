This software implements the factorization-based segmentation algorithm. Please cite the following paper if you use the code. 

J. Yuan, D. L. Wang, and A. M. Cheriyadat. Factorization-based texture segmentation. IEEE Transactions on Image Processing, 2015.

This is a software for non-commercial purpose. Please contact the author for commercial use.

Instruction:

To run the code, you need to install Matlab with image processing tool box and mex is configured correctly (type mex -setup in the matlab prompt).

1. Run the following commands in the matlab prompt. This only needs to be done once.
mex SHcomp.c
mex SHedge_1s.c

2. Run demoFctSeg.m. This segments an aerial image. 
 

Jiangye Yuan
yuanj@ornl.gov
  

