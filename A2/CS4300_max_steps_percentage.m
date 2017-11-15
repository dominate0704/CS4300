
% CS4300_max_steps_percentage
%    Plot the 1 line to show the impact of varying the maximum 
%    number of steps allowed
% On output:
%   ?The x-axis is the value of max steps that enter in the WW2 function (10 to 1000).
%     The y-axis is the percentage of getting the gold.
%     There is 1 line, 
%     the percentage percentage of getting the gold, 
% Call:
%    run this script.
% Author:
%     Yucheng Yang
% UU
% Fall 2017
%

% set up variables
clear;
x = (10: 10: 1000);
max_steps_percentage = zeros(1, size(x,2));
i = 1;
for n = x
    t = CS4300_multi_test(2000, n);
    max_steps_percentage(i) = t.percentage;
    i= i+1;
end

% Plot 1 line.
plot(x, max_steps_percentage);
title('Graph of the percentage of getting the gold ');
xlabel('Max steps from 10 to 1000'); % x-axis label
ylabel('Percentage'); % y-axis label