function  visualize( blob )
    bsize = size(blob);
    if numel(bsize) ~= 4
        fprintf('Kernel size must be 4-D\n');
        return;
    end
    r = -1;
    num = bsize(4);
    for i = floor(sqrt(num)) : -1 :  1
        if mod(num, i) < 1
            r = i;
            break;
        end
    end
    if r < 1
        fprintf('Kernel number must larger than 0 \n');
        return;
    end
    c = num / r; 
    bmin = min(min(min(min(blob))));
    bmax = max(max(max(max(blob))));
    blob = (blob - bmin) / (bmax - bmin);
    fprintf('min: %f max: %f\n', bmin, bmax);
    for i = 1 : bsize(4)
        subplot(c,r,i)
        imshow(blob(:,:,1,i));
    end
end

