function [] = create_test_set_fs(test_set)
load Beforehand\Mat\eigenface
load Beforehand\Mat\m
test_set_fs = [];
for i = 1:size(test_set,2)
    [r c] = size(test_set{1,i});
    x = reshape(test_set{1,i}',r*c,1);
    d = double(x) - m;
    test_img_fs = eigenface'* d; 
    test_set_fs = [test_set_fs test_img_fs];
end
save('Mat\test_set_fs','test_set_fs');

end
