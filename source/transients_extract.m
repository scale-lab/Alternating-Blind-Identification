% Copyright (c) 2021, SCALE Lab, Brown University
% All rights reserved.

% This source code is licensed under the license found in the
% LICENSE file in the root directory of this source tree. 

function [transient_state] = extract_transients(data, change_ind_trans)
% Extracts transient traces from data by for all indices
% :inputs:
% data : the cluster, a function output of get_transient_indices
% change_ind_trans : the intervals for which transient states are captured
% :returns:
% transient_state : matrix of transient_states from the given data.
%                   Each row is a data point from one transient interval.
%                   Each col is a new transient interval.
    current_state = data(:,1);
    i = 1;
    transient_state = double.empty;
    while i < size(change_ind_trans, 1) % add to new columns
       transient_state = [transient_state current_state(change_ind_trans(i):change_ind_trans(i+1))];
       i = i+2;
    end
end
