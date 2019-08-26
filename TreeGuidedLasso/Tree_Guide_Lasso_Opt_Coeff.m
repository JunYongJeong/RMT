function [Coeff_origin,Coeff_normalized, Output_tree] =...
Tree_Guide_Lasso_Opt_Coeff(input,output, idx_hyp,opts)

%% step0. Lambda bounds
if isfield(opts,'T') & isfield(opts,'Tw')
    bound = [0.1, 10; 0.7,0.7];
else
    bound = opts.bound;
end



%% step1. Bayesian optimization

result_diplay = 0; % print intermidiate results
result_save = 0; % save intermidiate result and return to the third argument; x5 contains all the intermidiate results in [x1,x2,x3,x4,x5] = IMGPO()
plot_func = 0;  % plot objective function if the dimensionality is <= 2
plot_point = 0; % plot data points if the dimensionality is <= 2

fun = @(hyp) (mean(Tree_Guide_Lasso_rrmse(input, output ,idx_hyp, hyp, opts)) * -1);

[hyp_opt,f] = IMGPO_default_run(fun,2,bound,opts.bo_iter, result_diplay, result_save, plot_func, plot_point);
[Coeff_origin,Coeff_normalized,Output_tree.T,Output_tree.Tw] = Tree_Guide_Lasso_Coeff(input, output,hyp_opt, opts);
% fun(lambda_opt)

end

