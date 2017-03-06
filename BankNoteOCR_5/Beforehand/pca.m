function [eigenface,m,train_set_fs] = pca(train_set) 
% Using PCA method to caculate the eigenvector of train_set,then transform all data into another space. 
% train_set is a cell matrix,each cell is a MxN matrix,which is a character template 
% test_set is a cell matrix,each cell is a MxN matrix,which is going to be recognized character. 

% align a set of character images (the training set x1, x2, ... , xP )
% matix X  (M*N)xP 
% row represents dimensions : (M*N)
% column represent number of samples : P
X = [];
P = size(train_set,2);
for i = 1:P
    [r,c]=size(train_set{1,i});
    temp = reshape(train_set{1,i}',r*c,1);
    X = [X temp];  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Now we calculate m, A and eigenfaces.The descriptions are below :
%          m           -    (M*N)x1  Mean of the training images
%          D           -    (M*N)xP  Matrix of image after each column vector getting subtracted from the mean image m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% calculating mean image %%%%%
m = mean(X,2); % Computing the average image m = (1/P)*sum(X,2)    (j = 1 : P)

%%%%%%%%  calculating D matrix, i.e. after subtraction of all image vectors from the mean image vector %%%%%%
D = [];
for i=1 : P
    temp = double(X(:,i)) - m;
    D = [D temp];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CALCULATION OF EIGENVECTORS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         cov           -    PxP                 covariance matrix of D
%       vector          -    PxP                 eigenvector matrix of cov
%       value           -    IP                  eigenvalue matrix of cov
%       eig_vec         -    PxK                 sub part of vecter corresponding to the value that satisfy value(i,i)>1
%       eigenfaces      -   (M*N)xK             combination by K radixs on the facespace,used to transform origin image to facespace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cov= D'* D;
[vector,value]=eig(cov); 

%%%% again we use Kaiser's rule here to find how many Principal Components (eigenvectors) to be taken
%%%% if corresponding eigenvalue is greater than 1, then the eigenvector will be chosen for creating eigenface
eig_vec = [];
for i = 1 : size(vector,2) 
    if( value(i,i) > 1 )
        eig_vec = [eig_vec vector(:,i)];
    end
end

%%% transform train_set into eigenspace %%%
eigenface = D * eig_vec;

%In this part, we transform each character image into facespace 
%            train_img_fs     -    Kx1       single character image(from train_set) on the facespace
%            train_set_fs     -    KxP       combined by P train_img_fs,each column corresponding to one character
%            test_img_fs      -    Kx1       single character image(from test_set) on the facespace
%            test_set_fs      -    Kxsize(test_set,2)     combined by test_img_fs,each column corresponding to one recognizing character image
%              D              -   (M*N)xP    see  former definition above
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% train_set
train_set_fs = [];
for i=1:P
    train_img_fs = eigenface'*D(:,i);
    train_set_fs = [train_set_fs train_img_fs];
end

end
