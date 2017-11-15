% CS4300_meanforAC
%    Plot the 4 line to show the impact of varying the maximum 
%    number of steps allowed
% On output:
%   ?The x-axis is the value of max steps that enter in the WW2 function (10 to 1000).
%     The y-axis is the number of the steps.
%     There is 4 lines, 
%     the mean  value of steps, 
%     95% upper boundary, 
%     95% lower boundary, 
%     the value of max steps.
% Call:
%    run this script.
% Author:
%     Yucheng Yang
% UU
% Fall 2017
%

% set up variables.
clear;
clear CS4300_agent_Astar_AC;
x = (10: 10: 1000);
max_steps_mean = zeros(1, size(x,2));
max_steps_upperbound = zeros(1, size(x,2));
max_steps_lowerbound = zeros(1, size(x,2));

% compute the Z of 95% confidence.
ci = 0.95;
alpha = 1 - ci;
T_multiplier = tinv(1-alpha/2, 2000-1);


i = 1;
for n = 1:size(x,2)
                
    max_steps_mean(i) = t.mean;
    ci95 = T_multiplier*t.variance/sqrt(2000);    % the range of confidence intervals.
    max_steps_upperbound(i) = t.mean+ci95;
    max_steps_lowerbound(i) = t.mean-ci95;
    i= i+1;
end

% Plot 4 lines.
plot(x, max_steps_mean, x,max_steps_upperbound, x, max_steps_lowerbound);  
title('Graph of the mean of steps and 95% confident intervals');
ylim([0 60]);
xlabel('Max steps from 10 to 1000'); % x-axis label
ylabel('Number of steps'); % y-axis label
legend('y1 = mean of steps','y2 = upperbound of steps','y3 =  lowerbound of mean');
