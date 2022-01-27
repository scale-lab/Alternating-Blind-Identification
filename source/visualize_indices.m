% Copyright (c) 2021, SCALE Lab, Brown University
% All rights reserved.

% This source code is licensed under the license found in the
% LICENSE file in the root directory of this source tree. 

function visualize_indices(indices, data, cluster)
% visualize the data and indices of interest points (steady/transient)
% :params:
% :indices: indices to visualize
% :data: data to plot, likely thermal data

    figure
    plot(data(:,cluster)); title("Indices Visualized");
    xlabel('time stamp'); 
    hold on
    for i = 1 : size(indices,1)    % add a vertical line at indices
        xline(indices(i), 'Color', 'r');
    end
end
