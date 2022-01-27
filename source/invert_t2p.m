% Copyright (c) 2021, SCALE Lab, Brown University
% All rights reserved.

% This source code is licensed under the license found in the
% LICENSE file in the root directory of this source tree. 

function p=invert_t2p(M, T, powerm, REG)
% per-core identification
%
% This function estimates the power consumption of each core across a trace
% of data by solve T = M*P s.t., sum of column i in P is equal to powerm(i) and P is non-negative 
%
% Inputs:
%  M: model matrix
%  powerm: Total measured power trace
%  T: temperature matrix
%
% Outputs:
%  p: power matrix
%
%
    N=size(T, 1);
    H = 2*(M')*M;        
    if REG
        H=H+REG*eye(size(T, 1));
    end
    A=[];
    b=[];
    A = ones(1, N);
    lb = zeros(N, 1);
    parfor i = 1:size(T, 2)    
        options = optimset('LargeScale', 'off','Display','off');        
        f = -2*T(:, i)'*M;
        b = powerm(i);
        ub = powerm(i)*ones(N, 1);
        p(:, i) = quadprog(H, f, [] , [], A, b, lb, ub, ones(N, 1), options);   
    end
end
