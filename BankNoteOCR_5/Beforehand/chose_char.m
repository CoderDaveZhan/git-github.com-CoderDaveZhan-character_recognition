function [ out] =chose_char(in_image)
%图像因光照不均，导致二值化后字符部分不完整，故将较亮的背景灰度用平均灰度代替，去除亮斑对二值化的影响。

% 计算平均灰度 average
[M,N] = size(in_image);
sum = 0;
for i =1:M
    for j = 1:N
        sum = sum + double(in_image(i,j));
    end
end
average = sum/M/N;

dim = 1; % 不用Otus阈值二值化，直接根据像素灰度判断是否为字符
%{
%平均灰度太小，说明图像太暗，背景和字符很接近,那么不能用普通的Otus全局二值化，直接取最暗的像素作字符
if average < 160  
    dim = 1;
end
%}
%判定灰度值超过最亮的像素点的灰度的0.9倍的像素区域是亮斑区
thresh = 0.9*max(in_image);
image = in_image;
for i =1:M
    for j = 1:N
        if in_image(i,j)>thresh
            image(i,j) = average; %去除光斑区域后的图像
        end
    end
end

% 计算去除光斑区域后的图像的平均灰度 average
sum = 0;
for i =1:M
    for j = 1:N
        sum = sum + double(image(i,j));
    end
end
average = sum/M/N;

%如果图像整体偏暗，那么不能直接使用Otus阈值全局二值化，直接取出最黑的点当作字符
tt = min(image);
if ~dim
    out = ~im2bw(image);
else
    tmp = zeros(M,N);
    for i =1:M
        for j = 1:N
            if image(i,j)< tt+0.55*average
                tmp(i,j) = 1;
            end
        end
    end
    out = logical(tmp);
end



end

