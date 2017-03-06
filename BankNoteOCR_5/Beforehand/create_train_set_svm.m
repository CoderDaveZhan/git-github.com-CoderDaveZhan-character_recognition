function [img_set,group_train] = create_train_set_svm(class_set_name)
% This function get images located on diffirent folders whos 
% directory name are specified by string class_name.
% Arguments:
% class_names is a string combinded by serials chars like
% '56B8S',represent some being recognized characters class.

class_folder_path = strcat(pwd,'\single_characters_for_training\');
kinds = size(class_set_name,2);
file_ext = '.bmp';
img_set = [];
group_train = [];
total_imgs = 0;
for k = 1:kinds
    sub_class_path = strcat(class_folder_path,class_set_name(k),'\');
    class_content = dir([sub_class_path,'*',file_ext]);
    num_img_perclass = size(class_content,1);
    for n=1:num_img_perclass
        img_name = [sub_class_path,class_content(n,1).name];
        eachimg = imread(img_name);
        img_set = [img_set eachimg];
    end
    total_imgs = total_imgs + num_img_perclass;
    % example:
    % if group_train = [1 1 2 2] while class_set_name = 'B8'
    % it means there are 4 images in img_set,img_set{1} & img_set{2}
    % belong class 'B',thus img_set{3} & img_set{4} belong class '8'
    tmp = ones(1,num_img_perclass).*k;
    group_train = [group_train tmp]; 
end
img_set = mat2cell(img_set,42,ones(1,total_imgs).*24);

end

