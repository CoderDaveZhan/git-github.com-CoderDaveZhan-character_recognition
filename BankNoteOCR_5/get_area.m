function [ area ,Teta] = get_area( in_image )

image = rotate2horizontal(in_image);
image = cutbackground(image);
[image,Teta] = get_num_area(image); 
area = imresize(image,2); %插值，使得像素更密集，这样就不容易形成错位

function [out_image] = rotate2horizontal(in_image)
% Rotate image from slant to horizontal

row_range=size(in_image,1);
image=in_image(1:ceil(0.25*row_range),:); %counteract interference 
image=extract_edge(image,0.9);
% Using Hough Transformation(HT) to caculate the tilt angle of horizontal line 
[H,T,~]=hough(image,'Theta',-90:0.1:89.5); 
P=houghpeaks(H,1,'threshold',ceil(0.1*max(H(:))));
if T(P(:,2))>0
    fi=T(P(:,2))-90;
else
    fi=90+T(P(:,2)); 
end
out_image=imrotate(in_image,fi,'bilinear'); 
end

function [out_image] = cutbackground(in_image)
%切去纸币上下部分背景    
image = in_image;
for i = 1:size(image,1)
    for j = 1:size(image,2)
        if image(i,j)<100   %背景中的较高灰度影响上下边界测量
            image(i,j) = 0;
        end
    end
end
            
num1=0;
num2=0;
begain=0;

h1=1;
h2=size(image,1);
sumperdim=sum(image,2); % compute the sum of each row
for n=1:size(image,1);
    if sumperdim(n)>20 
        num1=num1+1;
        begain=1; %标志起始位置
    end
    if(num1==1)
        h1=n;   
    end
    if(begain)
        num2=num2+1;
    end
    if((num2-num1)==1&&begain)
       h2=n-1;
       begain=0;
    end
end
out_image=in_image(h1:h2,:);

end

function [out_image]=extract_edge(in_image,parameter)
% achieve main edges

image=edge(in_image,'canny',parameter);  
SE1=strel('square',10); 
SE2=strel('square',1);
image=imdilate(image,SE1); % connect edges using big square by expansion processing
out_image=imerode(image,SE2); % smooth edges using small square by corrosion treatment
end

function [out_image,Teta] = get_num_area(in_image)
%1.投影得到倾斜图像的左右边界坐标横w1,w2
image = in_image;
for i = 1:size(image,1)
    for j = 1:size(image,2)
        if image(i,j)<100   %背景中的较高灰度影响左右边界测量
            image(i,j) = 0;
        end
    end
end
            
num1=0; 
num2=0;
begain=0;
%threshold=0.01;
w1=1;
w2=size(image,2);
sumperdim=sum(image,1); % compute the sum of each column
for n=1:size(image,2);
    if sumperdim(n)>20   %max(sumperdim(:))*threshold
        num1=num1+1;
        begain=1; %标志起始位置
    end
    if(num1==1)
        w1=n;   
    end
    if(begain)
        num2=num2+1;
    end
    if((num2-num1)==1&&begain)
       w2=n-1;
       begain=0;
    end
end

%subplot(2,1,1),imshow(in_image);
%subplot(2,1,2),imshow(in_image(:,w1:w2));

%2.计算倾斜角度Teta
column_range=size(in_image,2);
image=in_image(:,1:round(0.25*column_range)); %counteract interference 
image=extract_edge(image,0.8);
   %Using Hough Transformation(HT) to caculate the tilt angle of vertical line 
[H,T,~]=hough(image,'Theta',-90:0.5:89.9); 
P=houghpeaks(H,1,'threshold',round(0.1*max(H(:))));
Teta=T(P(:,2))*pi/180;
Abs_Teta=abs(Teta);

%3.计算倾斜图像中号码区的4个顶点坐标(x1,y1)、(x2,y1)、(x1,y2)、(x2,y2)
Height = size(in_image,1);
Width=w2-Height*tan(Abs_Teta) -w1;
y1 = round(0.7*Height);        
y2 =round(0.81*Height); 
x1 = round(w1+5/Height*Width + 0.5*Height*tan(Abs_Teta));
x2 = round(w1+95/Height*Width + 0.6*Height*tan(Abs_Teta));  
  
%4.分割出号码区Area
out_image = in_image(y1:y2,x1:x2);
   %} 
end


end

