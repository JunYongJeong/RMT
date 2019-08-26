function [ Split_info, whether_keep_growing] =Split_candidate_eval(selected_candidate,current_node, Node_info, input, output, opts);

    %% step1
    whether_keep_growing = false;
    Split_info = [];
    n=1;i=1;
    current_input = input(Node_info(current_node).Data_idx,:);
    current_output= output(Node_info(current_node).Data_idx,:);   
    output_std = sqrt(diag(opts.output_cov));
    opts.b0 = Node_info(current_node).coeff_normalized;
    
    resi_current = current_output - (current_input * Node_info(current_node).coeff_origin.b1 + Node_info(current_node).coeff_origin.b0);
    num_resi = size(resi_current,1);
    resi_current_trans = resi_current./repmat(output_std',num_resi,1);
 
    nse_current = sum(resi_current_trans'.^2)';
   
    
    for i=1:length(selected_candidate) 
        rng('default')
        idx_hyp_left = crossvalind('Kfold',length(selected_candidate(i).left_idx),opts.hyp_fold);
        
        rng('default')
        idx_hyp_right = crossvalind('Kfold',length(selected_candidate(i).right_idx),opts.hyp_fold);

        [selected_candidate(i).left_coeff_origin, selected_candidate(i).left_coeff_normalized] =...
        Tree_Guide_Lasso_Opt_Coeff(current_input(selected_candidate(i).left_idx,:),current_output(selected_candidate(i).left_idx,:),idx_hyp_left,opts);
    
        [selected_candidate(i).right_coeff_origin, selected_candidate(i).right_coeff_normalized] =...
        Tree_Guide_Lasso_Opt_Coeff(current_input(selected_candidate(i).right_idx,:),current_output(selected_candidate(i).right_idx,:),idx_hyp_right,opts);

        resi_child(selected_candidate(i).left_idx,:) = current_output(selected_candidate(i).left_idx,:) - (current_input(selected_candidate(i).left_idx,:) * selected_candidate(i).left_coeff_origin.b1 +selected_candidate(i).left_coeff_origin.b0) ;        
        resi_child(selected_candidate(i).right_idx,:) = current_output(selected_candidate(i).right_idx,:) - (current_input(selected_candidate(i).right_idx,:) * selected_candidate(i).right_coeff_origin.b1 +selected_candidate(i).right_coeff_origin.b0) ; 
        
        resi_child_trans = resi_child./repmat(output_std',num_resi,1);
        nse_child = sum(resi_child_trans'.^2)';


        improved_info(i,1) = i;
        improved_info(i,2) = sum(nse_current-nse_child);
        improved_info(i,3) = signrank(nse_current,nse_child);
    end
        
    if length(selected_candidate)>0
        
        sorted_info=sortrows(improved_info,[3]);
        check_valid=  find(sorted_info(:,3)<opts.alpha_improve & sorted_info(:,2) >0,1);
       if length(check_valid)>0
           Split_info = selected_candidate(sorted_info(check_valid,1));
           whether_keep_growing = true;
       end
       
    end
    
    


end

