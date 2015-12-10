close all;
fclose all;
clear mex;
clear testiter tr_acc tr_loss roc_lab roc_lfw iter
DNN.caffe_mex('set_random_seed', para.seed_caffe);
rand('seed', para.seed_matlab);
load_test_data;
load_meanmat;
%% begin training
trainid = randperm(para.data_num);
init_caffe;
train_batch = cell(n_gpu, 1);
if ~exist('testiter', 'var')
    testiter = 1;
    baseiter = iter-1;
else
    baseiter = 0;
end