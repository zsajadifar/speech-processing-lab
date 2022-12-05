function hmm = hmm_init(data, N, M, trans_stay, trans_next)

hmm.N = N;
hmm.M = M; 

%% left-to-right HMM, initial state is the first one.
hmm.init=zeros(N,1); 
hmm.init(1)=1; 

%% Transition probability 
hmm.trans=zeros(N,N);
for i=1:N-1
    hmm.trans(i,i)  =trans_stay;
    hmm.trans(i,i+1)=trans_next;
end
hmm.trans(N,N)=1;

%% Emission probability
U= length(data); % number of utterances
for u=1:U
    T=size(data(u).features,1); % number of frames 
    data(u).segment=floor([1:T/N:T T+1]);
end

for i=1:N
    state_sample=[];
    for u=1:U 
      idx1=data(u).segment(i);
      idx2=data(u).segment(i+1)-1;
      state_sample=[state_sample;data(u).features(idx1:idx2,:)];
    end
    emis(i).mean = mean(state_sample);
    emis(i).cov  = diag(cov(state_sample))'; 

end
hmm.emis=emis;

end
