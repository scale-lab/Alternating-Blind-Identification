% Copyright (c) 2021, SCALE Lab, Brown University
% All rights reserved.

% This source code is licensed under the license found in the
% LICENSE file in the root directory of this source tree. 

function [A]=find_A(pre_fname, num_traces, T_amb,num_cores)
% Estimates natural response matrix
%
% This function estimates the natural response matrix A in T[k]=AT[k-1]+P[k} 

    Tk_1 = [];    
    Tk = [];

    for i=1:num_traces
        fname = sprintf('%s%d%s', pre_fname, i,'.csv');
        D = csvread(fname);
        Tk_1 = [Tk_1; D(1:end-1,1:num_cores)];
        Tk = [Tk; D(2:end, 1:num_cores)];
    end
    Tk=Tk/1000;
    Tk_1=Tk_1/1000;
    
    Tk = Tk-T_amb;
    Tk_1 = Tk_1-T_amb;    
    Tk = Tk';
    Tk_1 = Tk_1';
    
   
    
    n = size(Tk, 1);
    A = zeros(n, n);
    for i=1:n    
        A(i,:)=lsqnonneg(Tk_1',Tk(i,:)');
    end
end
