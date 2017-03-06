function [svm_train_set_fs] = create_svm_train_set_fs(svm_train_set)
load Mat\eigenface
load Mat\m
svm_train_set_fs = [];
[r c] = size(svm_train_set{1,1});
for i = 1:size(svm_train_set,2)
    x = reshape(svm_train_set{1,i}',r*c,1);
    %d = double(x) - m;
    %img_fs = eigenface'* d; 
    img_fs = double(x/255);
    svm_train_set_fs = [svm_train_set_fs img_fs];
end

end
