function net = get_net_struct()
    weight = DNN.caffe_mex('get_weights_solver');
    net = arrayfun(@(i)weight(i).layer_names, 1:length(weight), 'UniformOutput', false)';
end

