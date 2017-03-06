function [ out ] = feature_recognize( bw,argue,mode )
% out 为36个字符中某1种时，表示该字符用特征法就能完成识别
% out = -1,表示该字符属于集合{2 5 7 J Z}
% out = -2,表示该字符属于集合{3 C G S U V W X Y}
% out = -3,表示该字符属于集合{0 A O}

% 给字符图像外围增加一圈黑色背景
[M,N] = size(bw);
img = zeros(M+2,N+2);
img(2:M+1,2:N+1) = bw; 

if strcmp(argue,'close_ring')
     out = close_ring( img );
elseif strcmp(argue,'open_derection')
     out = open_derection( img );
elseif strcmp(argue,'horizontal_line')
     out = horizontal_line( img );
elseif strcmp(argue,'vertical_line')
     out = vertical_line( img );
elseif strcmp(argue,'horizontal_cross')
     out = horizontal_cross( img,mode );
elseif strcmp(argue,'vertical_cross')
     out = vertical_cross( img,mode );
end

end




function [ out ] = close_ring( img )
% 求字符的闭环数out。假设闭环数为E，黑色背景连通区域个数n，则 E = n-1。

[~,n] = bwlabel(~img); %标记背景连通域
out = n-1;

end

function [ out ] = open_derection( img )
% 求字符的开口朝向。将图像分为左上、左下、右上、右下4个等大小区域，判别图像在这4个区域是否有“开口”，例如‘6’的右上角有开
% 口，‘9’的左下角有开口，‘3’的左上角和左下角有开口。判别左下角开口的方法是由图像的下1/2行起，逐行‘画横线’，统计该横线
% 与图像边缘的交点的位置，如果右1/2列的交点比左1/2列交点多，则判定图像左下角存在开口；如果交点数相等，则没有开口。
% out = 0、1、2、3、4、5、6、7、8 分别表示 没开口、左上、左下、右上、右下、左上左下、左上右下、右上左下、右上右下8个开口方向
[M,N] = size(img);
lu = 0;
ru = 0;
ld = 0;
rd = 0;
n1 = 0;
nlu = 0;
nru = 0;
nld = 0;
nrd = 0;
column_index = [];  %存放每行的线段中心点列坐标
column_midium = round(N/2); 
for i = 3:M-2
    for j = 1:N
        if img(i,j)
            n1 = n1+1;
        else
            if n1>1
                column_index = [column_index,round(j-n1/2-1)]; %存放该行每个线段的中心点列坐标
            end
            n1 = 0;
        end
    end
    if i<M/2 %上半部份
        if size(column_index)==1 % 该行只有1个线段,有2个线段、及3个线段的不计算个数
            if column_index(1)<column_midium-5 % 该线段中心点在左侧
                nlu = nlu+1;
            elseif column_index(1)>column_midium+5 % 该线段中心点在右侧
                nru = nru+1;
            end
        end
    else  % 下半部份
         if size(column_index)==1 % 该行只有1个线段,有2个线段、及3个线段的不计算个数
            if column_index(1)<column_midium-5 % 该线段中心点在左侧
                nld = nld+1;
            elseif column_index(1)>column_midium+5 % 该线段中心点在右侧
                nrd = nrd+1;
            end
         end
    end
    column_index = [];
end
if (nlu-nru)>2
    ru = 1;  %右上开口
elseif (nru-nlu)>2
    lu = 1;  %左上开口
end

if (nld-nrd)>2
    rd = 1;  %右下开口
elseif (nrd-nld)>2
    ld = 1;  %左下开口
end

if lu 
    if ld
        out = 5; %左上左下2个开口方向
    elseif rd
        out = 6; %左上右下2个开口方向
    else
        out = 1; %左上1个开口方向
    end
elseif ru
    if ld
        out = 7; %右上左下2个开口方向
    elseif rd
        out = 8; %右上右下2个开口方向
    else
        out = 3; %右上1个开口方向
    end
elseif ld
    out = 2;  %左下1个开口方向
elseif rd
    out = 4;  %右下1个开口方向
else
    out = 0;  %没有开口方向
end

end

function [ out ] = horizontal_line( img )
% 检查字符图像是否存在横线(一行中像素个数占字符有效宽度的0.8以上可视为横线，8列以内相邻横线视作同一条横线)
[M,N] = size(img);
ICy = sum(img,2); %水平投影
num = 0;
up = 0;
midium =0 ;
down = 0;
for i = 1:M
    if ICy(i)>0.8*N
        num = num+1;
    else
        if num>1 && num <15
            if i<M/3
                up = 1;         %上横线
            elseif i>M/3-1 && i<2/3*M+1
                midium = 1;     %中横线
            else
                down = 1;       %下横线
            end
        end
        num = 0;
    end
end
if up
    if midium
        if down
            out = 6; % E
        else
            out = 4; % F
        end
    elseif down
        out = 5;     % Z
    else
        out = 1;     % 5 7 T J
    end
elseif midium
    out = 2;         % 4 H 
elseif down
    out = 3;         % 2 L 
else
    out = 0;         %没横线
end
        
        
end

function [ out ] = vertical_line( img )
% 检查字符图像是否存在横线(一行中像素个数占字符有效宽度的0.85以上可视为竖线，2~9列相邻横线视作同一条竖线)
[M,N] = size(img);
ICx = sum(img,1); %竖直投影
num = 0;
left = 0;
midium =0 ;
right = 0;
for i = 1:N
    if ICx(i)>0.85*M
        num = num+1;
    else
        if num>1 && num <15
            if i<N/3
                left = 1;         %左竖线
            elseif i>N/3-1 && i<2/3*N+1
                midium = 1;     %中竖线
            else
                right = 1;       %右竖线
            end
        end
        num = 0;
    end
end
if left
    if right
        out = 4;     % H M N 
    else
        out = 1;     % B D E F K L P R 
    end
elseif midium
    out = 2;         % I T 
elseif right
    out = 3;         % 1 4 
else
    out = 0;         %没竖线
end
        
        
end

function [ out ] = horizontal_cross( img,mode)
% 水平方向分上中下3部分，每个部分取最大的行交点数作为这部分的水平过线数
% mode = 1 2 3 分别表示计算上、中、下3部分的过线数，out为过线数
% mode = 4 专门用于区分D、R ,取中间部分的最小行交点数作为out的结果输出
[M,N] = size(img);

if mode == 1  %计算上过线数
    t1 = 3;   %防止上边界毛刺导致过线数计算错误
    t2 = round(M/3);
elseif mode == 2 || mode==4  %计算水平中过线数
    t1 = round(M/3);
    t2 = round(2*M/3);
elseif mode==3    %计算水平下过线数
    t1 = round(2*M/3);
    t2 = M-2;  %防止下边界毛刺导致过线数计算错误
else
    disp('error input');
    return;
end

n1 = 0;
n2 = 0;
num = [];
for i = t1:t2
    for j = 1:N
        if img(i,j)
            n1 = n1+1;
        else
            if n1>1
                n2 = n2+1;
            end
            n1 = 0;
        end
    end
    num = [num n2];
    n2 = 0;
end
if mode==4
    out = min(num);
else
    out = max(num);
end
  
                    
end

function [ out ] = vertical_cross( img,mode )
% 竖直方向分左中右3部分，每个部分取最大的列交点数作为这部分的竖直过线数
% mode = 1 2 3 分别表示计算左、中、右3部分的过线数，out为过线数
[M,N] = size(img);

if mode == 1  %计算左过线数
    t1 = 3;
    t2 = round(N/3);
elseif mode == 2  %计算水平中过线数
    t1 = round(N/3);
    t2 = round(2*N/3);
elseif mode ==3
    t1 = round(2*N/3);
    t2 = N-2;
else
    disp('error input');
    return;
end

n1 = 0;
n2 = 0;
num = [];
for j = t1:t2
    for i = 1:M
        if img(i,j)
            n1 = n1+1;
        else
            if n1>1
                n2 = n2+1; %每一列的交点数
            end
            n1 = 0;
        end
    end
    num = [num n2];
    n2 = 0;
end
out = max(num);
  
end



