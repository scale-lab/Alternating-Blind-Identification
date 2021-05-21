# Source

The folder contains all files needed to run the full flow, from training the BPI A and B matrices to predicting power per clusters.

1. `main_BPI.m`: main script to run EM-BPI flow. The script generates intermediate files needed for BPI training and plots the output results. 
2. `eval_runtime.m`: function used to perform the runtime evaluation to find the power vector.
3. `invert_t2p.m`: function used by the eval_runtime script.
4. `find_A.m`: function used by the main script to find the A matrix.
5. `transients_get_indices.m`: finds indices of transient traces used for BPI.
6. `transients_extracts.m`: extracts transient traces from each cluster and preprocesses for BPI.
7. `plot_ncores.m`: plots thermals per core, total power, and power per core based on _n_ number of cores.
8. `visualize_indices.m`: helper to visualize transient traces in intermediate steps.
9. `print_indices.m`: helper to read transient traces.
