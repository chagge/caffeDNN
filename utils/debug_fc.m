weight = DNN.caffe_mex('get_weights_solver');
conv1 = weight(1).weights{1};
 fc128 = weight(11).weights{1};
 fc2 = weight(12).weights{1};
%  fc3 = weight(16).weights{1};
 fprintf('conv1=[%f %f], fc1=[%f %f], fc2=[%f %f]\n', mean(conv1(:)), max(abs(conv1(:))), mean(mean(fc128)), max(max(abs(fc128))),mean(mean(fc2)), max(max(abs(fc2))));
% max_fc1(iter) = max(max(abs(fc1)));
% max_fc2(iter) = max(max(abs(fc2)));
% max_fc3(iter) = max(max(abs(fc3)));
% figure(5)
% plot(max_fc1, 'r')
% hold on;
% plot(max_fc2, 'g')
% hold on;
% plot(max_fc3, 'b')
% hold off;