function action = CS4300_agent_Astar(percept)
% CS4300_agent_Astar - A* search agent example
%    Uses A* to find best path back to start
% On input:
%     percept (1x5 Boolean vector): percept values
%      (1): Stench
%      (2): Breeze
%      (3): Glitters
%      (4): Bumped
%      (5): Screamed
% On output:
%     action (int): action selected by agent
%       FORWARD = 1;
%       ROTATE_RIGHT = 2;
%       ROTATE_LEFT = 3;
%       GRAB = 4;
%       SHOOT = 5;
%       CLIMB = 6;
% Call:
%     a = CS4300_agent_Astar([0,0,0,0,0]);
% Author:
%     T. Henderson
%     UU
%     Fall 2017
%

persistent board x y dir gold action_taken escape

FORWARD = 1;
ROTATE_RIGHT = 2;
ROTATE_LEFT = 3;
GRAB = 4;
SHOOT = 5;
CLIMB = 6;

if isempty(board)
    board = -ones(4,4);
    board(4,1) = 0;
    x = 1;
    y = 1;
    dir = 0;
    action_taken = 0;
    escape = [];
end

[x,y,dir] = CS4300_act(x,y,dir,action_taken);

if ~isempty(escape)   % pre-planned escape sequence of actions
    action = escape(1);
    escape = escape(2:end);
    action_taken = action;
    return
end

if percept(3)==1
    row = 4 - y + 1;
    col = x;
    board(row,col) = 0;
    [sol,nodes] = CS4300_Wumpus_A_star(board,[x,y,dir],[1,1,0],...
        'CS4300_A_star_Man');
    sol = [x,y,dir,GRAB;sol(2:end,:);1,1,1,CLIMB];
    escape = sol(:,end);
    action = escape(1);
    escape = escape(2:end);
    action_taken = action;
    return
end

action = randi(3);
action_taken = action;