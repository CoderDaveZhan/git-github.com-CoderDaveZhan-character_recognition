function [ out_image ] = slant_correct( image,angle )
%��б����
if abs(angle)>0.05
    for row=1:size(image,1) 
        % judge the angle's positive and negative
        if angle>=0
           dy=size(image,1)-row+1;  
           dx=dy*tan(angle);  
           Xthreshold = round(size(image,2)-row*tan(angle));
        else
           dy=row;  
           dx=dy*tan(-angle); 
           Xthreshold = round(size(image,2)-(size(image,1)-row)*tan(-angle));
        end
        for column=1:Xthreshold 
                x=round(column-dx); 
                if x>0
                    image(row,x) = image(row,column);
                end
        end
    end
    out_image=image(:,1:x);% Remove unnecessary part generated by pixel pannin
else
    out_image=image;
end

%��ȥ��౳��
xdim = sum(out_image,1);
for i = 1:size(xdim,2)
    if xdim(i)>0.8*max(xdim)
        x_index = i;
        break;
    end
end
out_image = out_image(:,x_index:end);


end

