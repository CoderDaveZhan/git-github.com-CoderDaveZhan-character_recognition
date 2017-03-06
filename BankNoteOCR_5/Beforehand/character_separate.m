function [status] = character_separate( image )
% Separating single character from input image,then resize every character
% into 42*24,finally storing them into a cell matix
                        %%%%%% 1.投影法分割单个字符 %%%%%
%%%%%%%%%% (1).垂直投影，确定字符左右边界，从一列字符串中分离出单个字符   %%%%%%%%%%

% 连通域计数法去除噪点和污渍斑
%1.去除目标噪点
[L,num] = bwlabel(image,8);
for k = 1:num
    [y x] = find(L == k);
    nSize = length(y);
    if nSize < 80
        image(y,x) = 0;  %将目标噪点变成背景灰度
    end
end

%1.去除背景噪点
[L,num] = bwlabel(~image,8);
for k = 1:num
    [y x] = find(L == k);
    nSize = length(y);
    if nSize < 25        %要防止误伤A,8,4,B,P等有孔的字符，这里取得阈值较小，也就只能去除较小的背景噪点了(一般背景噪点也不大)。
        image(y,x) = 1;  %将背景噪点变成目标灰度
    end
end


ICx=sum(image,1);%垂直投影

%序列号单个字符的左右边界坐标C(K)，C(k+1),k=1~10
num=0;
j=0;
C=zeros(1,20);%存储10个字符的起止位置20位
%  列扫描：
%1.检测到非0值，num加1；
%2.检测到0值，先判断num是否>3,是则认为检测到了一个字符，记录左右边界坐标
%            如果num<=3,则认为遇到了噪点，num清0
for i=1:size(ICx,2)
    if ICx(i)
        num=num+1;
    else
        if num>4 % 4为实验确定值，可以刚好区分噪点同时保留很窄的字符如I,1
              j=j+1;
              C(j)=i-num;%左边界坐标
              j=j+1;
              C(j)=i-1;  %右边界坐标
              % 检查是否成功提取到每个字符的左右边界坐标
              if C(j)-C(j-1)>50
                  %error('myApp:argChk', 'Charater can not be separated');  
                  status = -1;
                  return;
              end
        end
        num=0;%一旦检测到非0值立即清0，可以防止不连续的噪点的干扰
    end
end


%%%%%%%%%% (2).水平投影，确定字符上下边界   %%%%%%%%%%
%序列号单个字符的左右边界坐标R(K)，R(k+1),k=1~10
ICy = []; %存储10个字符的水平投影
for k = 1:2:19
   shadow = sum(image(:,C(k):C(k+1)),2); %每个字符单独水平投影
   ICy = [ICy shadow];
end

m =0;
flag = 0;
R = zeros(1,20); %存储10个字符的上下边界共20位
for i = 2:2:20  %由于号码区切割不良，下边界可能提取不到，设默认值为图像最下边界
    R(i) = size(image,1);
end

for k = 1:10
   tmp = ICy(:,k);
   n =0;
   for j = 1:size(tmp,1)
       if tmp(j)
           n = n+1;
       else
           if n>20 %由于36个字符高度都不小，不像I的宽度那样，因此，这里将阈值取大些，可以排除更大的噪点干扰
              m = m+1;
              R(m) = j-n;%上边界坐标
              m = m+1;
              R(m) = j-1;  %下边界坐标
              flag = 1;  %表示提取上下边界成功
              break;
            end
            n = 0;%一旦检测到非0值立即清0，可以防止不连续的噪点的干扰
       end  
   end
   if ~flag %表示提取上下边界失败,利用默认的下边界值计算上边界
      m = m+1;
      R(m) = R(m+1)-n;
      m = m+1;
   end
   flag = 0;  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%6.将单个字符逐一归一化为与模板大小相同即 42*24 pixels，然后储存在包元矩阵中
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Storage matrix word from image
img=[ ];
for k=1:2:19
    % Judge character 'I',add background
    if (C(k+1)-C(k))<10
        C(k) = C(k)-5;
        C(k+1) = C(k+1)+5;
    end
    eachimg=image(R(k):R(k+1),C(k):C(k+1)); 
    % Resize letter (same size of template)
    eachimg = imresize(eachimg,[42 24]);
    %eachimg = ZhangThinning(eachimg);
    img=[img eachimg];
end
test_set = mat2cell(img,42,[24 24 24 24 24 24 24 24 24 24]);
save ('Mat\test_set','test_set');
status = 0; %分割成功
end

