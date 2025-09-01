# README 

Paper title: **PAnDA: Rethinking Metric Differential Privacy Optimization at Scale with Anchor-Based Approximation**

Artifacts HotCRP Id: **92**

Requested Badge: **Artifacts Available**, **Artifacts Evaluated**, and **Results Reproduced**

## Description
This repository contains the source code related to the methodologies and experiments presented in the paper titled **"PAnDA: Rethinking Metric Differential Privacy Optimization at Scale with Anchor-Based Approximation"**. 

The file **`main.m`** implements the **PAnDA** algorithm (*Perturbation via Anchor-based Distributed Approximation*) proposed in the paper. PAnDA is a scalable framework for **metric differential privacy (mDP)** that reduces computational overhead by allowing each user to select a small set of **anchor records**. From these anchors, **surrogate perturbation vectors** are derived for data obfuscation. This anchor-based approximation enables efficient large-scale data perturbation while maintaining strong privacy–utility tradeoffs.

### Directory Structure
PAnDA artifact/
* README.md 

* paper.pdf 

* run_artifact_london.m 

* run_artifact_nyc.m 

* run_artifact_rome.m 

* main_artifact_real_distribution.m

* parameters.m 

* functions/ 

* dataset/ 



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

## Environment 

### Accessibility
The source code for the artifact can be accessed via a persistent repository hosted on GitHub at the following link: https://github.com/chenxiunt/LocalRelevant_Geo-Obfuscation.
Commit-ID: d0a1f295db85889f91b6b6b08955c3bc2be8bf96

### Set up the environment
The code was developed and tested using **MATLAB R2024b** with the **Optimization Toolbox** and **Statistics and Machine Learning Toolbox** installed. The toolboxes include the [**`linprog`**](https://www.mathworks.com/help/optim/ug/linprog.html) function for linear programming and the [**`randsample`**](https://www.mathworks.com/help/stats/randsample.html) function for random sample.


## Artifact Evaluation
### Main Results and Claims
#### Main Result 1: Computation time (displayed in Table 2 and Table 3)
*PAnDA-e*, *PAnDA-p*, and *PAnDA-l* have higher computational time compared to *Exponential Mechanism (EM)* and *Bayesian Remapping (EM+BR)*, it outperforms optimization-based methods including *Linear Programming (LP)*, *Coarse Approximation of LP (LP+CA)*, *Benders Decomposition (LP+BD)*, and *ConstOPTMech (LP+EM)* in terms of *computation efficiency* (described in Section **4.3.1**). 

#### Main Result 2: Utility loss (displayed in Table 4 and Table 5)
*PAnDA-e*, *PAnDA-p*, and *PAnDA-l* achieve lower *utility loss* compared to *EM*, *LP+CA*, and *EM+BR* (described in the first paragraph of **Section 4.3.2**). 

### Experiments 

The file **`main.m`** provides entry points for running experiments on different datasets.  
To select a dataset, **uncomment the corresponding line**:

```matlab
% run_artifact_rome;               % Rome dataset (uniform vehicle distribution)
% run_artifact_nyc;                % New York City dataset (uniform vehicle distribution)
% run_artifact_london;             % London dataset (uniform vehicle distribution)
% run_artifact_real_distribution;  % Rome dataset (real vehicle distribution)
```
The estimated running time for each "run_artifact_rome", "run_artifact_nyc", "run_artifact_london", and "run_artifact_real_distribution" is approximated one hour. 

**Configuring Repeats**: You can specify the number of experiment repetitions by setting the corresponding repeat parameter in the script (or in parameters.m, if exposed).

**Program Workflow**: When executed, the program will (1) load the dataset from the *dataset/* directory, (2) use functions routines from the *functions/* directory, and (3) apply parameters defined in *parameters.m*.

After completion, the program will display the experimental results (e.g., console outputs and/or generated figures/tables, depending on the selected experiment).

Note that, when running **`run_artifact_rome.m`**, **`run_artifact_nyc.m`**, **`run_artifact_london.m`**, or **`run_artifact_real_distribution.m`**, the methods {PAnDA-e, PAnDA-p, PAnDA-l, EM, EM+BR, LP+CA, LP} are executed automatically. Because LP+BD and LP+EM incur much higher computation time and fail to return results when the number of records is ≥ 1,000, they must be run separately using **`run_LPEM.m`** and **`run_LPBD.m`**.

#### 1. Utility loss of different algorithms 
an example table: 

|                     |   500 |  1000 |  2000 |  3000 |  4000 |  5000 |
|---------------------|------:|------:|------:|------:|------:|------:|
| EM                  | 1145.23 | 1213.73 | 1299.94 | 1302.19 | 1298.98 | 1216.03 |
| LP+CA               | 2062.99 | 2090.67 | 2144.92 | 2177.80 | 2143.94 | 2191.52 |
| EM+BR               |  995.68 | 1077.88 | 1146.57 | 1166.26 | 1181.26 | 1096.89 |
| loss(PAnDA-e)       |  318.53 |  275.24 |  316.43 |  306.87 |  269.99 |  183.67 |
| loss(PAnDA-p)       |  214.11 |  242.65 |  272.16 |  264.05 |  249.51 |  208.51 |
| loss(PAnDA-l)       |  230.74 |  249.51 |  308.08 |  260.68 |  265.62 |  274.21 |


This result support **Main result 2 (displayed in Table 4 and Table 5 in the paper)**: *PAnDA-e, PAnDA-p, and PAnDA-l achieve lower utility loss compared to EM, LP+CA, and EM+BR*. 

The exact utility loss values are **hard to reproduce** because the downstream tasks are randomly distributed, causing the measurements to vary across runs. However, the overall trend remains consistent: *PAnDA-e, PAnDA-p, and PAnDA-l achieve lower utility loss compared to EM, LP+CA, and EM+BR*, as reported in the paper.


#### 2. Computation time of different algorithms 
An example table: 

|                     |   500 |  1000 |  2000 |  3000 |  4000 |  5000 |
|---------------------|------:|------:|------:|------:|------:|------:|
| EM                  | <=0.005 | <=0.005 | <=0.005 | <=0.005 | <=0.005 | <=0.005 |
| LP+CA               | 112.91 | 114.97 | 128.98 | 138.30 | 161.96 | 160.45 |
| EM+BR               |   0.02 |   0.05 |   0.17 |   0.42 |   1.40 |   3.15 |
| PAnDA-e             |   0.33 |   0.67 |   0.83 |   1.17 |   1.58 |   1.57 |
| PAnDA-p             |   0.48 |   0.42 |   0.50 |   0.89 |   0.85 |   0.85 |
| PAnDA-l             |   0.62 |   0.75 |   1.17 |   1.16 |   1.52 |   1.30 |


This result support **Main result 1 (displayed in Table 2 and Table 3 in the paper)**: *"PAnDA-e, PAnDA-p, and PAnDA-l have higher computational time compared to EM and EM+BR, it outperforms optimization-based methods including LP, LP+CA, LP+BD, and LP+EM in terms of computation efficiency"*. 

We would like to clarify that the exact computation times are **hard to reproduce** because they depend on factors beyond our control, such as hardware configuration, concurrent system load, operating system scheduling, library implementations, and randomness in the algorithm. As a result, while the relative trends (e.g., scalability across datasets and methods) are consistent and reproducible, the absolute runtime values may vary across environments.


