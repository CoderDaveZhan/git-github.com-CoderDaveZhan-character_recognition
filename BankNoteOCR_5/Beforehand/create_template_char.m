% This file is used to get template characters by mean();
warning off %#ok<WNOFF>
% Clear all
clc, close all, clear all

sub_folder_name = 'ABCDEFGHIJKLMNOPQRSTUWXYZ1234567890';
%sub_folder_name = 'Q';
main_folder_path = strcat(pwd,'\single_characters_for_training\');
file_ext = '.bmp';
for n = 1:size(sub_folder_name,2)
    sub_folder_path = strcat(main_folder_path,sub_folder_name(n),'\');
    sub_folder_content = dir([sub_folder_path,'*',file_ext]);
    num_img_sub = size(sub_folder_content,1);
    sum = uint16( zeros(42,24) );
    for i = 1:num_img_sub
        full_name = [sub_folder_path,sub_folder_content(i,1).name];
        image = imread(full_name);
        if islogical(image)
            image = 255 .* image;
        end
        image = uint16(image);
        sum = sum + image;
    end
    means = uint8( sum ./ num_img_sub );
    means = im2bw(means);
    means_name = strcat(pwd,'\letters_numbers\',sub_folder_name(n),file_ext);
    imwrite(means,means_name,'bmp');
    
end
