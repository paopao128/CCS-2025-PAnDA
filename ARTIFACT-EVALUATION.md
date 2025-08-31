# Artifact Appendix

Paper title: **PAnDA: Rethinking Metric Differential Privacy Optimization at Scale with Anchor-Based Approximation**

Artifacts HotCRP Id: **92**

Requested Badge: **Artifacts Available**, **Artifacts Evaluated**, and **Results Reproduced**

## Description
This repository contains the source code related to the methodologies and experiments presented in the paper titled **"PAnDA: Rethinking Metric Differential Privacy Optimization at Scale with Anchor-Based Approximation"**.

The file **`main.m`** implements the **PAnDA** algorithm (*Perturbation via Anchor-based Distributed Approximation*) proposed in the paper. PAnDA is a scalable framework for **metric differential privacy (mDP)** that reduces computational overhead by allowing each user to select a small set of **anchor records**. From these anchors, **surrogate perturbation vectors** are derived for data obfuscation. This anchor-based approximation enables efficient large-scale data perturbation while maintaining strong privacy–utility tradeoffs.


### Security/Privacy Issues and Ethical Concerns
There are no security or ethical concerns.

## Basic Requirements
### **Recommended Hardware Requirements**
- **Processor**: Dual-core CPU or higher
- **Memory**: 64 GB RAM (16 GB recommended for larger datasets)
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


## Artifact Evaluation
### Main Results and Claims
#### Main Result 1: Computation time (displayed in Table 2 and Table 3)
*PAnDA-e*, *PAnDA-p*, and *PAnDA-l* have higher computational time compared to *Exponential Mechanism (EM)* and *Bayesian Remapping (EM+BR)*, it outperforms optimization-based methods including *Linear Programming (LP)*, *Coarse Approximation of LP (LP+CA)*, *Benders Decomposition (LP+BD)*, and *ConstOPTMech (LP+EM)* in terms of *computation efficiency* (described in Section **4.3.1**). 

#### Main Result 2: Utility loss (displayed in Table 4 and Table 5)
*PAnDA-e*, *PAnDA-p*, and *PAnDA-l* achieve lower *utility loss* compared to *EM*, *LP+CA*, and *EM+BR* (described in the first paragraph of **Section 4.3.2**). 

### Experiments 

The file **main.m** includes lines for running experiments on different datasets. Please first uncomment the corresponding line to select a dataset:

```matlab
% run_artifact_rome;               % Rome dataset (uniform vehicle location distribution)
% run_artifact_nyc;                % New York City dataset  (uniform vehicle location distribution)
% run_artifact_london;             % London dataset  (uniform vehicle location distribution)
% run_artifact_real_distribution;  % Rome dataset (real vehicle location distribution)
```

You can also specify the number of repeats by setting ...

After running completes, the following results will be displayed: 

#### 1. Table of Utility Loss
This result support **Main result 1 (displayed in Table 2 and Table 3 in the paper)**: *"PAnDA-e, PAnDA-p, and PAnDA-l have higher computational time compared to EM and EM+BR, it outperforms optimization-based methods including LP, LP+CA, LP+BD, and LP+EM in terms of computation efficiency"*. 

We would like to clarify that the exact computation times are **hard to reproduce** because they depend on factors beyond our control, such as hardware configuration, concurrent system load, operating system scheduling, library implementations, and randomness in the algorithm. Therefore, while relative scalability trends are consistent, absolute runtimes may vary across environments.

#### 2. Table of Computation time 
This result support **Main result 2**. 

#### 2. Figure of xxx 


## Limitations
The key outcome of our method—computation time (as shown in Table 1 and Figures 9(a) and 9(b))—is sensitive to changes in the running environment. While the exact results may not be fully consistent due to these variations, we expect the results to remain at a comparable level.

