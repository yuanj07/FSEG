# Factorization-based segmentation algorithm

This software implements the factorization-based segmentation algorithm, which is described in 

**J. Yuan, D. L. Wang, and A. M. Cheriyadat. Factorization-based texture segmentation. IEEE Transactions on Image Processing, 2015.**

This is a software for non-commercial purpose. Please contact the author for commercial use.

## Initial setup

To run the code, you need Matlab with image processing tool box and mex is configured correctly (type mex -setup in the matlab prompt).

## Usage

Run the following commands in the matlab prompt. This only needs to be done once.
`mex SHcomp.c`
`mex SHedge_1s.c`

Run demoFctSeg.m. This segments an aerial image. 
 

  

