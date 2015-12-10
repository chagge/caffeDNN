    model_name = 'Gnet_bn_wdref_sdk_iter145000';
    clear mex;
    DNN.caffe_mex('set_device_solver', 0:(n_gpu-1));
    DNN.caffe_mex('init_solver', 'solver_100k200k_fc128.prototxt', ['snapshot/' model_name], 'log\');
    addpath('C:\Users\v-uiy\Documents\MATLAB\JointBayesianCode');
    tic
    fprintf('Generating feature...');
    feature_wdref = get_feature(data_wdref, meanmat, batch_per_gpu, n_gpu, 128, 'fc128', 1 );
    feature = get_feature( data_lfw, meanmat, batch_per_gpu, n_gpu, 128, 'fc128', 1 );
    fprintf('Done!\n');
    toc
    tic
    fprintf('Training JB...');
    model = TrainJointBayesianModel(feature_wdref, label_wdref,5);
    model = TransformJointBayesianModel(model);
    fprintf('Done!\n');
    toc
    tic
    fprintf('Testing...');
    jb_weight = ComputeJointBayesianWeight(feature, model);
    for i = 1 : 3000
    score.intra(i) = CalcJointBayesianSim(jb_weight(pairlist_lfw.IntraPersonPair(i,1),:), jb_weight(pairlist_lfw.IntraPersonPair(i,2), :));
    score.extra(i) = CalcJointBayesianSim(jb_weight(pairlist_lfw.ExtraPersonPair(i,1),:), jb_weight(pairlist_lfw.ExtraPersonPair(i,2), :));
    end
    fprintf('Done!\n');
    toc
    tscore = score.intra;
    fscore = score.extra;
    l = min(fscore);
    r = max(fscore);
    step = (r-l)/1000;
    iter = 1;
    for thre =  l+step : step:r-step
        tl=numel(find(tscore > thre));
        fl=numel(find(fscore > thre));
        tpr(iter) = tl/numel(tscore);
        fpr(iter) = fl/numel(fscore);
        iter = iter + 1;
    end
    plot(fpr,tpr,'b')
    ROC = abs(trapz(fpr, tpr));


