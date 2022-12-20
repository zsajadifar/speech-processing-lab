function [prob,q] = viterbi(data, hmm)
% data: one utterance, Txfeatures
T = size(data,1);
N = hmm.N;
init = hmm.init;
trans = hmm.trans;
init = log(init);
trans= log(trans);

% initialize phi with feature at t=1
for n =1:N
   phi(1,n)= init(n) + generate_log_gaussian(data(1,:), hmm.emis(n).mean, hmm.emis(n).cov);
end

% recursion
% Here, we can just save current and previous timesamples for phi
for t = 2:T
    for n=1:N
        [phi(t,n),psi(t,n)]= max(phi(t-1,:)+ trans(:,n)');
        phi(t,n)= phi(t,n) + generate_log_gaussian(data(t,:), hmm.emis(n).mean, hmm.emis(n).cov);
    end
end

% termination
q = zeros(T,1);
[prob, q(T)]=max(phi(T,:));

for t=T-1:-1:1
    q(t)=psi(t+1,q(t+1));
end

end