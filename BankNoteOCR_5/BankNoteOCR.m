% Bank Note OCR (Optical Character Recognition).
% Author: DaveZhan
% e-mail: 2583105532@qq.com
% For more information, visit: http://www.cnblogs.com/zhanbiqiang/
%________________________________________
% PRINCIPAL PROGRAM

warning off %#ok<WNOFF>
close all;
clear all;
clc;

% Read image
image = imread('D:\BaiduYunDownload\Document\InnovateProject2014\RMB\RMB_New\postive\rmb4.bmp');
%image = imread('D:\BaiduYunDownload\Document\InnovateProject2014\RMB\postive\upside\rmb81.bmp');
% Get serial number area
[image,angle] = get_area(image);
% Slant correction
image = slant_correct(image,angle);
% Remove bright area
image = chose_char(image);
% Separate characters and save them in test_set.mat
status = character_separate(image);
if status == -1
    error( 'Charater can not be separated');
end

load Mat\test_set.mat
create_test_set_fs(test_set);
load Mat\test_set_fs

% Correlation Matching classifier using test_set_fs & train_set_fs
load Beforehand\Mat\train_set_fs
correlation_match_pca = correlation_match(train_set_fs,test_set_fs); 

% Using the character's feature to judge again
word = feature_judge(test_set,correlation_match_pca);

% If two method is different,using SVM to judge finally
load Beforehand\Mat\class_set
diff = (correlation_match_pca ~= word);
finally_words = correlation_match_pca;
for n = 1:size(diff,2)
    if(diff(n))
       letter1 =  correlation_match_pca(n);
       letter2 =  word(n);
       finally_words(n) = justify_belong_class(letter1,letter2,test_set,n,class_set);
    end
end

% Display finally results
for i = 1:10
    subplot(1,10,i),imshow(test_set{i});
    text(i+2,-40,word(i),'FontSize',18);
    text(i+2,-15,correlation_match_pca(i),'FontSize',18);
    text(i+2,70,finally_words(i),'FontSize',18);
end


