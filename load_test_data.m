if para.test_lfw
    if ~exist('data_lfw', 'var')
        load('lfw_1.0jda_dataandlabel.mat');
        if size(data_lfw, 1) ~= para.input_size
            resize_t = zeros(para.input_size,para.input_size,3,size(data_lfw, 4),'uint8');
            parfor i_t = 1 : size(data_lfw, 4)
                resize_t(:,:,:,i_t) = imresize(data_lfw(:,:,:,i_t), [para.input_size para.input_size]);
            end
            data_lfw = resize_t;
            clear resize_t;
        end
    end
    if ~exist('pairlist_lfw', 'var')
        load('pairlist_lfw.mat');
    end
end
if para.test_xfext
    if ~exist('data_xfexttest', 'var')
        load('test_xfext_1.0jda_all.mat')
        if size(data_xfexttest, 1) ~= para.input_size
            resize_t = zeros(para.input_size,para.input_size,3,size(data_xfexttest, 4),'uint8');
            parfor i_t = 1 : size(data_xfexttest, 4)
                resize_t(:,:,:,i_t) = imresize(data_xfexttest(:,:,:,i_t), [para.input_size para.input_size]);
            end
            data_xfexttest = resize_t;
            clear resize_t;
        end
    end
end