function [ train_output_hat,test_output_hat,Node_info ] = RMT_main( train_input, train_output,test_input, opts )

%% 
    % step1. initialization
    
    opts.output_cov =cov(train_output);    
    num_train = size(train_input,1);
    init_mdl = opts.init_mdl;
      
    Node_info=[];
    Node_info(1).Node_type = 'Split_candi';
    Node_info(1).Data_idx = 1:num_train;
    Node_info(1).coeff_origin = init_mdl.coeff_origin;
    Node_info(1).coeff_normalized = init_mdl.coeff_normalized;
    
    Node_info(1).condition={};
    Node_info(1).parents_node=[];
    whether_keep_growing = true;    
    
    %% Step2. Tree Growing    
    while whether_keep_growing
        % step2.1 find node
        Candidate_node= [];        
        for node=1:length(Node_info)
            if strcmp(Node_info(node).Node_type,'Split_candi') & length(Node_info(node).Data_idx)>=opts.min_leaf
                Candidate_node= [Candidate_node,node];        
            else
                Node_info(node).Node_type='terminal';
            end       
        end
        whether_keep_growing=false;    
        node_candi=1;
        Split_info=[];

        for node_candi=1:length(Candidate_node) %
            current_node = Candidate_node(node_candi);
            [selected_candidate ] = Split_candidate_select(Node_info,current_node,train_input,train_output, opts);                    
            [Split_info,whether_keep_growing] = Split_candidate_eval(selected_candidate,current_node, Node_info, train_input, train_output, opts);

            if whether_keep_growing
                Split_info.current_node=current_node;
                break;
            else
                Node_info(current_node).Node_type='terminal';
            end   
        end       
        
       % step2.2 Node_info update and smoothing

        whether_keep_growing    
        if whether_keep_growing
            Node_info = Split_update(Node_info,Split_info,opts);
        end              
    end  
   
    
    %% Step3. Forecasting
    train_output_hat = MT_forecasting(Node_info,train_input,'output');
    test_output_hat = MT_forecasting(Node_info,test_input,'output');


    
end



