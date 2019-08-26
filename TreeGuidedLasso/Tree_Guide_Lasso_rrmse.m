function [rrmse_each ] = Tree_Guide_Lasso_rrmse(input, output ,idx_hyp, hyp, option )
%%
    num_fold = max(idx_hyp);
    num_target = size(output,2);
    fold=1;
    for fold=1:num_fold
        test_idx = idx_hyp ==fold;
        train_idx = ~test_idx;

        train_input= input(train_idx,:);
        train_output= output(train_idx,:);   
        test_input = input(test_idx,:);

        [ Coeff] = Tree_Guide_Lasso_Coeff(train_input, train_output,hyp,option);

        test_output = output(test_idx,:);
        test_output_hat = test_input * Coeff.b1 + Coeff.b0;
        resi_tgl = test_output_hat - test_output;
        resi_mean = test_output - repmat(mean(train_output), size(test_output,1),1);
        if sum(test_idx)>=2
            rrmse_fold(fold,1:num_target) = sqrt(sum(resi_tgl.^2)./sum(resi_mean.^2));
        else
            rrmse_fold(fold,1:num_target) = sqrt((resi_tgl.^2)./(resi_mean.^2));            
        end
        if max(rrmse_fold(fold,:))==inf
            idx = find(rrmse_fold(fold,:)==inf);            
            rrmse_fold(fold,idx) =nan;
%             resi_train_all =  train_output - (train_input * Coeff.b1 + Coeff.b0);
%             rrmse_fold(fold,idx) = sqrt(mean(resi_tgl(:,idx).^2))/ sqrt(mean(resi_train_all(:,idx).^2));              
        end
    end
    rrmse_each = nanmean(rrmse_fold);
%     rrmse_total = mean(rrmse_each);

end

