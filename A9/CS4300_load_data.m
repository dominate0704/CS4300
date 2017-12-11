function [X,Y] = CS4300_load_data()
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
name_g = 'g';
name_p = 'p';
name_w = 'w';
name_2 = '.jpg';
index = 1
Y = zeros(27,1);
for index = 1:27
    if index <= 9
        name = strcat(name_g,int2str(index), name_2);
        Y(index) = 1;
    elseif index <= 18 && index > 9
        name = strcat(name_p,int2str(index-9), name_2);
        Y(index) = 2;     
    elseif index <= 27 && index > 18
        name = strcat(name_w,int2str(index-18), name_2);
        Y(index) = 3;
    end
    im = imread(name);
    im = imresize(im,[15,15]);
    im = im>50;
    column_8 = im(:,8);
    X(index,:) = column_8(:);
end 
end