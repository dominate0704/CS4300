t = CS4300_multi_test(2000, 2000); 
x =[1,2,3];
y1 =[t(2,1).survive,t(2,2).survive,t(2,3).survive];
y2 =[t(1,1).survive,t(1,2).survive,t(1,3).survive];
plot(x,y1,x,y2)
title('percentage of alive in three broad');
ylim([0 1]);
xlabel('Type of broad'); % x-axis label
ylabel('Percentage'); % y-axis label
legend('y1 = Percentage of Agent_Astar_AC','y2 = Percentage of Agent_Astar');

y1 =[t(2,1).var,t(2,2).var,t(2,3).var];
y2 =[t(1,1).var,t(1,2).var,t(1,3).var];
plot(x,y1,x,y2)
title('Variance in three broad');
xlabel('Type of broad'); % x-axis label
ylabel('Varance'); % y-axis label
legend('y1 = variance of Agent-Astar-AC','y2 = variance of Agent-Astar');
t = CS4300_multi_test(2000, 2000); 
x =[1,2,3];

y1 =[t(2,1).mean,t(2,2).mean,t(2,3).mean];
y2 =[t(1,1).mean,t(1,2).mean,t(1,3).mean];
y3 =[t(2,1).mean+t(2,1).ci95,t(2,2).mean+t(2,2).ci95,t(2,3).mean+t(2,3).ci95];
y4 =[t(1,1).mean+t(2,1).ci95,t(1,2).mean+t(1,2).ci95,t(1,3).mean+t(1,3).ci95];
y5 =[t(2,1).mean-t(2,1).ci95,t(2,2).mean-t(2,2).ci95,t(2,3).mean-t(2,3).ci95];
y6 =[t(1,1).mean-t(1,1).ci95,t(1,2).mean-t(1,2).ci95,t(1,3).mean-t(1,3).ci95];
plot(x,y1,x,y2,x,y3,x,y4,x,y5,x,y6)
title('confidence interval mean steps in three broad');
xlabel('Type of broad'); % x-axis label
ylabel('steps'); % y-axis label
legend('y1 = Steps of Agent-Astar-AC','y2 = Steps of Agent-Astar','y3 = + 95% Steps of Agent-Astar-AC','y4 =+ 95%  Steps of Agent-Astar','y5 = - 95% Steps of Agent-Astar-AC','y6 =- 95%  Steps of Agent-Astar');
