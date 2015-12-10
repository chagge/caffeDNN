weight = DNN.caffe_mex('get_weights_solver');
layer_num = numel(weight);
for i = 1 : layer_num
    if sum(weight(3).weights{1}(:)==0) > numel(weight(3).weights{1})*0.8
        fprintf('Check failed: Layer %d check error.\n', i);
    end
end