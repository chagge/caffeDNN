function response = get_response( layername )
    if nargin < 1
        layers = get_net_struct();
        for i = 1 : length(layers)
            response(i).name = layers{i};
            response(i).resp = DNN.caffe_mex('get_response_solver', layers{i}){1};
        end
    else
        response(i).name = DNN.caffe_mex('get_response_solver', layername);
    end
end

