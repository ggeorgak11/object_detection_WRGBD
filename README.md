## Multiview RGB-D Object Detection with Object Proposals and Shape Context 
Georgios Georgakis, Md Alimoor Reza, Jana Kosecka, IROS 2016

This is MATLAB code for running the single-view and multi-view object detectors on the WRGB-D dataset.

### Instructions and code details
#### There are three main m files that can be used to run the experiments shown in the paper.
1) multiview.m  : Runs multiview detection on all frames of the WRGB-D scenes dataset v2. Note that the script needs to run for all frames of a certain scene in order to produce scene results.
2) singleview.m : Runs singleview detection on all frames of the WRGB-D scenes dataset v2. If someone wishes to run detection for a single category on a frame, then use function /detector/class_specific_detector.m. 
3) create_codebook.m : Creates a new codebook for a certain object category by reading through the provided data files. This script reads from a pre-computed file [object_objectInstance_viewpoints_nViews_data.mat] which includes a structure of the training data of the specific object instance grouped based on the pose annotation. The pre-computed files for the 6 object categories available in the scenes are not provided, but can be created by running viewpoint_discretization.m (details inside the m file). After all data files are created for an object category, then run create_codebook.m to get its codebook. Note that the codebooks used in the experiments are provided in codebooks/codebook_files/.

Three init m files:
1) set_paths.m : Includes the necessary paths for the experiments to run. Edit the paths accordingly to your system. Also, you might need to slightly modify the paths in the beginning of multiview.m and singleview.m. No need to run this script individually as it is run in the beginning of multiview.m and singleview.m.
2) set_init_params.m : Sets all necessary parameters for detection.
3) set_training_params.m : Sets all necessary parameters for creating a new codebook. 
Note that these scripts are run in the three main m files, so there is no need to run them individually.
