function [ Coeff,Beta_normalized, T, Tw] = Tree_Guide_Lasso_Coeff(input, output,hyp,opts)

%% step1.Tree structure learning by clustreing
lambda = hyp(1);
h = hyp(2);
dim_output  = size(output,2);
if isfield(opts, 'T') & isfield(opts,'Tw')
    T=opts.T;
    Tw=opts.Tw;
else

    if dim_output>=3        
        myDist = tril(1-abs(fastCorr(output)), -1);
        myCluster=linkage(myDist(myDist~=0)', 'complete');
%         dendrogram(myCluster)
        [T Tw] = convH2T(myCluster, h);
        idx=full(sum(T,2)==1);
        T(idx,:)=[];
        Tw(idx)=[];
    elseif dim_output==2
        T=sparse([0;1]);
        Tw = tril(1-abs(fastCorr(output)), -1);
    else
        T=sparse(1);
        Tw = 1;
    end
end

%% ste2p. estimate coeff
[input_zscore, variable_info.input_mean, variable_info.input_std]  = zscore(input);    
[output_zscore, variable_info.output_mean, variable_info.output_std]  = zscore(output);    

dim_input = size(input,2);

num_interior_node = length(Tw);
mu =dim_input * num_interior_node /2;
[X, Y, XX, XY, C, g_idx, TauNorm, L1] = pre_grad(input_zscore,output_zscore, T, Tw);

L=L1 + lambda^2*TauNorm/mu;
[Beta_normalized, ~,~] = accgrad_init( Y, X, lambda, T,  XX, XY, C, g_idx, L, mu, opts);     


Coeff.b1 = Beta_normalized.* repmat(variable_info.output_std,dim_input,1)./repmat(variable_info.input_std',1,dim_output);
nan_idx = find(isnan(Coeff.b1));
Coeff.b1(nan_idx)=0;
Coeff.b0 = variable_info.output_mean - nansum(Beta_normalized.*repmat(variable_info.input_mean',1,dim_output)./repmat(variable_info.input_std',1,dim_output)) .* variable_info.output_std ;

% t1 = (input_zscore * Beta_normalized) .* repmat(variable_info.output_std,size(input,1),1) + variable_info.output_mean;
% t2 = input * Coeff.b1 + Coeff.b0;

end

