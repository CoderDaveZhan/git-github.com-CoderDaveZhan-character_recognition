load Mat\train_set.mat

[eigenface,m,train_set_fs] = pca(train_set);
save('Mat\eigenface','eigenface');
save('Mat\m','m');
save('Mat\train_set_fs','train_set_fs');

clear all


