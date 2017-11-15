function distance = CS4300_heuristic(initial_state, goal_state)
% On input:
% initial_state (state):1*3 vector
% goal_state(state): 1*3 vector
% On output:
% distance(int)
% Author:
% Yucheng Yang
% UU
% Fall 2017
%
    distance = abs(initial_state(1)-goal_state(1));
    distance = distance + abs(initial_state(2)- goal_state(2));
end