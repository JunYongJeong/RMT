clc
clear
addpath(genpath('..'))
warning off all;
%%
Num_train = 50;
% Num_test =50;
dim_input = 5;
dim_output =2;


coef1 = [2, -1; -1, 0; 0 1 ;0 2  ; 1 -1 ];
coef2 = [2, -1, ; 2 1 ; 0 0  ; 0 0 ; 0 -1 ];

train_input = zscore(rand(Num_train,dim_input));
train_output = zeros(Num_train,dim_output);

idx1 = train_input(:,4) <=0;
idx2 = train_input(:,4) >0;

train_output(idx1,:) = train_input(idx1,:) * coef1;
train_output(idx2,:) = train_input(idx2,:) * coef2;

opts.tFlag = 0;     
opts.tol = 10^-5;   
opts.maxIter=1000;
opts.bo_iter=50;
opts.verbose = false;
opts.hyp_fold =10;
opts.max_depth=2;
opts.alpha_improve= 0.05;
opts.bound = [0.001, 10;0.5, 0.8];
opts.num_candi=6;
opts.min_leaf=20;


%% step1. learn root model
idx_hyp = crossvalind('Kfold',Num_train, opts.hyp_fold);

[Coeff_origin, Coeff_normalized, Output_tree] = Tree_Guide_Lasso_Opt_Coeff(train_input,train_output,idx_hyp,opts);

% transfer root model information
opts.init_mdl.coeff_origin = Coeff_origin;
opts.init_mdl.coeff_normalized = Coeff_normalized;
opts.T = Output_tree.T;
opts.Tw = Output_tree.Tw;

%%



%% step2. growing RMT
[train_output_RMT,test_output_RMT, node_info ] = RMT_main( train_input, train_output,train_input, opts );

% test_output_RMT2 = MT_forecasting(node_info,test_input,'output');

