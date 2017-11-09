function action = CS4300_MC_agent(percept)
% CS4300_MC_agent - Monte Carlo agent with a few informal rules
% On input:
% percept (1x5 Boolean vector): percept from Wumpus world
% (1): stench
% (2): breeze
% (3): glitter
% (4): bump
% (5): scream
% On output:
% action (int): action to take
% 1: FORWARD
% 2: RIGHT
% 3: LEFT
% 4: GRAB
% 5: SHOOT
% 6: CLIMB
% Call:
% a = CS4300_MC_agent(percept);
% Author:
% <Yucheng Yang>
% UU
% Fall 2017
%
persistent t pits Wumpus breezes stench num_trials board plan agent safe visited have_gold W_index have_arrow stay


if isempty(t)
    t = 0;
    plan = [];
    board = [1,1,1,1; 1,1,1,1;1,1,1,1;0,1,1,1];
    pits = zeros(4,4);
    Wumpus = zeros(4,4);
    breezes = -ones(4,4);
    stench = -ones(4,4);
    agent.x = 1;
    agent.y = 1;
    agent.dir = 0;
    visited = zeros(4,4);
    visited(4,1) = 1;
    safe = zeros(4,4);
    safe(4,1) = 1;
    have_gold = 0;
    have_arrow = 1;
    W_index = [0,0];
    stay = 0;
    num_trials = 200;
end

MINUS = '-';

FORWARD = 1;
RIGHT = 2;
LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

% new cell or scream
if ~stay || percept(4)
    y = (4-agent.y)+1;
    breezes(y,agent.x) = percept(2);
    stench(y,agent.x) = percept(1);
    % if scream, clear all stench data to zero.No Wumpus.
    if percept(5)
        stench = zeros(4,4);
        W_index = [-1,-1];
    end
    % get the pits and wumpus table.
    [pits,Wumpus] = CS4300_WP_estimates(breezes, stench ,num_trials);
    if W_index(1)== -1
        Wumpus = [0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0];
    end
    for i = 1:16
        y = mod(i-1,4)+1;
        x = 4 - fix((i-1)/4);
        if (pits(x,y) == 0 )&& (Wumpus(x,y) ==0 )     % Find the cell that no pit and no wumpus.
            safe(x,y) = 1;
            continue;
        end
        if Wumpus(x,y) == 1
            W_index = [x y];
        end
    end
end

%%
%Ask about glitter gold
if isempty(plan)
    if percept(3) == 1
        [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
        [1,1,0],'CS4300_A_star_Man');
        plan = [GRAB;so(2:end,end);CLIMB];
        have_gold = 1;
    end
end

[row, col] = CS4300_frontier(visited);
%%
% Ask about a safe place to go, or choose the relatively safest cell

if isempty(plan)
    OK1 =[];
    for i = 1:length(row)
        if safe(row(i),col(i))
            OK1 = [col(i),4-row(i)+1];
            board(4-OK1(2)+1,OK1(1)) = 0;
            [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            [OK1(1),OK1(2),0],'CS4300_A_star_Man');
            plan = [so(2:end,end)];
            board(4-OK1(2)+1,OK1(1)) = 1;
            break;
        end
    end
end
%%
%Try to shoot the Wumpus
if isempty(plan)
    if have_arrow == 1 && W_index(1)~= 0
        % find the safe places that can shoot the wumpus.
        choose_pool = [];
        for i = 1:16
            y = mod(i-1,4)+1;
            x = 4 - fix((i-1)/4);
            if x == W_index(1) && y > W_index(2) && safe(x,y) == 1
                choose_pool = [choose_pool;x, y, 2];
            end
            if x == W_index(1) && y < W_index(2) && safe(x,y) == 1
                 choose_pool = [choose_pool;x, y, 0];
            end
            if y == W_index(2) && x > W_index(1) && safe(x,y) == 1
                 choose_pool = [choose_pool;x, y, 1];
            end
            if y == W_index(2) && x < W_index(1) && safe(x,y) == 1
                 choose_pool = [choose_pool;x, y, 3];
            end
        end
        % find the closest safe places that can shoot the wumpus.
        if ~isempty(choose_pool)
            dis_safe = 100;
            shoot_place = [0,0,0];
            for i = 1: length(choose_pool(:,1))
                cur = [choose_pool(i,2),4-choose_pool(i,1)+1,choose_pool(i,3)];
                dis_cur = CS4300_A_star_Man(cur,[agent.x,agent.y,0]);
                if dis_cur < dis_safe
                    dis_safe = dis_cur;
                    shoot_place = cur;
                end
            end
            [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            shoot_place,'CS4300_A_star_Man');
            if so(end,3) == cur(3)
                plan = [so(2:end,end);SHOOT];
            else
                plan = [so(2:end,end)];
                face = so(end,3);
                while face > cur(3)
                    plan = [plan;2];
                    face= face-1;
                end
                while face < cur(3)
                    plan = [plan;3];
                    face= face+1;
                end
                plan = [plan;SHOOT];
            end
            have_arrow = 0;
        end
    end
end
%%
%Try to shoot potential Wumpus
if isempty(plan)
    if have_arrow == 1 
        % Find the highest probability Wumpus. 
        for i = 1:length(row)
            dangerous =[0,0.5];
            dangerous_cur = [breezes(row(i),col(i)) Wumpus(row(i),col(i))];
            % A cell has lower probability than pervious lowest cell. 
            if  dangerous_cur(2) > 0.5 && dangerous_cur(2) > dangerous(2)
                W_index = [row(i),col(i)];
                dangerous = dangerous_cur;
                continue;
            end
        end
        % find the safe places that can shoot the wumpus.
        choose_pool = [];
        for i = 1:16
            y = mod(i-1,4)+1;
            x = 4 - fix((i-1)/4);
            if x == W_index(1) && y > W_index(2) && safe(x,y) == 1
                choose_pool = [choose_pool;x, y, 2];
            end
            if x == W_index(1) && y < W_index(2) && safe(x,y) == 1
                 choose_pool = [choose_pool;x, y, 0];
            end
            if y == W_index(2) && x > W_index(1) && safe(x,y) == 1
                 choose_pool = [choose_pool;x, y, 1];
            end
            if y == W_index(2) && x < W_index(1) && safe(x,y) == 1
                 choose_pool = [choose_pool;x, y, 3];
            end
        end
        % find the closest safe places that can shoot the wumpus.
        if ~isempty(choose_pool)
            dis_safe = 100;
            shoot_place = [0,0,0];
            for i = 1: length(choose_pool(:,1))
                cur = [choose_pool(i,2),4-choose_pool(i,1)+1,choose_pool(i,3)];
                dis_cur = CS4300_A_star_Man(cur,[agent.x,agent.y,0]);
                if dis_cur < dis_safe
                    dis_safe = dis_cur;
                    shoot_place = cur;
                end
            end
            [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
            shoot_place,'CS4300_A_star_Man');
            if so(end,3) == cur(3)
                plan = [so(2:end,end);SHOOT];
            else
                plan = [so(2:end,end)];
                face = so(end,3);
                while face > cur(3)
                    plan = [plan;2];
                    face= face-1;
                end
                while face < cur(3)
                    plan = [plan;3];
                    face= face+1;
                end
                plan = [plan;SHOOT];
            end
            have_arrow = 0;
        end
    end
end

%%
%Try to find a relatively safe cell to go.
if isempty(plan)
    OK1 =[];
    dangerous = [1 1];
    for i = 1:length(row)
        dangerous_cur = [breezes(row(i),col(i)) Wumpus(row(i),col(i))];
        % A cell has lower probability on one of the pit or Wumpus. if any probability of Wumpus is
        % bigger or equal to  0.5, there is no way it is a relatively safe
        % cell.if any probability of pit is bigger or equal than 0.25,
        % there is no way it is a relatively safe cell.
        if ((dangerous_cur(1)-0.2)*2+dangerous_cur(2)) < ((dangerous(1)-0.2)*2+dangerous(2)) && ...
                dangerous_cur(1) <= 0.25 && dangerous_cur(2) <= 0.5
            OK1 = [col(i),4-row(i)+1];
            dangerous = dangerous_cur;
            continue;
        end
    end
    % when there is no relatively safe cell, just choose a cell looks less
    % risk.
    if isempty(OK1)
        for i = 1:length(row)
            dangerous_cur = [breezes(row(i),col(i)) Wumpus(row(i),col(i))];
            % A cell has lower probability on one of the pit or Wumpus. if any probability of Wumpus is
            % bigger or equal to  0.5, there is no way it is a relatively safe
            % cell.if any probability of pit is bigger or equal than 0.25,
            % there is no way it is a relatively safe cell.
            if ((dangerous_cur(1)-0.2)*2+dangerous_cur(2)) < ((dangerous(1)-0.2)*2+dangerous(2))      
                OK1 = [col(i),4-row(i)+1];
                dangerous = dangerous_cur;
                continue;
            end
        end
    end
    
    
    
    if isempty(OK1)
        OK1 = [col(1),4-row(1)+1];
    end
    board(4-OK1(2)+1,OK1(1)) = 0;
    [so,no] = CS4300_Wumpus_A_star(board,[agent.x,agent.y,agent.dir],...
    [OK1(1),OK1(2),0],'CS4300_A_star_Man');
    plan = [so(2:end,end)];
    board(4-OK1(2)+1,OK1(1)) = 1;
end

%%
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
