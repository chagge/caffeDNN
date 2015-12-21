function train_batch = load_batch_data(list_train, rect_train, label_train, meanmat, para)
	if isfield(para, 'augment') && para.augment ~= 0
		rect = rect + randi(para.augment*2, size(rect)) - para.augment;
	end
    if para.pre_load_data
        train_batch = load_batch_data_from_mat(list_train, rect_train, label_train, meanmat, para);
    else
        train_batch = load_batch_data_from_annotation(list_train, rect_train, label_train, meanmat, para);
    end
end