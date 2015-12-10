if ~exist('meanmat', 'var')
    if exist(fullfile(para.path_output, 'meanmat.mat'), 'file')
        load(fullfile(para.path_output, 'meanmat.mat'));
    else
        if para.fast_meanmat
            meanmat = 127*ones(para.input_size, para.input_size, para.data_channels);
        else
            if para.pre_load_data
                meanmat = mean(data_train,4);
            else
                meanmat_t = zeros(para.input_size, para.input_size, para.data_channels, mod(para.data_num, 1000));
                for i_tt = 1 : mod(para.data_num, 1000)
                    mean_t = zeros(para.input_size, para.input_size, para.data_channels, 1000);
                    for i_t = 1 : 1000
                        img_t = imread(list_train{i_t});
                        rect_t = round(rect_train(i_t,:));
                        l = max(rect_t(1), 1);
                        r = min(rect_t(1)+rect_t(3), size(img_t, 2));
                        t = max(rect_t(2), 1);
                        b = min(rect_t(2)+rect_t(4), size(img_t, 2));
                        img_t = img_t(t:b, l:r, :);
                        if para.data_channels == 3
                            if size(img_t, 3) < 3
                                img_t = img_t(:,:,[1 1 1]);
                            end
                        else
                            if size(img_t, 3) > 1
                                img_t = rgb2gray(img_t);
                            end
                        end
                        mean_t(:,:,:,i_t) = imresize(img_t, [para.input_size para.input_size]);
                    end
                    meanmat_t(:,:,:,i_tt) = mean(mean_t,4);
                end
                meanmat = mean(meanmat_t, 4);
                meanmat = permute(meanmat(:,:,para.data_channels:-1:1), [2 1 3]);
            end
            save(fullfile(para.path_output, 'meanmat.mat'),'meanmat');
        end
    end
end