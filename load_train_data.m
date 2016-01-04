if ~exist('label_train','var')
    if para.pre_load_data
        load(para.data_train);
    else
        load(para.data_train);
        if exist('dir_train', 'var')
            list_train = cellfun(@(x)sprintf('%s%s', dir_train, x), list_train);
        end
    end
end