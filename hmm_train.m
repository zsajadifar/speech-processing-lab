function [mu_11,prob_iter,hmm_trained] = hmm_train(data,hmm_initialized,iter)

hmm_trained = hmm_initialized;
U = length(data); % number of utterance 
N = hmm_initialized.N; % number of states

for i=1:iter
    hmm = hmm_trained;

    for n=1:N

        mu_hat =0;
        cov_hat = 0;
        gamma = 0;

        for u=1:U
            T = size(data(u).features,1);
            [prob(u) , q] = viterbi(data(u).features,hmm);

            % slide 3.57,3.66, adjust hmm parameters
            time =1:T;
            for t=time(q==n)
                o = data(u).features(t,:);
                mu_hat = mu_hat + o;
                cov_hat = cov_hat + (o - hmm.emis(n).mean).^2;
            end
            gamma = gamma + sum(q==n);
        end

        hmm_trained.emis(n).mean = mu_hat / gamma;
        hmm_trained.emis(n).cov  = cov_hat / gamma;
    end

    prob_iter(i)=mean(prob);

    %Track mu_11 to see convergence of parameters
    mu_11(i)= hmm.emis(1).mean(1);
end

end
            

