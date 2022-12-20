close all
clear all

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

%% Creat look-up tables for digits and phonemes
digit_list = ["nul", "een", "twee", "drie", "vier", "vijf", "zes", "zeven", "acht", "negen"];

digits.nul   = ["silent", "n", "y", "l","silent"];
digits.een   = ["silent", "e", "n","silent"];
digits.twee  = ["silent", "t", "w", "e","silent"];
digits.drie  = ["silent", "d", "r", "i","silent"];
digits.vier  = ["silent", "v", "i", "r","silent"];
digits.vijf  = ["silent", "v", "Eplus", "f","silent"];
digits.zes   = ["silent", "z", "E", "s","silent"];
digits.zeven = ["silent", "z", "e", "v", "at", "n","silent"];
digits.acht  = ["silent", "a", "x", "t","silent"];
digits.negen = ["silent", "n", "e", "g", "at", "n","silent"];

num_states=3;
emis = struct('mean',cell(num_states,1),'cov',cell(num_states,1));
frames= struct('frame',cell(num_states,1));
phonemes_list = ["silent","n", "y", "l", "e","t", "w", "d", "r", "i", "v", "Eplus","f","z","E","s","at","a","x","g"];
for i =1:length(phonemes_list)
    phonemes.(phonemes_list(i)).emis = emis;
    phonemes.(phonemes_list(i)).frames = frames;
end

%% Train
iteration = 10;
load train.mat
[hmm_initialized,emis_initialized,data] = hmm_init_bonus(data,digits,digit_list,phonemes,phonemes_list);
[log_likelihood,hmm_trained] = hmm_train_bonus(data,hmm_initialized,emis_initialized,iteration,digits,digit_list,phonemes_list); 

figure,plot(log_likelihood)

%% Test
load hmm_bonus.mat

accu = zeros(1,10);
for i=1:10
  load(test_dir{i});
  U = length(data);
  correct_pred=0;
  for u=1:U
    for m=1:10
        prob(m) = viterbi(data(u).features,hmm_trained(m));
    end
    [~,prob_max] = max(prob);
    if prob_max==i
      correct_pred = correct_pred+1;
    end
  end
  accu(i)= correct_pred /U;
  fprintf("Test accuracy for digit %d : %.2f (%d/%d).\n",i-1, accu(i), correct_pred, U);
end