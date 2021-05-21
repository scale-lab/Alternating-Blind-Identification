% Sherief Reda (Brown University) and Adel Belouchrani (ENP)
% "Blind Identification of Power Sources in Processors", in IEEE/ACM Design, Automation & Test in Europe, 2017.
% sherief_reda@Brown.edu and adel.belouchrani@enp.edu.dz

function p=eval_runtime(fname, A, B,num_cores)
    E=csvread(fname);
    T = E(:, 2:num_cores+1)';
    T=T/1000;
    totalp = E(:,1)*12/1000;
    TT = T(:,2:end)-A*T(:,1:end-1);
    p = invert_t2p(B, TT, totalp(2:end), 0);
end