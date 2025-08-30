# Artifact Appendix

Paper title: **Time-Efficient Locally Relevant Geo-Location Privacy Protection**

Artifacts HotCRP Id: **10**

Requested Badge: **Available**

## Description
This repository contains the source code related to the methodologies and experiments presented in the paper titled **"Time-Efficient Locally Relevant Geo-Location Privacy Protection"**.

The file **`main.m`** implements the data obfuscation algorithm **LR-Geo** proposed in the paper. This algorithm facilitates geo-obfuscation by focusing on locally relevant locations for each user, optimizing location privacy while maintaining computational efficiency through **linear programming (LP)**. It also incorporates the **Benders' decomposition technique** to efficiently solve large-scale LP problems, as discussed in the paper.

### Security/Privacy Issues and Ethical Concerns
There are no security or ethical concerns.

## Basic Requirements
### **Recommended Hardware Requirements**
- **Processor**: Dual-core CPU or higher
- **Memory**: 8 GB RAM (16 GB recommended for larger datasets)
- **Disk Space**: 2 GB of free space for MATLAB installation and artifact files

### **Supported Operating Systems**
- **Windows 10/11**
- **macOS Monterey/Ventura**
- **Ubuntu Linux 20.04/22.04**

### Estimated Time and Storage Consumption
Provide an estimated value for the time the evaluation will take and the space on the disk it will consume. 
This helps reviewers to schedule the evaluation in their time plan and to see if everything is running as intended.
More specifically, a reviewer, who knows that the evaluation might take 10 hours, does not expect an error if, after 1 hour, the computer is still calculating things.

## Environment 

### Accessibility
The source code for the artifact can be accessed via a persistent repository hosted on GitHub at the following link: https://github.com/chenxiunt/LocalRelevant_Geo-Obfuscation.
Commit-ID: d0a1f295db85889f91b6b6b08955c3bc2be8bf96

### Set up the environment
The code was developed and tested using **MATLAB R2024a** with the **Optimization Toolbox** and **Statistics and Machine Learning Toolbox** installed. The toolboxes include the [**`linprog`**](https://www.mathworks.com/help/optim/ug/linprog.html) function for linear programming and the [**`randsample`**](https://www.mathworks.com/help/stats/randsample.html) function for random sample.


### Testing the Environment
```bash
simplified_experiment
```
for an simplified experiment 
and 
```bash
main
```
for the original experiment

## Artifact Evaluation
### Main Results and Claims
#### Main Result 1: Computation time (displayed as "LR-Geo" in Table 1)
LR-Geo has higher computational time compared to Laplace and ExpMech, it significantly outperforms both LP and ConstOPT in terms of efficiency (described in the first paragraph of Section 5.2.1). 

#### Main Result 2: Cost (displayed as "LR-Geo" in Table 2)
LR-Geo significantly reduces the expected cost compared to Laplace and ExpMech (described in the first paragraph of Section 5.3.1). 

### Experiments 
#### Experiment 1: Computation time
This experiment is conduct to support the **Main Result 1**. 

To run the ***simplified version*** of the experiment, please run the following code 
```bash
simplified_experiment
```
and the results are stored in the MAT file "computation_time.mat". The computation time of should be around 1.20 to 1.50 seconds. The experiment takes approximately 2-3 minutes. 

To run the original experiment, please run the following code 
```bash
main
```
and the results are stored in the MAT file "computation_time.mat". The computation time of should be around 1.20 to 1.50 seconds. Note that, to run the original experiment, it takes longer time since the server needs to calculate the cost reference table. The variable "NR_LOC" is changed from 1 to 4, and each experiment needs to be repeated for 20 times. It takes approximately 3 days to complete this experiment. 


#### Experiment 2: Cost
This experiment is conduct to support the **Main Result 2**. 

To run the ***simplified version*** of the experiment, run the following code 
```bash
simplified_experiment
```
and the results are stored in the MAT file "cost.mat". The cost value should be up to approximately 380 meters (or 0.38 kilometers). The experiment takes approximately 2-3 minutes. 

To run the original experiment, please run the following code 
```bash
main
```
Similar to Experiment 1, the original experiment takes a longer time since the server needs to calculate the cost reference table. The variable "NR_LOC" is changed from 1 to 4, and each experiment needs to be repeated for 20 times. It takes approximately 3 days to complete this experiment. 

## Limitations
The key outcome of our method—computation time (as shown in Table 1 and Figures 9(a) and 9(b))—is sensitive to changes in the running environment. While the exact results may not be fully consistent due to these variations, we expect the results to remain at a comparable level.

