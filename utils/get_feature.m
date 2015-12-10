function feature = get_feature( blob, meanmat, batch_per_gpu, n_gpu, featlen, featlayer_name, prepared )
    assert(numel(size(blob))==4, 'Input must be a 4-D blob.');
    assert(size(blob,3)==3, 'Images must have 3 chanel.');
    if prepared~=1
        blob = permute(blob, [2,1,3, 4]);
        blob = blob(:,:,[3 2 1],:);
    end
    batch_num = batch_per_gpu*n_gpu;
    num = size(blob,4);
    feature = zeros(num,featlen,'single');
    max_iter = ceil(num / batch_num);
    test_batch = cell(n_gpu, 1);
    for i = 1 : max_iter
        drawnow;
        batch_id = mod((i-1)*batch_num:i*batch_num-1, num)+1;
        for j = 1:n_gpu
            gpu_batch_id = batch_id((j-1)*batch_per_gpu+1:j*batch_per_gpu);
            test_batch{j}{1} = single(blob(:,:,:,gpu_batch_id));
            test_batch{j}{1} = bsxfun(@minus,test_batch{j}{1},single(meanmat));
            test_batch{j}{2} = single(zeros(1,1,1,batch_per_gpu));
        end
        DNN.caffe_mex('test', test_batch);
        output = DNN.caffe_mex('get_response_solver', featlayer_name);
        if size(output{1}, 4) ~= batch_num
            for j = 2 : numel(output)
                output{1} = cat(4, output{1}, output{j});
            end
        end
        feature(batch_id,:) = reshape(output{1},[featlen,batch_num])';
    end
end


