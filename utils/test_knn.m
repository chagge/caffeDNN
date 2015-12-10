function acc = test_knn( feature, label, k, refid, testid )
    if nargin < 3
        k = 1;
    end
    featnorm = bsxfun(@rdivide, feature, arrayfun(@(x) norm(feature(x,:)), 1:size(feature,1))');
    cosdist = featnorm*featnorm'-2*eye(size(feature,1));
    if nargin > 3
        cosdist(refid,:)=[];
        cosdist(:,testid) = [];
        label_ref = label(refid);
        label_test = label(testid);
        [~, iter] = sort(cosdist','descend');
        iter = iter';
        predicted = arrayfun(@(x)mode(label_ref(iter(x,1:k))), 1:size(cosdist,1))';
        hit = sum(predicted == label_test);
        acc = hit / (size(cosdist,1));
    else
        [~, iter] = sort(cosdist,'descend');
        iter = iter';
        predicted = arrayfun(@(x)mode(label(iter(x,1:k))), 1:size(feature,1))';
        hit = sum(predicted == label);
        acc = hit / (size(feature,1));
    end
end

