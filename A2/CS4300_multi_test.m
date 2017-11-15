function result = CS4300_multi_test( number_of_trails , max_steps )
%CS4300_multi_test  run the WW2 for n times
%   Analyse  Run 2000 trials and determine the mean and variance of the number of steps the
%agent survives and the percentage of times the agent arrives at square [2, 2].
%On input:
%   number_of_trails(int) : Run n trials
%On output:
%   result(1*3 float vector):
%   mean, variance, percentage of times
% Call:
% a = CS4300_multi_test (2000);
% Author
% <Yucheng Yang>
% UU
% Fall 2017
%
for p = 1:2
    for q = 1:3
        result(p,q).survive = 0;
        result(p,q).mean = 0;
        result(p,q).var = 0;
        result(p,q).ci95 = 0;
        trackstep(p,q).steps = [];
    end
end
board1 = [1,1,1,1;0,0,0,2;0,0,0,0;0,0,0,0];
board2 = [1,1,1,1;0,1,0,2;0,1,0,0;0,0,0,0];
board3 = [1,1,1,1;1,1,1,2;0,0,0,0;0,1,0,1];
for p = 1:number_of_trails
    clear CS4300_agent_Astar_AC;
    t = CS4300_WW1(max_steps,'CS4300_agent_Astar_AC',board1);
    if t(end).agent.succeed
         result(2,1).survive = result(2,1).survive + 1;
         trackstep(2,1).steps = [trackstep(2,1).steps; length(t)];
    end
    clear CS4300_agent_Astar_AC;
    trace2 = CS4300_WW1(max_steps,'CS4300_agent_Astar_AC',board2);
    if trace2(end).agent.succeed
        result(2,2).survive = result(2,2).survive + 1;
        trackstep(2,2).steps = [trackstep(2,2).steps; length(t)];   
    end
    clear CS4300_agent_Astar_AC;
    trace3 = CS4300_WW1(max_steps,'CS4300_agent_Astar_AC',board3);
    if trace3(end).agent.succeed
        result(2,3).survive = result(2,3).survive + 1;
        trackstep(2,3).steps = [trackstep(2,3).steps; length(t)];
    end
     clear CS4300_agent_Astar;
    trace1_1 = CS4300_WW1(max_steps,'CS4300_agent_Astar',board1);
    if trace1_1(end).agent.succeed
        result(1,1).survive = result(1,1).survive + 1;
        trackstep(1,1).steps = [trackstep(1,1).steps; length(t)];   
    end
    clear CS4300_agent_Astar;
    trace2_2 = CS4300_WW1(max_steps,'CS4300_agent_Astar',board2);
    if trace2_2(end).agent.succeed
        result(1,2).survive = result(1,2).survive + 1;
        trackstep(1,2).steps = [trackstep(1,2).steps; length(t)];
    end
    clear CS4300_agent_Astar;
    trace3_3 = CS4300_WW1(max_steps,'CS4300_agent_Astar',board3);
    if trace3_3(end).agent.succeed
       result(1,3).survive = result(1,3).survive + 1;
       trackstep(1,3).steps = [trackstep(1,3).steps; length(t)];
    end
    
end
for p = 1:2
    for q = 1:3
        result(p,q).mean = mean(trackstep(p,q).steps);
        result(p,q).var = var(trackstep(p,q).steps);
        result(p,q).ci95 = sqrt(result(p,q).var / result(p,q).survive) * 1.960;
        result(p,q).survive = result(p,q).survive / number_of_trails;
    end
end
end

