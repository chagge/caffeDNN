if ~exist('train_batch', 'var')
    train_batch{1}{1} = randi([-128,128], [224,224,3,10], 'single');
    train_batch{1}{2} = randi([0,1000], [1,1,1,10], 'single');
end
st = tic();
for i = 1 : 100
    tic
    ret = DNN.caffe_mex('train', train_batch);
    fprintf('acc=%f, loss=%f, \n', ret(1).results, ret(2).results);
    toc
end
toc(st)