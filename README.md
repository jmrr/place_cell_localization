
##Biologically inspired localization based on neural network training of place cell models

MATLAB prototype of a visual localization system inspired in the behaviour of hippocampal place cells in mammalian brains.

The model is produced by a bag-of-words pipeline that uses dense descriptors such as DSIFT, SF-GABOR, ST-GAUSS [(described here)](https://github.com/jmrr/visual_path_visualization). The locations are estimated by using regression with a generalized neural network.

This code has been customised and it has been tested with the [RSM dataset](http://rsm.bicv.org) of indoor sequences.

###Usage

**Normal mode**

* Rename setup.m.template to setup.m

* Define and review parameters in `setup.m`

* Run `main.m`

**Evaluation mode**

* Pre-define parameters in `setup.m`
* Run `evaluation.m`


### To-Do
Create class parameters for a complete OOP version
