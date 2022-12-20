close all
clear all

load test.mat

transc = extractfield(data,'transcription');

index_nul   = find(strcmp(transc,'nul' ));
index_een   = find(strcmp(transc,'een' ));
index_twee  = find(strcmp(transc,'twee'));
index_drie  = find(strcmp(transc,'drie'));
index_vier  = find(strcmp(transc,'vier'));
index_vijf  = find(strcmp(transc,'vijf'));
index_zes   = find(strcmp(transc,'zes' ));
index_zeven = find(strcmp(transc,'zeven'));
index_acht  = find(strcmp(transc,'acht' ));
index_negen = find(strcmp(transc,'negen'));

nul   = data(index_nul);
een   = data(index_een);
twee  = data(index_twee);
drie  = data(index_drie);
vier  = data(index_vier);
vijf  = data(index_vijf);
zes   = data(index_zes);
zeven = data(index_zeven);
acht  = data(index_acht);
negen = data(index_negen);

data = nul;   save('test_nul.mat'   ,'data');
data = een;   save('test_een.mat'   ,'data');
data = twee;  save('test_twee.mat' ,'data');
data = drie;  save('test_drie.mat' ,'data');
data = vier;  save('test_vier.mat' ,'data');
data = vijf;  save('test_vijf.mat' ,'data');
data = zes;   save('test_zes.mat'  ,'data');
data = zeven; save('test_zeven.mat','data');
data = acht;  save('test_acht.mat' ,'data');
data = negen; save('test_negen.mat','data');