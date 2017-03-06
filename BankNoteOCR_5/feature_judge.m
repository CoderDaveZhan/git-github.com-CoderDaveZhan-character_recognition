function [ word ] = feature_judge(test_set,correlation_match_pca)
%对传入的识别结果进行特征纠正

word = correlation_match_pca;
for i = 1:10
    % 如果B断裂了，容易被当作H
    if correlation_match_pca(i)=='H' 
       if  feature_recognize(test_set{i},'vertical_line')==1 && feature_recognize(test_set{i},'close_ring')~=0
           word(i) = 'B';
       elseif feature_recognize(test_set{i},'vertical_line')==2
           word(i) = 'H';
       end
       continue;
    end
    
    % 2容易被匹配成Z和7，反之不易；
    if correlation_match_pca(i)=='Z' || correlation_match_pca(i)=='7' 
        if feature_recognize(test_set{i},'vertical_cross',2)==2
            word(i) = '7';
        elseif feature_recognize(test_set{i},'vertical_cross',2)==3
            if feature_recognize(test_set{i},'horizontal_line')==3 || feature_recognize(test_set{i},'horizontal_cross',1)==2
                word(i) = '2';
            elseif feature_recognize(test_set{i},'horizontal_line')==5 || feature_recognize(test_set{i},'horizontal_cross',1)==1
                word(i) = 'Z';
            end
        end
        continue;
    end  
    
    
    if correlation_match_pca(i)=='6' || correlation_match_pca(i)=='8' ...
            || correlation_match_pca(i)=='S' || correlation_match_pca(i)=='B'
        if feature_recognize(test_set{i},'close_ring')==1
            word(i) = '6';
        elseif feature_recognize(test_set{i},'close_ring')==2
            if feature_recognize(test_set{i},'vertical_line')==1
                word(i) = 'B';
            elseif feature_recognize(test_set{i},'vertical_line')==0
                word(i) = '8';
            end
        elseif feature_recognize(test_set{i},'close_ring')==0
            word(i) = 'S';   % S和5可以被匹配法准确区分，无需增加特征判断
        else
            word(i) = correlation_match_pca(i);
        end
        continue;
    end

    if correlation_match_pca(i)=='Q' || correlation_match_pca(i)=='O' || correlation_match_pca(i)=='0' || correlation_match_pca(i)=='D' ...
            || correlation_match_pca(i)=='C' || correlation_match_pca(i)=='G' 
        if feature_recognize(test_set{i},'close_ring')==0
            if feature_recognize(test_set{i},'vertical_cross',3)==3
                word(i) = 'G';
            elseif feature_recognize(test_set{i},'vertical_cross',3)==2
                word(i) = 'C';
            end
        elseif feature_recognize(test_set{i},'close_ring')==1
            if feature_recognize(test_set{i},'vertical_line')==1
                word(i) = 'D';
            else
                if feature_recognize(test_set{i},'horizontal_cross',3)==3 || feature_recognize(test_set{i},'horizontal_cross',2)==3 || feature_recognize(test_set{i},'vertical_cross',2)==3
                    word(i) = 'Q';
                elseif feature_recognize(test_set{i},'horizontal_cross',3)==2
                    if feature_recognize(test_set{i},'open_derection')==0
                        word(i) = '0';
                    elseif feature_recognize(test_set{i},'open_derection')==3
                        word(i) = '6';  % 由于部分6不清晰，被当作C而进入这个判决语句。而C不会被当成6，故只需在这里做下判断即可。
                    end
                end
            end
        else
            word(i) = correlation_match_pca(i);
        end
        continue;
    end     
    
    
end


end

