tic
mean_t = zeros(224,224,3,20000,'uint8');
parfor i_t = 1:20000
                        img_t = imread(list{testid(i_t)});
                        rect_t = round(rect(i_t,:));
                        l = max(rect_t(1), 1);
                        r = min(rect_t(1)+rect_t(3), size(img_t, 2));
                        t = max(rect_t(2), 1);
                        b = min(rect_t(2)+rect_t(4), size(img_t, 2));
                        img_t = img_t(t:b, l:r, :);
                        if size(img_t, 3) < 3
                            img_t = img_t(:,:,[1 1 1]);
                        end
                        img_t = permute(img_t(:,:,[3 2 1]), [2 1 3]);
                        mean_t(:,:,:,i_t) = imresize(permute(img_t(:,:,[3 2 1]), [2 1 3]), [224 224]);
end
                    toc