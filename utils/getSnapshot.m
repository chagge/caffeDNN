function lastest = getSnapshot( dir, flag )
% flag: 1=>.solverstate 2=>.caffemodel
    list = ls(dir);
    maxiter = -1;
    maxnum = -1;
    for i = 1 : size(list, 1)
        t = findNumeric(list(i,:), 1);
        if ~isempty(t) && t > maxnum
            maxnum = t;
            maxiter = i;
        end
    end
    if maxiter == -1
        lastest = '';
    else
        lastest = strtrim([dir list(maxiter,:)]);
    end
    if flag == 1
        t = strfind(lastest, '.solverstate');
        if isempty(t)
            lastest = [lastest '.solverstate'];
        end
    else
        t = strfind(lastest, '.solverstate');
        if ~isempty(t)
            lastest = lastest(1:t-1);
        end
    end
end

