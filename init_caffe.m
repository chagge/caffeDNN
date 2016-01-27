gpu_id = para.gpuid;
n_gpu = numel(gpu_id);
batch_per_gpu = para.num_per_gpu;
%DNN.caffe_mex('set_device_solver', gpu_id);==============
snapshot = getSnapshot(para.path_output, 1);
path_cur = pwd;
cd(para.path_output)
% Usage: caffe_('get_solver_multigpu', solver_file, [snapshot file], [gpus to use])
if ~isempty(para.model_recovery)
    %DNN.caffe_mex('recovery_solver', para.file_solver,
    %para.model_recovery, fullfile(para.path_output, 'log/'));========
    caffe_solver = caffe.Solver(para.file_solver,'multi',para.model_recovery,gpu_id);
elseif ~isempty(para.model_init)
    %DNN.caffe_mex('init_solver', para.file_solver, para.model_init,
    %fullfile(para.path_output, 'log/'));========
    caffe_solver = caffe.Solver(para.file_solver,'multi',para.model_init,gpu_id);
else
    %DNN.caffe_mex('init_solver', para.file_solver, '',
    %fullfile(para.path_output, 'log/'));========
    caffe_solver = caffe.Solver(para.file_solver,'multi',gpu_id);
end
cd(path_cur)
%iter_ = DNN.caffe_mex('get_solver_iter');============
iter_ = caffe_solver.iter;
iter_ = max(iter_,1);
iter = iter_;
%max_iter=DNN.caffe_mex('get_solver_max_iter');==========
max_iter = 1000000000;