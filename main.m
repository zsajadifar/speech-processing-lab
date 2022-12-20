close all
clear all

%% devided train and test dataset directory
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

test_dir = {'test_nul.mat',
             'test_een.mat',
             'test_twee.mat',
             'test_drie.mat',
             'test_vier.mat',
             'test_vijf.mat',
             'test_zes.mat',
             'test_zeven.mat',
             'test_acht.mat',
             'test_negen.mat'};

%% number of states in HMM for each digit
state_num=[3,2,3,3,3,4,3,5,3,5];

%% number of GMM
GMM_num = 1;

%% transition probabilitoes
trans_stay=[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9]; 
trans_next=[0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1]; 


%% Train
iteration = 20;

for i=1:10
    load(train_dir{i});
    hmm_initialized = hmm_init(data, state_num(i), GMM_num, trans_stay(i), trans_next(i));
    [mu_11,log_likelihood,hmm{i}] = hmm_train(data,hmm_initialized,iteration); 

    fprintf("Finish training HMM for digit %d \n",i-1);

    figure,
    subplot(1,2,1)
    plot(log_likelihood)
    xlabel('iteration'),ylabel('${\log-likelihood}$','interpreter','latex', 'FontWeight','bold')
    title(sprintf('log-likelihood, digit %d',i-1))
    subplot(1,2,2)
    plot(mu_11)
    xlabel('iteration'),ylabel('${\mu_{11}}$','interpreter','latex', 'FontWeight','bold')
    title(sprintf('mu_{11}, digit %d',i-1))
end



%% Test
load hmm.mat
accu = zeros(1,10);
for i=1:10
  load(test_dir{i});
  U = length(data);
  correct_pred=0;
  for u=1:U
    for m=1:10
        prob(m) = viterbi(data(u).features,hmm{m});
    end
    [~,prob_max] = max(prob);
    if prob_max==i
      correct_pred = correct_pred+1;
    end
  end
  accu(i)= correct_pred /U;
  fprintf("Test accuracy for digit %d : %.2f (%d/%d).\n",i-1, accu(i), correct_pred, U);
end