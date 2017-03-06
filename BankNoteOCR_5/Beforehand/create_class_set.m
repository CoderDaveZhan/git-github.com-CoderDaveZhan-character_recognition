% Create class_set struct
% class_set(combined by some characters which are difficult to distinguish)

close all
clear all
clc

one_classes_table = {'0','1','2','3','4','5','6','7','8','9',...
                     'A','B','C','D','E','F','G','H','I','J',...
                     'K','L','M','N','O','P','Q','R','S','T',...
                     'U','W','X','Y','Z'};
num_classes = size(one_classes_table,2);

for n_c1 = 1:num_classes
    for n_c2 = (n_c1+1):num_classes
        two_classes_table(n_c1,n_c2) = {[one_classes_table{n_c1},one_classes_table{n_c2}]};
        [img_set,group_tra]= create_train_set_svm(two_classes_table{n_c1,n_c2});
        img_set_fs = create_svm_train_set_fs(img_set);
        svm_stru = svmtrain(img_set_fs',group_tra','KERNEL_FUNCTION','rbf','RBF_Sigma',1);
        
       % train_set_fs(n_c1,n_c2) = {img_set_fs};
       % group_train(n_c1,n_c2) = {group_tra}; 
        svm_struct(n_c1,n_c2) = {svm_stru}; 
    end
end

class_set = struct('class_set_name',two_classes_table,...
                   'svm_struct',svm_struct);

save('Mat\class_set','class_set');

close all;
clear;
clc;