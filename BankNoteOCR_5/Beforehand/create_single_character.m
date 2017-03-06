% This file is used to get single serial character pictures as input data source of svmtrain().
warning off %#ok<WNOFF>
% Clear all
clc, close all, clear all
% 
%BankNote_folder = 'D:\BaiduYunDownload\Document\InnovateProject2014\RMB\postive\down\';
BankNote_folder = 'D:\BaiduYunDownload\Document\InnovateProject2014\RMB\RMB_New\postive\';
file_ext = '.bmp';
BankNote_content = dir([BankNote_folder,'*',file_ext]);
nBankNote = size(BankNote_content,1);
for k=1:nBankNote
    string = [BankNote_folder,BankNote_content(k,1).name];
    image=imread(string);
    % Get serial number area
    [image,angle] = get_area(image);
    % Slant correction
    image = slant_correct(image,angle);
    % Remove bright area
    image = chose_char(image);
    % Separate characters and save them in test_set.mat
    status = character_separate(image);
    if status == -1
        fprintf('BankNote [ %s ] can not be separated.\n',BankNote_content(k,1).name);
        continue;
    end
    load Mat\test_set.mat
    for i = 1:size(test_set,2)
        img_name = strrep(BankNote_content(k,1).name,file_ext,'_');
        img_name = strcat(pwd,'\single_characters_for_training\',...
                          img_name,num2str(i),file_ext);
        imwrite(test_set{i},img_name,'bmp');
    end
end