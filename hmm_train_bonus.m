function [prob_iter,hmm_trained] = hmm_train_bonus(data,hmm_initialized,emis_initialized,iter,digits,digit_list,phonemes_list)

U = length(data); % number of utterance 
num_states=3;
for i=1:iter
    for p= phonemes_list
        for n=1:num_states
    
            mu_hat =0;
            cov_hat = 0;
            gamma = 0;
    
            for u=1:U
                digit = data(u).transcription;
                digit_phonemes = digits.(digit);
                if sum(digit_phonemes==p)>0
                    T = size(data(u).features,1);
                    digit = find(digit_list==digit);
                    [prob(u) , q] = viterbi_bonus(data(u).features,hmm_initialized(digit),emis_initialized);
                    q_phoneme = hmm_initialized(digit).phonemes(ceil(q/num_states))';
                    q_N = rem(q,num_states); 
                    q_N(q_N==0)=num_states;
    
                    % slide 3.75, adjust hmm parameters
                    time =1:T;
                    for t=time(q_N==n & q_phoneme==p)
                        o = data(u).features(t,:);
                        mu_hat = mu_hat + o;
                        cov_hat = cov_hat + (o - emis_initialized.(p).emis(n).mean).^2;
                    end
                    gamma = gamma + sum(q_N==n & q_phoneme==p);
                end
            end
    
            emis_initialized.(p).emis(n).mean = mu_hat / gamma;
            emis_initialized.(p).emis(n).cov  = cov_hat / gamma;
        end
    end

    prob_iter(i)=mean(prob);

end

hmm_trained = hmm_initialized;
for d=1:10
    N = hmm_trained(d).N;
    % find emis from look-up table
    emis = struct('mean',cell(N,1),'cov',cell(N,1));
    counter = 1;
    for i=1:numel(hmm_trained(d).phonemes)
        for j=1:num_states
            mu = emis_initialized.(hmm_trained(d).phonemes(i)).emis(j).mean;
            cov = emis_initialized.(hmm_trained(d).phonemes(i)).emis(j).cov;
            emis(counter).mean = mu;
            emis(counter).cov = cov;
            counter = counter+1;
        
        end
    end
    hmm_trained(d).emis = emis;
end
            

