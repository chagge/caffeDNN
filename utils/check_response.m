res = DNN.caffe_mex('get_response_solver', 'fc2');
res = res{1};
res = reshape(res, [], para.num_per_gpu*numel(para.gpuid));
[~,max_t] = max(res);
figure(3)
hist(max_t, 10);
if numel(unique(max_t)) < numel(max_t)*0.1
    fprintf('Response checked failed! %d / %d\n', numel(unique(max_t)), numel(max_t));
end