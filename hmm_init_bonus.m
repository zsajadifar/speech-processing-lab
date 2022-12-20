function [hmm,phonemes,data]=hmm_init_bonus(data,digits,digit_list,phonemes,phonemes_list)

%% Segment time frames of each uttereance for initialization 
% and find the mean and cov for each phonemes'hmm
num_states=3;
U = length(data);
num_features = size(data(1).features,2);

for u=1:U

    digit = data(u).transcription;
    digit_phonemes = digits.(digit);
    T=size(data(u).features,1); % number of frames
    N = num_states*length(digit_phonemes); % number of states
    if T<N
        data(u).features = [data(u).features;data(u).features(end-mod(N,T):end,:)];
    end
    T=size(data(u).features,1); 
    data(u).segment=floor([1:T/N:T T+1]); 

    seg =1;
    for i=1:numel(digit_phonemes)
        phoneme_char = digit_phonemes(i);
        for j=1:num_states
            idx1=data(u).segment(seg);
            idx2=data(u).segment(seg+1)-1;
            phonemes.(phoneme_char).frames(j).frame=[phonemes.(phoneme_char).frames(j).frame ;double(data(u).features(idx1:idx2,:))];
            seg = seg+1;
        end
    end
end

for i=phonemes_list
    for j=1:num_states
        phonemes.(i).emis(j).mean = mean(phonemes.(i).frames(j).frame);
        phonemes.(i).emis(j).cov  = diag(cov(phonemes.(i).frames(j).frame))';
    end
end

%% initialize hmm of each word
trans_stay = 0.9;
trans_next = 0.1;
for d=1:length(digit_list)
    hmm(d).digit=digit_list(d); 
    hmm(d).phonemes = digits.(digit_list(d));
    hmm(d).N = num_states*length(hmm(d).phonemes);
    N = hmm(d).N;
    hmm(d).init=zeros(N,1); 
    hmm(d).init(1)=1; 
    hmm(d).trans=zeros(N,N);
    for i=1:N-1
        hmm(d).trans(i,i)  =trans_stay;
        hmm(d).trans(i,i+1)=trans_next;
    end
    hmm(d).trans(N,N)=1;

end

end

