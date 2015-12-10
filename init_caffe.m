gpu_id = para.gpuid;
n_gpu = numel(gpu_id);
batch_per_gpu = para.num_per_gpu;
DNN.caffe_mex('set_device_solver', gpu_id);
snapshot = getSnapshot(para.path_output, 1);
path_cur = pwd;
cd(para.path_net)
if ~isempty(para.model_recovery)
    DNN.caffe_mex('recovery_solver', para.file_solver, para.model_recovery, fullfile(para.path_output, 'log/'));
elseif ~isempty(para.model_init)
    DNN.caffe_mex('init_solver', para.file_solver, para.model_init, fullfile(para.path_output, 'log/'));
else
    DNN.caffe_mex('init_solver', para.file_solver, '', fullfile(para.path_output, 'log/'));
end
cd(path_cur)
iter_ = DNN.caffe_mex('get_solver_iter');
iter_ = max(iter_,1);
iter = iter_;
max_iter=DNN.caffe_mex('get_solver_max_iter');