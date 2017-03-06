function [status] = character_separate( image )
% Separating single character from input image,then resize every character
% into 42*24,finally storing them into a cell matix
                        %%%%%% 1.ͶӰ���ָ���ַ� %%%%%
%%%%%%%%%% (1).��ֱͶӰ��ȷ���ַ����ұ߽磬��һ���ַ����з���������ַ�   %%%%%%%%%%

% ��ͨ�������ȥ���������հ�
%1.ȥ��Ŀ�����
[L,num] = bwlabel(image,8);
for k = 1:num
    [y x] = find(L == k);
    nSize = length(y);
    if nSize < 80
        image(y,x) = 0;  %��Ŀ������ɱ����Ҷ�
    end
end

%1.ȥ���������
[L,num] = bwlabel(~image,8);
for k = 1:num
    [y x] = find(L == k);
    nSize = length(y);
    if nSize < 25        %Ҫ��ֹ����A,8,4,B,P���п׵��ַ�������ȡ����ֵ��С��Ҳ��ֻ��ȥ����С�ı��������(һ�㱳�����Ҳ����)��
        image(y,x) = 1;  %�����������Ŀ��Ҷ�
    end
end


ICx=sum(image,1);%��ֱͶӰ

%���кŵ����ַ������ұ߽�����C(K)��C(k+1),k=1~10
num=0;
j=0;
C=zeros(1,20);%�洢10���ַ�����ֹλ��20λ
%  ��ɨ�裺
%1.��⵽��0ֵ��num��1��
%2.��⵽0ֵ�����ж�num�Ƿ�>3,������Ϊ��⵽��һ���ַ�����¼���ұ߽�����
%            ���num<=3,����Ϊ��������㣬num��0
for i=1:size(ICx,2)
    if ICx(i)
        num=num+1;
    else
        if num>4 % 4Ϊʵ��ȷ��ֵ�����Ըպ��������ͬʱ������խ���ַ���I,1
              j=j+1;
              C(j)=i-num;%��߽�����
              j=j+1;
              C(j)=i-1;  %�ұ߽�����
              % ����Ƿ�ɹ���ȡ��ÿ���ַ������ұ߽�����
              if C(j)-C(j-1)>50
                  %error('myApp:argChk', 'Charater can not be separated');  
                  status = -1;
                  return;
              end
        end
        num=0;%һ����⵽��0ֵ������0�����Է�ֹ�����������ĸ���
    end
end


%%%%%%%%%% (2).ˮƽͶӰ��ȷ���ַ����±߽�   %%%%%%%%%%
%���кŵ����ַ������ұ߽�����R(K)��R(k+1),k=1~10
ICy = []; %�洢10���ַ���ˮƽͶӰ
for k = 1:2:19
   shadow = sum(image(:,C(k):C(k+1)),2); %ÿ���ַ�����ˮƽͶӰ
   ICy = [ICy shadow];
end

m =0;
flag = 0;
R = zeros(1,20); %�洢10���ַ������±߽繲20λ
for i = 2:2:20  %���ں������и�����±߽������ȡ��������Ĭ��ֵΪͼ�����±߽�
    R(i) = size(image,1);
end

for k = 1:10
   tmp = ICy(:,k);
   n =0;
   for j = 1:size(tmp,1)
       if tmp(j)
           n = n+1;
       else
           if n>20 %����36���ַ��߶ȶ���С������I�Ŀ����������ˣ����ｫ��ֵȡ��Щ�������ų������������
              m = m+1;
              R(m) = j-n;%�ϱ߽�����
              m = m+1;
              R(m) = j-1;  %�±߽�����
              flag = 1;  %��ʾ��ȡ���±߽�ɹ�
              break;
            end
            n = 0;%һ����⵽��0ֵ������0�����Է�ֹ�����������ĸ���
       end  
   end
   if ~flag %��ʾ��ȡ���±߽�ʧ��,����Ĭ�ϵ��±߽�ֵ�����ϱ߽�
      m = m+1;
      R(m) = R(m+1)-n;
      m = m+1;
   end
   flag = 0;  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%6.�������ַ���һ��һ��Ϊ��ģ���С��ͬ�� 42*24 pixels��Ȼ�󴢴��ڰ�Ԫ������
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
status = 0; %�ָ�ɹ�
end

