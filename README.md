# BIPEM (Blind Identification of Power Sources Using Expectation-Maximization)

BIPEM is a tool that allows to blindly estimate the power at the core level using Expectation-Maximization. The tool is a plug and play, since it requires only one data file given as input. The data file is going to be used for training to identify two modeling matrices, __A__ and __B__.  

Data for training is collected by capturing thermal and power measurements of different cores through sys nodes while stressing the different cores. The stress applied to each core should have various patterns and run at different frequencies. For example, stressing clusters individually versus combined. The more combinations, the better the results. The user must then provide power and thermal data per cluster formatted into one CSV file with power in the first column, then thermal data per cluster for the remaining columns. For example, given 4 cores (clusters), the .CSV should take this form (only numbers, first row labels for reference):
Power  | Core 1 thermals | Core 2 thermals | Core 3 thermals | Core 4 thermals
------------- | ------------- | ------------- | ------------- | -------------
66.711  | 41275 | 40500	| 42800	| 44400
75.247  | 41475 | 40500	| 42000	| 40500
...     | ...   | ...   | ...   | ...


Offline power modelling is done through this tool by:

a. Identifying the __A__ matrix using transient data ( __t__(_k_) = __A__ __t__(_k_-1) + ε \
b. Making an initial guess for the __B__ matrix \
c. Iteratively following the EM steps below:
* Given __A__ and __B__ matrices, find the power sources with quadratic optimization (Expectation step). ||__B__ __p__(_k_)-(__t__(_k_)-__A__ __t__(_k_-1))||_2, such that __p__(_k_) >= 0
* Given A, the power sources, and the temperatures, compute the __B__ matrix (Maximization step). __t__(_k_) = __A__ __t__(_k_-1) + __B__ __p__(_k_) + ε


The tool will generate a __p__ matrix containing power per core predictions using the BIPEM model as well as a figure showing the results of the BIPEM algorithm.

![Power_fig](https://user-images.githubusercontent.com/77766094/117898700-8bc7dd00-b293-11eb-81ff-5a16c758c818.png)
Sample output figure showing thermal per cluster, total power, and power per cluster using BIPEM


## Usage
The `main_BPI.m` script is mostly plug and play. 
1. The user needs to input .csv file into `input` directory. The file should contain the raw data from clusters stress experiment, with the first column including power data, and the remaining columns containing thermal data for each core (details above).
2. Change the variable `filein` at the top of the script to the input file.
3. The script will attempt to find transient traces. Follow instructions on the command line until all transient traces (specifically, traces where thermal temperature is drastically _decreasing_). For coarse grain tuning, enter `[C]` to change the initial guess by changing the sensitivity of sudden changes (previous values are shown to help with relative tuning). For fine grain transient detection:\
   i. Enter `[A]` to add base indices of missing transient traces. Simply enter space-separated integer values for each x-axis index (input only the base index). \
   ii. Enter `[R]` to remove extra indices of transient traces. Simply enter space-separated integer values for each y-axis thermal value (input only the left most value).\
   iii. Enter `[Y]` if all transient traces are accounted for and are ready to proceed with BPI.


Once transient traces are ready, the rest of the script will run without user intervention. The script will preprocess transient traces for BPI training, then plot the results. Take note that step '7/9 EM-steps' may take a while to run. The plot is automatically saved into the output folder (named for the time when the script is executed) along with `variables.mat` which contains the matrices `A`, `B`, `p`, and the following data `data`, `filein`, `transient_indices`, `num_cores` to allow for future usage without waiting for training.


## Demo

https://user-images.githubusercontent.com/77766094/118159610-37377580-b3eb-11eb-8c18-36cb71260760.mp4

Video demo showing full flow, including how to add and remove transient traces.

0:00 - input .csv file\
0:09 - adding missing transient states (if the initial guess was not sensitive enough) using data cursor tool to find index\
0:30 - verifying all transient states are accounted and running the BPI algorithm\
0:54 - final output figure showing power per core\
1:11 - removing extra transient states (if the initial guess was too sensitive)

## Requirements
MATLAB R2019a or later is required, as some functions such as `writematrix` are introduced in this version.

## License
All the source codes in this folder are licensed under the following [LICENSE](https://github.com/scale-lab/BIPEM/blob/master/LICENSE).

