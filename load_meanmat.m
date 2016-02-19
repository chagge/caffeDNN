fprintf('Loading meanmat...')
if ~exist('meanmat', 'var')
    if isfield(para, 'meanmat_dir') && exist(para.meanmat_dir, 'file')
        load(para.meanmat_dir)
        fprintf('Use %s\n', para.meanmat_dir);
    else
        if para.fast_meanmat
            meanmat = 127*ones(para.input_size, para.input_size, para.data_channels);
            fprintf('Use fast meanmat 127\n')
        else
            fprintf('\nRebuild meanmat...\n')
            if para.pre_load_data
                meanmat = mean(data_train,4);
            else
                tic
                meanmat_t = zeros(para.input_size, para.input_size, para.data_channels, floor(para.data_num/1000));
                for i_tt = 1 : floor(para.data_num/ 1000)
%                     if mod(i_tt, floor(para.data_num/ 100000)) < 1
                        fprintf('Meanmat proceeding...(%d/%d)\n', i_tt, floor(para.data_num/ 1000));
%                     end
                    mean_t = zeros(para.input_size, para.input_size, para.data_channels, 1000);
                    for i_t = 1 : 1000
                        img_t = imread(list_train{i_t+1000*(i_tt-1)});
                        rect_t = round(rect_train(i_t+1000*(i_tt-1),:));
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
                toc
            end
            save(fullfile(para.path_output, 'meanmat.mat'),'meanmat');
        end
    end
else
    fprintf('Exist meanmat.\n');
end
sizemat = size(meanmat);
sizemat(end)=1;
meanmat = repmat(mean(mean(meanmat)), sizemat);