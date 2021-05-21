% Sherief Reda (Brown University) and Adel Belouchrani (ENP)
% "Blind Identification of Power Sources in Processors", in IEEE/ACM Design, Automation & Test in Europe, 2017.
% sherief_reda@Brown.edu and adel.belouchrani@enp.edu.dz

function [A]=find_A(pre_fname, num_traces, T_amb,num_cores)
% Estimates natural response matrix
%
% This function estimates the natural response matrix A in T[k]=AT[k-1]+P[k} 
%
% Authors:  S.Reda and A.Belouchrani
% Supported by US NAS Grant 2016, Brown
%
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
