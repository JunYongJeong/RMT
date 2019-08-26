function [ output_hat ] = MT_forecasting(Node_info, input,type )
%UNTITLED3 이 함수의 요약 설명 위치
%   자세한 설명 위치

    for node=1:length(Node_info)
        if strcmp(Node_info(node).Node_type,'terminal')
            current_idx = Find_data_idx(input, Node_info(node).condition);   
            switch type
                case 'output'
                    output_hat(current_idx,:)=...
                    input(current_idx,:) * Node_info(node).coeff_origin.b1 + Node_info(node).coeff_origin.b0;
                case 'node'
                    output_hat(current_idx,:) = node;
            
        end        
    end
    

end

