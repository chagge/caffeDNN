function train_batch = load_batch_data_from_annotation(list_train, rect_train, label_train, meanmat, para)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

    train_batch_imgs(:,:,:,1:num_per_batch) = data_train;
    train_batch_labels(1:num_per_batch) = label_train-1;

    if isfield(para, 'gray_augment_ratio') && para.gray_augment_ratio > 0
        id_t = find(rand(para.num_per_batch, 1) > para.gray_augment_ratio ~= 0);
        for i_t = 1 : numel(id_t)
            train_batch_imgs(:,:,:,id_t(i_t)) = repmat(rgb2gray(train_batch_imgs(:,:,:,id_t(i_t))), [1 1 3]);
        end
    end
    for i = 1:numel(para.gpuid)
        dataid = ((i-1)*para.num_per_gpu+1):i*para.num_per_gpu;
        train_batch{i}{2} = single(zeros(1,1,1,para.num_per_gpu));
        train_batch{i}{1} = single(train_batch_imgs(:,:,:,dataid));
        train_batch{i}{1} = bsxfun(@minus,train_batch{i}{1},single(meanmat));
        train_batch{i}{2}(1,1,1,:) = single(train_batch_labels(dataid));
    end
end