
function ind_str = print_indices(indices)
% Displays transient states in a human readable format
% :inputs:
% indices : vector of transient indices
% :returns:
% ind_str : string of transient indices

    ind_str = '';
    i = 1;
    while i < max(size(indices))
        ind_str = [ind_str '[' num2str(indices(i)) ' ' num2str(indices(i+1)) '] '];
        i = i + 2;
    end

end