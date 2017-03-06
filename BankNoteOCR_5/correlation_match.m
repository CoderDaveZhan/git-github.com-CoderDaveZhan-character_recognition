function [word] = correlation_match(train_set,test_set)
% Caculate correlation between recognized letter & template letter,choose
% the template letter whos correlation is maximum as recognizing result.

%Storage matrix word from image
word=[ ];

% Compute the number of letters in train_set & test_set 
num_train_set=size(train_set,2);
num_test_set=size(test_set,2);
       
 for n=1:num_test_set
    %letter=read_letter(test_set{1,n},num_train_set);
    comp=[ ];
    for j=1 : num_train_set
        if(iscell(test_set))
            sem=corr2(train_set{1,j},test_set{1,n});  %cell
        else
            sem=corr2(train_set(:,j),test_set(:,n));   %matrix
        end
        comp=[comp sem];
    end
    vd = find(comp==max(comp));
%*-*-*-*-*-*-*-*-*-*-*-*-*-
    switch vd
        case 1
            letter='A';
        case 2
            letter='B';
        case 3
            letter='C';
        case 4
            letter='D';
        case 5
            letter='E';
        case 6
            letter='F';
        case 7
            letter='G';
        case 8
            letter='H';
        case 9
            letter='I';
        case 10
            letter='J';
        case 11
            letter='K';
        case 12
            letter='L';
        case 13
            letter='M';
        case 14
            letter='N';
        case 15
            letter='O';
        case 16
            letter='P';
        case 17
            letter='Q';
        case 18
            letter='R';
        case 19
            letter='S';
        case 20
            letter='T';
        case 21
            letter='U';
        case 22
            letter='W';
        case 23
            letter='X';
        case 24
            letter='Y';
        case 25
            letter='Z';
            %*-*-*-*-*
        case 26
            letter='1';
        case 27
            letter='2';
        case 28
            letter='3';
        case 29
            letter='4';
        case 30
            letter='5';
        case 31
            letter='6';
        case 32
            letter='7';
        case 33
            letter='8';
        case 34
            letter='9';
        otherwise
            letter='0';
    end
    
    word=[word letter];
 end
 
end

