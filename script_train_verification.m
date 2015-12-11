
while ~exist('iter', 'var') || iter < max_iter

    if ~exist('iter', 'var')
        reset_all;
    end
    if exist('loss', 'var') && loss > 20
        reset_all
    end
    tic
    train_batch_imgs = zeros(para.input_size,para.input_size,para.data_channels,batch_per_gpu*n_gpu);
    train_batch_labels = zeros(batch_per_gpu*n_gpu, 1);
    num_per_batch = batch_per_gpu*n_gpu;
    if exist('tr_acc', 'var')
        tr_acc(iter-baseiter:end)=[];
    end
    if exist('tr_loss', 'var')
        tr_loss(iter-baseiter:end)=[];
    end
    if exist('roc_lfw', 'var')
        roc_lfw(testiter:end)=[];
    end
    check_weight;
    if ~exist('nowid', 'var')
        nowid = 0;
    end
    if ~exist('changeid', 'var')
        changeid = 0;
        thisbatchid = 1;
    end
    for iter = iter_:max_iter
        shuffle_data;
        drawnow;
        %this data preparing part use 0.15s for 8*32=256 images
%         train_batch_select_class = mod(randperm(max(label_train)*100, num_per_batch), max(label_train))+1;
%         train_batch_id = arrayfun(@(x)idx{train_batch_select_class(x)}(randperm(numel(idx{train_batch_select_class(x)}), 1)), 1:num_per_batch);
        train_batch_id = trainid(mod(nowid:nowid+num_per_batch-1, para.data_num)+1);
        nowid = nowid + num_per_batch;
        load_batch_data;
        %this training part spend 1.014s for 8*32=256 images
        thisbatchid = thisbatchid + 1;
        ret = DNN.caffe_mex('train', train_batch);
    %     debug_fc
    %     debug_fc;
    %     weight = DNN.caffe_mex('get_weights_solver');
        parse_result;
        if loss > 50
            fprintf('Loss large than threshold in iter %d, break.\n', iter);
            fprintf('Max label is %d\n', max(train_batch_labels));
            break;
        end
        if mod(iter-baseiter,10)<1
            fprintf('.')
        end

        %show train loss
        if mod(iter-baseiter,100)<1 
            fprintf('\n');
%             debug_fc;
            toc
            fprintf('iter %d: loss=%f acc=%f cid=%d did=%d\n', iter,...
                mean(tr_loss(iter-baseiter-100+1:iter-baseiter)),...
                mean(tr_acc(iter-baseiter-100+1:iter-baseiter)),...
                changeid, thisbatchid);
            tic
        end


        %save result
        if mod(iter,1000)<1
            DNN.caffe_mex('snapshot', fullfile(para.path_output,['iter' num2str(iter)]));
            fprintf('Start testing...');
            test_lfw_cos;%80 secs on 2 * GTX 980Ti  52.5 secs on 3 * GTX Titan X
            roc_lfw(testiter) = ROC;
            test_xfext_cos;%83.6 secs on 3 * GTX Titan X
            if ~exist('roc_lab', 'var') || ROC <= min(roc_lab)
                DNN.caffe_mex('snapshot', fullfile(para.path_best,['iter' num2str(iter)]));
            end
            roc_lab(testiter) = ROC;
            testiter = testiter + 1;
            figure(2)
            plot(roc_lfw,'r');
            hold on
            plot(roc_lab,'g');
            hold off
        end

    %     figure(1)
    %     plot(tr_acc, 'g');
    %     hold on
    %     plot(tr_loss, 'r');
    %     hold off;
        iter_ = iter + 1;
    end

    % DNN.caffe_mex('snapshot', 'model_final');
    % save train_test_err.mat all_train_loss all_test_err -v7.3;
end

