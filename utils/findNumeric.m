function rst = findNumeric( str, flag )
%flag: 0 or null=>find all numerics; 1=>find the max numeric; -1=>find the
%min numeric
    if nargin < 2
        flag = 1;
    end
    assert(ischar(str), 'findNumeric only deal with string.');
    ms = regexp( str, '(?<=\w+)\d+', 'match' );
    ms = cellfun(@(x)str2num(x), ms);
    if flag == 0
        rst = ms;
    elseif flag > 0
        rst = max(ms);
    elseif flag < 0
        rst = min(ms)
    end
end

