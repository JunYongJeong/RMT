clc
clear
addpath(genpath('..'))
load polymer_dataset
warning off all;
%%
Num_train = 55;
train_input =X(1:Num_train,:);
train_output =Y(1:Num_train,:);

test_input =X(Num_train+1:end,:);
test_output =Y(Num_train+1:end,:);


opts.tFlag = 0;     
opts.tol = 10^-5;   
opts.maxIter=1000;
opts.bo_iter=50;
opts.verbose = false;
opts.hyp_fold =10;
opts.max_depth=3;
opts.alpha_improve= 0.1;
opts.bound = [0.1, 10;0.7,0.99];
opts.num_candi=6;
opts.min_leaf=10;


%% step1. learn root model
idx_hyp = crossvalind('Kfold',Num_train, opts.hyp_fold);

[Coeff_origin, Coeff_normalized, Output_tree] = Tree_Guide_Lasso_Opt_Coeff(train_input,train_output,idx_hyp,opts);

% transfer root model information
opts.init_mdl.coeff_origin = Coeff_origin;
opts.init_mdl.coeff_normalized = Coeff_normalized;
opts.T = Output_tree.T;
opts.Tw = Output_tree.Tw;


%% step2. growing RMT
[train_output_RMT,test_output_RMT, node_info ] = RMT_main( train_input, train_output,test_input, opts );

test_output_RMT2 = MT_forecasting(node_info,test_input,'output');

%% evaluation
test_output_TGGL = test_input*Coeff_origin.b1 + Coeff_origin.b0;

resi_TGGL= test_output - test_output_TGGL;
resi_RMT = test_output - test_output_RMT;

mean(resi_TGGL.^2)
mean(resi_RMT.^2)
