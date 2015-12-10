if strcmp(para.data_shuffle_interval, 'epoch')
    if thisbatchid*num_per_batch > para.data_num + mod(para.data_num, num_per_batch)
        trainid = randperm(para.data_num);
        thisbatchid = 1;
        fprintf('Changing trainid at iter=%d, number %d\n', iter, changeid);
        changeid = changeid + 1;
    end               
elseif strcmp(para.data_shuffle_interval, 'randepoch')
    if rand()<(1/train_data_num)
        trainid = randperm(para.data_num);
        thisbatchid = 1;
        fprintf('Changing trainid at iter=%d, number %d\n', iter, changeid);
        changeid = changeid + 1;
    end
end