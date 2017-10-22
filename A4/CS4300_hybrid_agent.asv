function action = CS4300_hybrid_agent(percept)
% CS4300_hybrid_agent - hybrid random and logic-based agent

% On input:
% percept( 1x5 Boolean vector): percepts
% On output:
% action (int): action selected by agent
% Pit: 1-16
% Glitter: 17-32
% Breeze: 33-48
% Stench: 49-64
% Wempus 65-80
% Call:
% a = CS4300_hybrid_agent([0,0,0,0,0]);
% Author:
% <Your name>
% UU
% Fall 2017
%
persistent t plan board agent safe visited have_gold KB

if isempty(t)
    t = 0;
    plan = [];
    board = [-1,-1,-1,-1; -1,-1,-1,-1;-1,-1,-1,-1;0,-1,-1,-1];
    agent.x = 1;
    agent.y = 1;
    agent.dir = 0;
    visited = zeros(4,4);
    visited(4,1) = 1;
    safe = zeros(4,4);
    safe(4,1) = 1;
    have_gold = 0;
    [~,KB,~] = CS4300_gen_KB;
end

MINUS = '-';

FORWARD = 1;
RIGHT = 2;
LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

% informal logic rules
sentence = CS4300_make_percept_sentence(percept,agent.x,agent.y);
KB = CS4300_Tell(KB,sentence);
for i = 1:16
    x = mod(i-1,4)+1;
    y = 4 - fix((i-1)/4);
    if CS4300_Ask(KB,-i) && CS4300_Ask(KB,-(i+16*4))
        safe(x,y) = 1;
    end
    if CS4300_Ask(KB,i) || CS4300_Ask(KB,(i+16*4))
        safe(x,y) = -1;
    end
end


[rows,cols] = find(safe == 1);
if ~isempty(rows)
    num_safe = length(rows);
    for s = 1:num_safe
        board(rows(s),cols(s)) = 0;
    end
end

if have_gold==0 && percept(3)==1
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
    plan = [GRAB;so(2:end,end);CLIMB];
end

if isempty(plan)
    OK1 = CS4300_choose1(safe,visited);
    if ~isempty(OK1)
        [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [OK1(1),OK1(2),0],'CS4300_A_star_Man');
        plan = [so(2:end,end)];
    end
end

if isempty(plan)
    goal = [];
    neighbors = CS4300_Wumpus_neighbors(agent.x,agent.y);
    num_neighbors = length(neighbors(:,1));
    for n = 1:num_neighbors
        if board(4-neighbors(n,2)+1,neighbors(n,1))<0
            goal = neighbors(n,:);
        end
    end
    if isempty(goal)
        [rows,cols] = find(board==-1);
        if isempty(rows)
            goal = [1,1];
        else
            goal = [cols(1),4-rows(1)+1];
        end
    end
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [goal,0],'CS4300_A_star_Man');
    plan = [so(2:end,end)];
end

if isempty(plan)
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
    plan = [so(2:end,end)];
end

action = plan(1);
plan = plan(2:end);

if action==FORWARD
    [x_new,y_new] = CS4300_move(agent.x,agent.y,agent.dir);
    agent.x = x_new;
    agent.y = y_new;
    visited(4-y_new+1,x_new) = 1;
    board(4-y_new+1,x_new) = 0;
end

if action==RIGHT
    agent.dir = rem(agent.dir+3,4);
end

if action==LEFT
    agent.dir = rem(agent.dir+1,4);
end

if action==GRAB
    have_gold = 1;
end
t = t + 1;

end