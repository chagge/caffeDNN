% This is JUST A SAMPLE of your training code
% Change the parameters below to customize your own training method.

cd ..
run('init.m')

para.pre_load_data = 0;
%%test phase
para.test_lfw = 1;
para.test_xfext = 1;
%%compute phase
para.gpuid = 2:4;
para.num_per_gpu = 80;
para.augment = 3;
para.input_size = 96;
para.num_per_batch = numel(para.gpuid)*para.num_per_gpu;
para.feature_length = 128;
para.feature_layer_name = 'fc128';
para.model_name = 'VGG16_for_face_377079_96';
para.path_net = fullfile(root, 'net_def', para.model_name);
para.file_solver = fullfile(root, 'net_def', para.model_name, 'solver.prototxt');
para.seed_caffe = randi(65535);
para.seed_matlab = randi(65535);
para.data_shuffle_interval = 'epoch';
para.data_train = 'annotation_(xfext_ustc_chceleb_celebext)_train.mat';
para.model_init = '';
para.model_recovery = '';
para.data_channels = 3;
para.gray_augment_ratio = 0.5;
para.debug=0;
para.fast_meanmat = 1;

if ~exist('label_train','var')
    if para.pre_load_data
        load(para.data_train);
    else
        load(para.data_train);
    end
end
if ~exist(fullfile(root, 'net_out', para.model_name), 'file')
    mkdir(fullfile(root, 'net_out', para.model_name))
end
if ~exist(fullfile(root, 'net_out', para.model_name, 'best_model'), 'file')
    mkdir(fullfile(root, 'net_out', para.model_name, 'best_model')) 
end
para.path_output = fullfile(root, 'net_out', [para.model_name '_' num2str(para.input_size)]);
para.path_best = fullfile(para.path_output, 'best_model');
para.data_num = numel(label_train);

script_train_verification;

