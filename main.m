close all
clear all

%% devided train dataset directory
train_dir = {'train_nul.mat',
             'train_een.mat',
             'train_twee.mat',
             'train_drie.mat',
             'train_vier.mat',
             'train_vijf.mat',
             'train_zes.mat',
             'train_zeven.mat',
             'train_acht.mat',
             'train_negen.mat'};
%% number of states in HMM for each digit
state_num=[3,3,3,3,3,3,3,3,3,3];

%% number of GMM
GMM_num = 1;

%% transition probabilitoes
trans_stay=[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9]; 
trans_next=[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]; 

for i=1:10
    load(train_dir{i});
    hmm_initialized = hmm_init(data, state_num(i), GMM_num, trans_stay(i), trans_next(i));
%     hmm{i} = hmm_train(data,hmm_initialized); 
end