function [ out ] = feature_recognize( bw,argue,mode )
% out Ϊ36���ַ���ĳ1��ʱ����ʾ���ַ����������������ʶ��
% out = -1,��ʾ���ַ����ڼ���{2 5 7 J Z}
% out = -2,��ʾ���ַ����ڼ���{3 C G S U V W X Y}
% out = -3,��ʾ���ַ����ڼ���{0 A O}

% ���ַ�ͼ����Χ����һȦ��ɫ����
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
% ���ַ��ıջ���out������ջ���ΪE����ɫ������ͨ�������n���� E = n-1��

[~,n] = bwlabel(~img); %��Ǳ�����ͨ��
out = n-1;

end

function [ out ] = open_derection( img )
% ���ַ��Ŀ��ڳ��򡣽�ͼ���Ϊ���ϡ����¡����ϡ�����4���ȴ�С�����б�ͼ������4�������Ƿ��С����ڡ������确6�������Ͻ��п�
% �ڣ���9�������½��п��ڣ���3�������ϽǺ����½��п��ڡ��б����½ǿ��ڵķ�������ͼ�����1/2�������С������ߡ���ͳ�Ƹú���
% ��ͼ���Ե�Ľ����λ�ã������1/2�еĽ������1/2�н���࣬���ж�ͼ�����½Ǵ��ڿ��ڣ������������ȣ���û�п��ڡ�
% out = 0��1��2��3��4��5��6��7��8 �ֱ��ʾ û���ڡ����ϡ����¡����ϡ����¡��������¡��������¡��������¡���������8�����ڷ���
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
column_index = [];  %���ÿ�е��߶����ĵ�������
column_midium = round(N/2); 
for i = 3:M-2
    for j = 1:N
        if img(i,j)
            n1 = n1+1;
        else
            if n1>1
                column_index = [column_index,round(j-n1/2-1)]; %��Ÿ���ÿ���߶ε����ĵ�������
            end
            n1 = 0;
        end
    end
    if i<M/2 %�ϰ벿��
        if size(column_index)==1 % ����ֻ��1���߶�,��2���߶Ρ���3���߶εĲ��������
            if column_index(1)<column_midium-5 % ���߶����ĵ������
                nlu = nlu+1;
            elseif column_index(1)>column_midium+5 % ���߶����ĵ����Ҳ�
                nru = nru+1;
            end
        end
    else  % �°벿��
         if size(column_index)==1 % ����ֻ��1���߶�,��2���߶Ρ���3���߶εĲ��������
            if column_index(1)<column_midium-5 % ���߶����ĵ������
                nld = nld+1;
            elseif column_index(1)>column_midium+5 % ���߶����ĵ����Ҳ�
                nrd = nrd+1;
            end
         end
    end
    column_index = [];
end
if (nlu-nru)>2
    ru = 1;  %���Ͽ���
elseif (nru-nlu)>2
    lu = 1;  %���Ͽ���
end

if (nld-nrd)>2
    rd = 1;  %���¿���
elseif (nrd-nld)>2
    ld = 1;  %���¿���
end

if lu 
    if ld
        out = 5; %��������2�����ڷ���
    elseif rd
        out = 6; %��������2�����ڷ���
    else
        out = 1; %����1�����ڷ���
    end
elseif ru
    if ld
        out = 7; %��������2�����ڷ���
    elseif rd
        out = 8; %��������2�����ڷ���
    else
        out = 3; %����1�����ڷ���
    end
elseif ld
    out = 2;  %����1�����ڷ���
elseif rd
    out = 4;  %����1�����ڷ���
else
    out = 0;  %û�п��ڷ���
end

end

function [ out ] = horizontal_line( img )
% ����ַ�ͼ���Ƿ���ں���(һ�������ظ���ռ�ַ���Ч��ȵ�0.8���Ͽ���Ϊ���ߣ�8���������ں�������ͬһ������)
[M,N] = size(img);
ICy = sum(img,2); %ˮƽͶӰ
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
                up = 1;         %�Ϻ���
            elseif i>M/3-1 && i<2/3*M+1
                midium = 1;     %�к���
            else
                down = 1;       %�º���
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
    out = 0;         %û����
end
        
        
end

function [ out ] = vertical_line( img )
% ����ַ�ͼ���Ƿ���ں���(һ�������ظ���ռ�ַ���Ч��ȵ�0.85���Ͽ���Ϊ���ߣ�2~9�����ں�������ͬһ������)
[M,N] = size(img);
ICx = sum(img,1); %��ֱͶӰ
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
                left = 1;         %������
            elseif i>N/3-1 && i<2/3*N+1
                midium = 1;     %������
            else
                right = 1;       %������
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
    out = 0;         %û����
end
        
        
end

function [ out ] = horizontal_cross( img,mode)
% ˮƽ�����������3���֣�ÿ������ȡ�����н�������Ϊ�ⲿ�ֵ�ˮƽ������
% mode = 1 2 3 �ֱ��ʾ�����ϡ��С���3���ֵĹ�������outΪ������
% mode = 4 ר����������D��R ,ȡ�м䲿�ֵ���С�н�������Ϊout�Ľ�����
[M,N] = size(img);

if mode == 1  %�����Ϲ�����
    t1 = 3;   %��ֹ�ϱ߽�ë�̵��¹������������
    t2 = round(M/3);
elseif mode == 2 || mode==4  %����ˮƽ�й�����
    t1 = round(M/3);
    t2 = round(2*M/3);
elseif mode==3    %����ˮƽ�¹�����
    t1 = round(2*M/3);
    t2 = M-2;  %��ֹ�±߽�ë�̵��¹������������
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
% ��ֱ�����������3���֣�ÿ������ȡ�����н�������Ϊ�ⲿ�ֵ���ֱ������
% mode = 1 2 3 �ֱ��ʾ�������С���3���ֵĹ�������outΪ������
[M,N] = size(img);

if mode == 1  %�����������
    t1 = 3;
    t2 = round(N/3);
elseif mode == 2  %����ˮƽ�й�����
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
                n2 = n2+1; %ÿһ�еĽ�����
            end
            n1 = 0;
        end
    end
    num = [num n2];
    n2 = 0;
end
out = max(num);
  
end



