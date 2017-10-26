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
persistent t plan board agent safe visited have_gold KB W_index have_arrow stay

if isempty(t)
    t = 0;
    plan = [];
    board = [1,1,1,1; 1,1,1,1;1,1,1,1;0,1,1,1];
    agent.x = 1;
    agent.y = 1;
    agent.dir = 0;
    visited = zeros(4,4);
    visited(4,1) = 1;
    safe = zeros(4,4);
    safe(4,1) = 1;
    have_gold = 0;
    have_arrow = 1;
    [~,KB,~] = CS4300_gen_KB;
    W_index = [0,0];
    stay = 0;
end

MINUS = '-';

FORWARD = 1;
RIGHT = 2;
LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

% logic rules
if ~stay || percept(4)
    sentence = CS4300_make_percept_sentence(percept,agent.x,agent.y);
    KB = CS4300_Tell(KB,sentence);
    for i = 1:16
        y = mod(i-1,4)+1;
        x = 4 - fix((i-1)/4);
        if safe(x,y)
            continue;
        end
        no_pit = CS4300_Ask(KB,CS4300_Packet_CNF(-i));
        no_wum = CS4300_Ask(KB,CS4300_Packet_CNF(-(i+16*4)));
        if no_pit && no_wum
            safe(x,y) = 1;
            board(x,y) = 0;
            continue;
        end
        if CS4300_Ask(KB,CS4300_Packet_CNF(i)) 
            safe(x,y) = -1;
            board(x,y) = 1;
            continue;
        end
        if CS4300_Ask(KB,CS4300_Packet_CNF((i+16*4)))
            safe(x,y) = -1;
            W_index = [x,y];
            board(x,y) = 3;
            continue;
        end
    end
end



% Ask about glitter gold.
if isempty(plan)
    G_i = agent.x+4*(agent.y-1)+16;
    if CS4300_Ask(KB, CS4300_Packet_CNF(G_i))|| percept(3) == 1
        [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
        plan = [GRAB;so(2:end,end);CLIMB];
        have_gold = 1;
    end
end

% Ask about a safe place that never visited before to go.
if isempty(plan)
    OK1 = CS4300_choose_Near(safe,visited,1,agent.x,agent.y);
    if ~isempty(OK1)
        [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [OK1(1),OK1(2),0],'CS4300_A_star_Man');
        plan = [so(2:end,end)];
    end
end


% Ask about shoot the wumpus.
if isempty(plan)
    if have_arrow && W_index(1)~= 0
        % find the safe places that can shoot the wumpus.
        choose_pool = [];
        for i = 1:num_safe
            if rows(i) == W_index(1) && cols(i) > W_index(2)
                choose_pool(end+1) = [rows(i), cols(i), 2];
            end
            if rows(i) == W_index(1) && cols(i) < W_index(2)
                choose_pool(end+1) = [rows(i), cols(i), 0];
            end
            if cols(i) == W_index(2) && rows(i) > W_index(1)
                choose_pool(end+1) = [rows(i), cols(i), 3];
            end
            if cols(i) == W_index(2) && rows(i) < W_index(1)
                choose_pool(end+1) = [rows(i), cols(i), 1];
            end
        end
        % find the closest safe places that can shoot the wumpus.
        if ~isempty(choose_pool)
            dis_safe = 100;
            shoot_place = [0,0,0];
            for i = 1: length(choose_pool(:,1))
                cur = [choose_pool(i,2),4-choose_pool(i,1)+1,];
                dis_cur = CS4300_A_star_Man(cur,[agent.x,agent.y,0]);
                if dis_cur < dis_safe
                    dis_safe = dis_cur;
                    shoot_place = cur;
                end
            end
            [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            shoot_place,'CS4300_A_star_Man');
            plan = [so(2:end,end);SHOOT];
        end
    end
    
end

% Ask to take a risk step.
if isempty(plan)
    OK1 = CS4300_choose_Near(safe,visited,0,agent.x,agent.y);
    if ~isempty(OK1)
        board(4-OK1(2)+1,OK1(1)) = 0;
        [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [OK1(1),OK1(2),0],'CS4300_A_star_Man');   
        plan = [so(2:end,end)];
        board(4-OK1(2)+1,OK1(1)) = 1;
    end
end


if isempty(plan)
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
    plan = [so(2:end,end);CLIMB];
end

action = plan(1);
plan = plan(2:end);

if action==FORWARD
    [x_new,y_new] = CS4300_move(agent.x,agent.y,agent.dir);
    agent.x = x_new;
    agent.y = y_new;
    if ~visited(4-y_new+1,x_new)
        stay =0;
    end
    visited(4-y_new+1,x_new) = 1;
    board(4-y_new+1,x_new) = 0;
end

if action==RIGHT
    agent.dir = rem(agent.dir+3,4);
    stay = 1;
end

if action==LEFT
    agent.dir = rem(agent.dir+1,4);
    stay = 1;
end

if action==GRAB
    have_gold = 1;
    stay = 1;
end
t = t + 1;

end