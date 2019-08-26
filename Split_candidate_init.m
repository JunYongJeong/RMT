function [ threshold_valid, prop, idx_set ] = Split_candidate_init(current_input, opts)
%UNTITLED3 이 함수의 요약 설명 위치
%   자세한 설명 위치

%%
    i=1;cnt=1;
    input_values = unique(current_input);
    N = length(current_input);
    threshold_valid = [];
    threshold_init =[];
    prop=[];
    idx_set=[];
    for i=1:length(input_values)-1
%         diff = input_values(i+1) - input_values(i);
        threshold_init(i) = (input_values(i+1) +input_values(i))/2;
    end
    
    for i=1:length(threshold_init)
        left_idx = (find(current_input<threshold_init(i)));
        right_idx = (find(current_input>=threshold_init(i)));
        
        if length(left_idx) >=opts.min_leaf & length(right_idx)>=opts.min_leaf
            threshold_valid(cnt,1) = threshold_init(i);
            idx_set.left{cnt} = left_idx;
            idx_set.right{cnt} = right_idx;
            prop(cnt,1) = length(left_idx)/N;
            prop(cnt,2) = length(right_idx)/N;
            cnt= cnt+1;
        end
    end

    
end

