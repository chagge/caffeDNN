if para.pre_load_data
    train_batch_imgs(:,:,:,1:num_per_batch) = data_train(:,:,:,train_batch_id);
else
    for i_t = 1 : num_per_batch
        img_t = imread(list_train{train_batch_id(i_t)});
        rect_t = round(rect_train(train_batch_id(i_t),:));
        l = max(rect_t(1), 1);
        r = min(rect_t(1)+rect_t(3), size(img_t, 2));
        t = max(rect_t(2), 1);
        b = min(rect_t(2)+rect_t(4), size(img_t, 2));
        img_t = img_t(t:b, l:r, :);
        if size(img_t, 3) < 3
            img_t = img_t(:,:,[1 1 1]);
        end
        img_t = imresize(permute(img_t(:,:,[3 2 1]), [2 1 3]), [para.input_size para.input_size]);
        train_batch_imgs(:,:,:,i_t) = img_t;
    end
end
train_batch_labels(1:num_per_batch) = label_train(train_batch_id)-1;
for i = 1:n_gpu
    dataid = ((i-1)*batch_per_gpu+1):i*batch_per_gpu;
    train_batch{i}{2} = single(zeros(1,1,1,para.num_per_gpu));
    train_batch{i}{1} = single(train_batch_imgs(:,:,:,dataid));
    train_batch{i}{1} = bsxfun(@minus,train_batch{i}{1},single(meanmat));
    train_batch{i}{2}(1,1,1,:) = single(train_batch_labels(dataid));
end