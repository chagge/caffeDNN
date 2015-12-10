acc = ret(1).results;
loss=ret(2).results;
tr_acc(iter-baseiter) = acc;
tr_loss(iter-baseiter) = loss;
figure(1)
plot(tr_acc, 'g');
hold on
plot(tr_loss, 'r');
hold off;