function [w,per_cor] = CS4300_perceptron_learning(X,y,alpha,max_iter,rate)
% CS4300_perceptron_learning - find linear separating hyperplane
% Eqn 18.7, p. 724 Russell and Norvig
% On input:
% X (nxm array): n independent variable samples each of length m
% y (nx1 vector): dependent variable samples
% alpha (float): learning rate
% max_iter (int): max number of iterations
% rate (Boolean): if 1 then alpha = 1000/(1000+iter), else
% constant
% On output:
% w ((m+1)x1 vector): weights for linear function
% per_cor (kx1 array): trace of percentage correct with weight
% Call:
% [w,pc] = CS4300_perceptron_learning(X,y,0.1,10000,1);
% Author:
% <Your name>
% UU
% Fall 2017
len  = length(y);
long_len = length(X(1,:));
w = rand(long_len+1,1)/100;
per_cor = [];
X= [ones(len,1),X];
for i = 1:max_iter
    index = randi(len);
    x = X(index,:);
    h_x = x*w;
    if rate == 1
        alpha = 1000/(1000+i);
    end
    cur_predict = h_x>0;
    w = w+alpha*(y(index)-cur_predict)*x';
    per_cor(i) = sum((w'*X' >0)==y')/len;
%     if per_cor(i) ==1
%         break;
%     end
end
end