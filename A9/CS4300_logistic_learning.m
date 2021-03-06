function [w,per_cor,Se] = CS4300_logistic_learning(X,y,alpha,max_iter,rate)
% CS4300_logistic_learning - find linear separating hyperplane
% Eqn 18.8, p. 727 Russell and Norvig
% On input:
% X (nxm array): n independent variable samples each of length m
% y (nx1 vector): dependent variable samples
% alpha (float): learning rate
% max_iter (int): max number of iterations
% rate (Boolean): 1 use alpha = 1000/(1000+iter) else constant
% alpha
% On output:
% w ((m+1)x1 vector): weights for linear function
% per_cor (kx1 array): trace of percentage correct with weight
% Se (kx1 array): trace of squared error
% Call:
% [w,pc,Se] = CS4300_logistic_learning(X,y,0.1,10000,1);
% Author:
% <Your Name>
% UU
% Fall 2017
%
len  = length(y);
long_len = length(X(1,:));
w = rand(long_len+1,1)/100;
per_cor = [];
X= [ones(len,1),X];
for i = 1:max_iter
    index = randi(len);
    x = X(index,:);
    h_x = 1/(1+exp(-x*w));
    if rate == 1
        alpha = 1000/(1000+i);
    end
    w = w+alpha*(y(index)-h_x)*h_x*(1-h_x)*x';
    per_cor(i) = sum((w'*X' >0)==y')/len;
    Se(i) = (sum((y-1./(1+exp(-X*w))).^2))/len;
%     if per_cor(i) ==1
%         break;
%     end
end
end
