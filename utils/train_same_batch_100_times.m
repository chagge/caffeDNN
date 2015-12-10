 for i = 1 : 100
    ret = DNN.caffe_mex('train', train_batch);
    fprintf('acc=%f, loss=%f, \n', ret(1).results, ret(2).results);
 end