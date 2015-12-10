% model_name_base = 'Gnet_bn_jda_iter';
% for j = 1 : 67
%     clear mex;
%     n_gpu = 2;
%     batch_per_gpu = 64;
%     DNN.caffe_mex('set_device_solver', 0:(n_gpu-1));
%     DNN.caffe_mex('init_solver', 'solver_100k200k_fc128_test.prototxt', ['snapshot/' [model_name_base num2str(j*1000)]], 'log\');
%     addpath('E:\research\code\MSRAcodes\JointBayesianCode');
    tic
    fprintf('Generating feature LFW...');
        feature = get_feature( data_lfw, meanmat, batch_per_gpu, n_gpu, para.feature_length, para.feature_layer_name, 1 );
    fprintf('Done!\n');
    toc
    tic
    fprintf('Geting cos distance...');
        featnorm = bsxfun(@rdivide, feature, arrayfun(@(x) norm(feature(x,:)), 1:size(feature,1))');
        cosdist = featnorm*featnorm'-2*eye(size(feature,1));
    fprintf('Done!\n');
    toc
    tic
    fprintf('Testing...');
        score.intra = arrayfun(@(x)cosdist(pairlist_lfw.IntraPersonPair(x,1), pairlist_lfw.IntraPersonPair(x,2)), 1:3000);
        score.extra = arrayfun(@(x)cosdist(pairlist_lfw.ExtraPersonPair(x,1), pairlist_lfw.ExtraPersonPair(x,2)), 1:3000);
    fprintf('Done!\n');
    toc
    tscore = score.intra;
    fscore = score.extra;
    l = min(fscore);
    r = max(fscore);
    step = (r-l)/1000;
    itert = 1;
    for thre =  l+step : step:r-step
        tl=numel(find(tscore > thre));
        fl=numel(find(fscore > thre));
        tpr(itert) = tl/numel(tscore);
        fpr(itert) = fl/numel(fscore);
        itert = itert + 1;
    end
    figure(3)
    plot(fpr,tpr,'b','DisplayName',num2str(i))
    hold on
    ROC = abs(trapz(fpr, tpr));
%     ROC(j) = abs(trapz(fpr, tpr));
%     figure(2)
%     plot(ROC);
% end


