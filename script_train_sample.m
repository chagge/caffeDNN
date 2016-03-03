cd ..
run('init.m')

para.pre_load_data = 0;
%test phase
para.test_lfw = 1;
para.test_xfext = 1;
%compute phase
para.gpuid = 0:7;
para.num_per_gpu = 64;
para.augment = 4;
para.num_per_batch = numel(para.gpuid) * para.num_per_gpu;
para.input_size = 96;
para.feature_length = 128;
para.feature_layer_name = 'fc128';
para.model_name = 'GoogleNetbn_for_face_fc128_40145';
para.path_net = fullfile(root, 'net_def', para.model_name);
para.file_solver = fullfile(root, 'net_def', para.model_name, 'solver.prototxt');
para.seed_caffe = randi(65535);
para.seed_matlab = randi(65535);
para.data_shuffle_interval = 'epoch';
para.data_train = 'annotation_big_train.mat';
para.model_init = '';
para.model_recovery = 'iter64000.solverstate';
para.data_channels = 3;
para.gray_augment_ratio = 0.05;
para.fast_meanmat = 0;
para.meanmat_dir = 'D:\YuLiu\caffeDNN\data\meanmat96.mat';
%debug phase
para.debug = 0;

%load data
load_train_data;
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

