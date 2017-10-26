s = tic;
clear CS4300_hybrid_agent;
a = CS4300_hybrid_agent([1,1,0,0,0])
toc(s)
return;




clear ALL;
tic;
% action =CS4300_hybrid_agent([0,0,0,0,0]);

%[s,t] = CS4300_WW3(50,'CS4300_hybrid_agent');
traces = [];

agent.x = 1;
agent.y = 1;
agent.alive = 1;  
agent.gold = 0;  % grabbed gold in same room
agent.dir = 0;  % facing right
agent.succeed = 0;  % has gold and climbed out
agent.climbed = 0; % climbed out



f_name = 'CS4300_hybrid_agent';
max_steps = 100;
clear(f_name);

board1 = [0,0,0,3;...
    2,0,0,0;...
    0,1,0,0;...
    0,0,0,0];
[score,trace] = CS4300_WW1(max_steps,f_name,board1);
scores(1).board = board1;
scores(1).score = score;
scores(1).trace = trace;
M = CS4300_show_trace(trace,0.5);

% clear(f_name);
% 
% board2 = [0,0,0,1;...
%     3,2,1,0;...
%     0,0,0,0;...
%     0,0,1,0];
% [score,trace] = CS4300_WW1(max_steps,f_name,board2);
% scores(2).board = board2;
% scores(2).score = score;
% scores(2).trace = trace;

% clear(f_name);
% 
% board3 = [0,0,0,0;...
%     0,0,0,0;...
%     3,2,0,0;...
%     0,1,0,0];
% [score,trace] = CS4300_WW1(max_steps,f_name,board3);
% scores(3).board = board3;
% scores(3).score = score;
% scores(3).trace = trace;

toc;
