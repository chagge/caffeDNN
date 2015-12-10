cd ..
run('init.m')

para.pre_load_data = 0;
%test phase
para.test_lfw = 1;
para.test_xfext = 1;
%compute phase
para.gpuid = 2:4;
para.num_per_gpu = 85;
para.input_size = 96;
para.feature_length = 128;
para.feature_layer_name = 'fc128';
para.model_name = 'HalfGNetbn_for_face_fc128';
para.path_net = fullfile(root, 'net_def', para.model_name);
para.file_solver = fullfile(root, 'net_def', para.model_name, 'solver.prototxt');
para.seed_caffe = 6;
para.seed_matlab = 6;
para.data_shuffle_interval = 'epoch';
para.data_train = 'annotation_ustcAndxfext_train.mat';
para.model_init = '';
para.model_recovery = 'D:\YuLiu\caffeDNN\net_out\HalfGNetbn_for_face_fc128\iter1000.solverstate';
para.data_channels = 3;
para.gray_augment_ratio = 0.5;
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
para.path_output = fullfile(root, 'net_out', para.model_name);
para.path_best = fullfile(root, 'net_out', para.model_name, 'best_model');
para.data_num = numel(label_train);

script_train_verification;

