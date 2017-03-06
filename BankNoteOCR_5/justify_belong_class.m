function [ letter ] = justify_belong_class(letter1,letter2,test_set,testimg_index,class_set)
% Re-recongnize those characters belongs to class_set(k) using SVM 
% so that we can get more confidence about the recognize conclution.

% if recog_words(n) belongs to class_set(k),then call function multi_svm(recog_char,class_num)
% else if none of recog_words(n) belongs to class_set(k),return recog_words derectly.
index1 = letter2index(letter1);
index2 = letter2index(letter2);
if(index1 > index2)
    tmp = index1;
    index1 = index2;
    index2 = tmp;
end

letter = svm(test_set{testimg_index},index1,index2,class_set);   

end

function [ index ] = letter2index(letter)
% ASCII table:
% '0'~'9' = 48~57
% 'A'~''Z' = 65~90
if letter<65  %letter is number
    index = letter-47;
elseif letter<85 
    index = letter-54;
else
    index = letter-55;   %È¥µôÁË'V'
end
end