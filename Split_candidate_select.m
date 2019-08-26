function [selected_candidate ] = Split_candidate_select(Node_info, current_node, input, output,opts )
%UNTITLED 이 함수의 요약 설명 위치
%   자세한 설명 위치
%%  step1
    current_input = input(Node_info(current_node).Data_idx,:);
    current_output= output(Node_info(current_node).Data_idx,:);
    resi = current_output - (current_input*Node_info(current_node).coeff_origin.b1 + Node_info(current_node).coeff_origin.b0);
    
    dim_output = size(resi,2);
    dim_input = size(current_input,2);  
    
    cnt=1;
    total_candidate = [];
    for d2=1:dim_input
        temp_input = current_input(:,d2);
        [threshold_valid,prop,idx_set] = Split_candidate_init(temp_input, opts);         
        for i=1:length(threshold_valid)
            total_candidate(cnt).variable = d2;
            total_candidate(cnt).threshold = threshold_valid(i);
            total_candidate(cnt).left_idx =idx_set.left{i};
            total_candidate(cnt).right_idx=idx_set.right{i};    
            cnt=cnt+1;
        end
    end
    %% step2
    num_candi = length(total_candidate);
%     resi_zscore = zscore(resi);
    output_std = sqrt(diag(opts.output_cov));
    num_resi = size(resi,1);
    resi_zscore=resi./repmat(output_std', num_resi,1);
    
    dim1=1;
    dim2=2;
    rng('default')

    net = selforgmap([1 2]);                   
    net.trainParam.showWindow=false;
    net = train(net, resi_zscore');
    idx = net(resi_zscore');            
    idx = vec2ind(idx)';
    current_loss = ML_Hamming_by_freq(idx);   
    
    for i=1:num_candi
        child_loss(i,1) = ML_Hamming_by_freq(idx(total_candidate(i).left_idx,:)); 
        child_loss(i,2) = ML_Hamming_by_freq(idx(total_candidate(i).right_idx,:)); 
        child_loss(i,3) = (length(total_candidate(i).left_idx) *child_loss(i,1)  + length(total_candidate(i).right_idx) * child_loss(i,2) ) / num_resi;
        Improved(i,1) = current_loss -child_loss(i,3);
    end

    if length(total_candidate)>0 & max(Improved)>0
        [sorted_info(:,1), sorted_info(:,2)] = sortrows(Improved,[-1]);        
        candi_idx = find(sorted_info(:,1)>0,opts.num_candi);
        selected_candidate = total_candidate(sorted_info(candi_idx,2));    

    else
        selected_candidate=[];
    end

    


end
