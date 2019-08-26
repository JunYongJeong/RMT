function [ Node_info] = Split_update(Node_info, Split_info,opts);
%UNTITLED3 이 함수의 요약 설명 위치
%   자세한 설명 위치


num_nodes = length(Node_info);
parents_node = Split_info.current_node;


Node_info(num_nodes+1).Data_idx= Split_info.left_idx;
Node_info(num_nodes+2).Data_idx= Split_info.right_idx;

Node_info(parents_node).Node_type='Split_done';

    

Node_info(num_nodes+1).coeff_origin = Split_info.left_coeff_origin;
Node_info(num_nodes+2).coeff_origin = Split_info.right_coeff_origin;

Node_info(num_nodes+1).coeff_normalized = Split_info.left_coeff_normalized;
Node_info(num_nodes+2).coeff_normalized = Split_info.right_coeff_normalized;


Node_info(num_nodes+1).parents_node = [Node_info(parents_node).parents_node, parents_node];
Node_info(num_nodes+2).parents_node = [Node_info(parents_node).parents_node, parents_node];

temp{1} = Split_info.variable;
temp{2} = Split_info.threshold;
temp{3} = '<=';

Node_info(num_nodes+1).condition = [Node_info(parents_node).condition; temp];
temp{3} = '>';
Node_info(num_nodes+2).condition = [Node_info(parents_node).condition; temp];

if length(Node_info(num_nodes+1).Data_idx)<2*opts.min_leaf | size(Node_info(num_nodes+1).condition,1)>=opts.max_depth
    Node_info(num_nodes+1).Node_type='terminal';
else 
    Node_info(num_nodes+1).Node_type='Split_candi';
end

if length(Node_info(num_nodes+2).Data_idx)<2*opts.min_leaf | size(Node_info(num_nodes+2).condition,1)>=opts.max_depth
    Node_info(num_nodes+2).Node_type='terminal';
else 
    Node_info(num_nodes+2).Node_type='Split_candi';
end

end

