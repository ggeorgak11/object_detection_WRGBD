## RGB-D Multi-View Object Detection with Object Proposals and Shape Context 
Georgios Georgakis, Md Alimoor Reza, Jana Kosecka, IROS 2016

This is MATLAB code for running the single-view and multi-view object detectors on the WRGB-D dataset.

### Instructions and code details
There are three main m files that can be used to run the experiments shown in the paper.
1) multiview.m  : Runs multiview detection on all frames of the WRGB-D scenes dataset v2. Note that the script needs to run for all frames of a certain scene in order to produce scene results.
2) singleview.m : Runs singleview detection on all frames of the WRGB-D scenes dataset v2. If someone wishes to run detection for a single category on a frame, then use function /detector/class_specific_detector.m. 
3) create_codebook.m : Creates a new codebook for a certain object category by reading through the provided data files. This script reads from a pre-computed file [object_objectInstance_viewpoints_nViews_data.mat] which includes a structure of the training data of the specific object instance grouped based on the pose annotation. The pre-computed files for the 6 object categories available in the scenes are not provided, but can be created by running viewpoint_discretization.m (details inside the m file). After all data files are created for an object category, then run create_codebook.m to get its codebook. Note that the codebooks used in the experiments are provided [here](https://cs.gmu.edu/~ggeorgak/) (the 'code' link). Please put the codebooks under codebooks/codebook_files/.

Three init m files:
1) set_paths.m : Includes the necessary paths for the experiments to run. Edit the paths accordingly to your system. Also, you might need to slightly modify the paths in the beginning of multiview.m and singleview.m. No need to run this script individually as it is run in the beginning of multiview.m and singleview.m.
2) set_init_params.m : Sets all necessary parameters for detection.
3) set_training_params.m : Sets all necessary parameters for creating a new codebook. 
Note that these scripts are run in the three main m files, so there is no need to run them individually.

### External Sources (included in the code)
1) Some of the functions in class_specific_detector.m and create_codebook.m are taken (and edited) from the work of Liming Wang on the paper:
Wang, Liming, Jianbo Shi, Gang Song, and I-fan Shen. "Object detection combining recognition and segmentation." In Asian conference on computer vision. 2007. 
2) /utilities/depthToCloud.m : Helper function downloaded from http://rgbd-dataset.cs.washington.edu/software.html. Slightly edited.
3) /utilities/fill_depth_colorization.m : Used as is from the NYU dataset v2 toolbox. http://cs.nyu.edu/~silberman/datasets/nyu_depth_v2.html
4) Mean-shift code in /proposals/mean_shift/ taken from https://www.mathworks.com/matlabcentral/fileexchange/10161-mean-shift-clustering
5) Support surfaces: The mex files in /support_surface/plane_estimation/ which create the initial segmentation based on plane detection
are taken from the work of Taylor and Cowley on the paper:
Taylor, Camillo J., and Anthony Cowley. "Parsing indoor scenes using rgb-d imagery." Robotics: Science and Systems. Vol. 8. 2013. 

### External Sources (not included in the code)
1) The gPb edge detector used in our work can be downloded here: https://www2.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/segbench/code/segbench.tar.gz
Position the extracted folder in the ../segbench as shown in the set_paths.m (assuming your working folder is the code root). In our case, the edge detector code did not need to be compiled and could be used directly.

### Citation
If you use this code for your research, please consider citing:
```
@inproceedings{georgakis2016rgb,
  title={RGB-D multi-view object detection with object proposals and shape context},
  author={Georgakis, Georgios and Reza, Md Alimoor and Ko{\v{s}}ecka, Jana},
  booktitle={2016 IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS)},
  pages={4125--4130},
  year={2016},
  organization={IEEE}
}
```

