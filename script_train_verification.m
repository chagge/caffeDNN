if isempty(gcp('nocreate'))
    parpool(1);
end
while ~exist('iter', 'var') || iter < max_iter

    if ~exist('iter', 'var')
        reset_all;
    end
    if exist('loss', 'var') && loss > 20
        reset_all;
    end
%     if ~DNN.caffe_mex('is_initialized')
%         reset_all;
%     end
    tic
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
    
    %%start train
    train_batch_id = trainid(mod(nowid:nowid+para.num_per_batch-1, para.data_num)+1);
    pf_data = parfeval(@load_batch_data, 1, list_train(train_batch_id), rect_train(train_batch_id,:), label_train(train_batch_id), meanmat, para);
    for iter = iter_:max_iter
        shuffle_data;
        drawnow;
        %this data preparing part use 0.15s for 8*32=256 images
%         train_batch_select_class = mod(randperm(max(label_train)*100, num_per_batch), max(label_train))+1;
%         train_batch_id = arrayfun(@(x)idx{train_batch_select_class(x)}(randperm(numel(idx{train_batch_select_class(x)}), 1)), 1:num_per_batch);
        train_batch_id = trainid(mod(nowid:nowid+para.num_per_batch-1, para.data_num)+1);
        nowid = nowid + para.num_per_batch;
        if isempty(gcp('nocreate'))
            parpool(1);
        else
            train_batch = fetchOutputs(pf_data);
        end
        pf_data = parfeval(@load_batch_data, 1, list_train(train_batch_id), rect_train(train_batch_id,:), label_train(train_batch_id), meanmat, para);
%         train_batch = load_batch_data(list_train(train_batch_id), rect_train(train_batch_id,:), label_train(train_batch_id), meanmat, para);
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
            waitforbuttonpress;
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
            val_lfw(testiter) = VAL;
            
            test_xfext_cos;%83.6 secs on 3 * GTX Titan X;
            val_lab(testiter) = VAL;
            if ~exist('roc_lab', 'var') || ROC >= min(roc_lab)
                if ~exist(para.path_best, 'file')
                    mkdir(para.path_best);
                end
                DNN.caffe_mex('snapshot', fullfile(para.path_best,'model'));
            end
            roc_lab(testiter) = ROC;
            testiter = testiter + 1;
            figure(2)
            plot(roc_lfw,'r');
            hold on
            plot(roc_lab,'g');
            plot(val_lfw,'b');
            plot(val_lab,'y');
            
            legend('ROC_{LFW}','ROC_{XF}','VAL_{LFW}','VAL_{XF}', 'Location', 'SouthEast');
            hold off
        end
        
        if para.debug
            check_response;
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

