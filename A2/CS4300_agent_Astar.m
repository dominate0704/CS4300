function action = CS4300_agent_Astar(percept)
% CS4300_agent_Astar - A* search agent example
% Uses A* to find best path back to start
% On input:
% percept (1x5 Boolean vector): percept values
% (1): Stench
% (2): Breeze
% (3): Glitters
% (4): Bumped
% (5): Screamed
% On output:
% action (int): action selected by agent
% FORWARD = 1;
% ROTATE_RIGHT = 2;
% ROTATE_LEFT = 3;
% GRAB = 4;
% SHOOT = 5;
% CLIMB = 6;
% Call:
% a = CS4300_agent_Astar([0,0,0,0,0]);
% Author:
% Yucheng Yang
% UU
% Fall 2017
%
persistent available_Board;
persistent get_Gold;
persistent start_state;
persistent end_state;
persistent steps;
if isempty(available_Board)
    available_Board = [1,1,1,1;1,1,1,1;1,1,1,1;1,1,1,1];
end
if isempty(get_Gold)
    get_Gold = 0;
end
if isempty(start_state)
    start_state = [1,1,0];
    available_Board(4,1) = 0;
end
if isempty(end_state)
    end_state = start_state;
end
if isempty(steps)
    steps = [];
end
if  get_Gold 
      if isempty(steps)
          action = 6;
          return
      end
      action = steps(1);
      start_state = CS4300_Wumpus_transition(start_state,action,[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0]);
      steps = steps(2:end);
else 
    if percept(3) == 1 && isempty(steps)
        get_Gold = 1;
        [so,~] = CS4300_Wumpus_A_star(available_Board, start_state,end_state,'CS4300_heuristic');
         steps = so(:,4);
         steps(1) = [];
         action = 4;
         return
    else
        action = randi([1,3],1,1);
        start_state = CS4300_Wumpus_transition(start_state,action,[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0]);
        x = start_state(1);
        if x ~= -1
            available_Board(5-start_state(2),x) = 0;
        end   
    end
end
end