% Copyright (c) 2021, SCALE Lab, Brown University
% All rights reserved.

% This source code is licensed under the license found in the
% LICENSE file in the root directory of this source tree. 

function p=eval_runtime(fname, A, B,num_cores)
    E=csvread(fname);
    T = E(:, 2:num_cores+1)';
    T=T/1000;
    totalp = E(:,1)*12/1000;
    TT = T(:,2:end)-A*T(:,1:end-1);
    p = invert_t2p(B, TT, totalp(2:end), 0);
end
