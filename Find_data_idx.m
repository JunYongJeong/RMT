function [ idx_fin ] = Find_data_idx(Input, condition )
%UNTITLED �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
num_condition = size(condition,1);
% i=1;
idx_fin = logical(ones(size(Input,1),1));
for i=1:num_condition
    if strcmp(condition{i,3},'<=')
        idx{i} = Input(:,condition{i,1})<= condition{i,2};
    else
        idx{i} = Input(:,condition{i,1})> condition{i,2};
    end    
    idx_fin = idx_fin & idx{i};
end


end

