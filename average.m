%% average traces
function o_mat = average (in_mat, nTraces)
o_mat = zeros(size(in_mat,1),((size(in_mat,2)-1) / nTraces)+1);
o_mat(:,1) = in_mat(:,1);
for row = 1:size(in_mat,1)
    for a = 1:(size(in_mat,2)-1)/nTraces
        o_mat(row,a+1) = mean(in_mat(row,(nTraces*(a-1)+2):(nTraces*a+1)));
    end
end