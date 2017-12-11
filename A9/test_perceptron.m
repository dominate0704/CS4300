clear all;
[X,Y] = CS4300_load_data;
[w,pc] = CS4300_perceptron_learning(X,Y ==1,0.1,10000,1);
plot(pc');