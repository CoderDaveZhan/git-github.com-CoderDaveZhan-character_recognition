function [ letter ] = svm(recog_char,index1,index2,class_set)

%%% Get train_set_fs & test_img_fs & group_train
%  m             -   (M*N)x1   Mean of the training images
%  eigenfaces    -   (M*N)xK   combination by K radixs on the facespace,used to transform origin image to facespace
%  train_set_fs  -    KxP      combined by P train_img_fs,each column corresponding to one character
%  group_train   -    1xP
[r,c] = size(recog_char);
%{
eigenface = class_set(index1,index2).eigenface;
m = class_set(index1,index2).mean;
%}
load Beforehand\Mat\eigenface
load Beforehand\Mat\m

svm_struct = class_set(index1,index2).svm_struct;
%test_img_fs = eigenface'*(reshape(recog_char',r*c,1)-m); 
test_img_fs = double(reshape(recog_char',r*c,1));

%{
if(svmclassify(svm_struct,test_img_fs'))
    choose = 1;
else
    choose = 2;
end
%}
choose = svmclassify(svm_struct,test_img_fs');
letter = class_set(index1,index2).class_set_name(choose);

end

