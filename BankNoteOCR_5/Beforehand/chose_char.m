function [ out] =chose_char(in_image)
%ͼ������ղ��������¶�ֵ�����ַ����ֲ��������ʽ������ı����Ҷ���ƽ���Ҷȴ��棬ȥ�����߶Զ�ֵ����Ӱ�졣

% ����ƽ���Ҷ� average
[M,N] = size(in_image);
sum = 0;
for i =1:M
    for j = 1:N
        sum = sum + double(in_image(i,j));
    end
end
average = sum/M/N;

dim = 1; % ����Otus��ֵ��ֵ����ֱ�Ӹ������ػҶ��ж��Ƿ�Ϊ�ַ�
%{
%ƽ���Ҷ�̫С��˵��ͼ��̫�����������ַ��ܽӽ�,��ô��������ͨ��Otusȫ�ֶ�ֵ����ֱ��ȡ����������ַ�
if average < 160  
    dim = 1;
end
%}
%�ж��Ҷ�ֵ�������������ص�ĻҶȵ�0.9��������������������
thresh = 0.9*max(in_image);
image = in_image;
for i =1:M
    for j = 1:N
        if in_image(i,j)>thresh
            image(i,j) = average; %ȥ�����������ͼ��
        end
    end
end

% ����ȥ�����������ͼ���ƽ���Ҷ� average
sum = 0;
for i =1:M
    for j = 1:N
        sum = sum + double(image(i,j));
    end
end
average = sum/M/N;

%���ͼ������ƫ������ô����ֱ��ʹ��Otus��ֵȫ�ֶ�ֵ����ֱ��ȡ����ڵĵ㵱���ַ�
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

