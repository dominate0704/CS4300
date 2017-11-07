function [pits,Wumpus] = CS4300_WP_estimates(breezes,stench,num_trials)
% CS4300_WP_estimates - estimate pit and Wumpus likelihoods
% On input:
% breezes (4x4 Boolean array): presence of breeze percept at cell
% -1: no knowledge
% 0: no breeze detected
% 1: breeze detected
% stench (4x4 Boolean array): presence of stench in cell
% -1: no knowledge
% 0: no stench detected
% 1: stench detected
% num_trials (int): number of trials to run (subset will be OK)
% On output:
% pits (4x4 [0,1] array): likelihood of pit in cell
% Wumpus (4x4 [0 to 1] array): likelihood of Wumpus in cell
% Call:
% breezes = -ones(4,4);
% breezes(4,1) = 1;
% stench = -ones(4,4);
% stench(4,1) = 0;
% [pts,Wumpus] = CS4300_WP_estimates(breezes,stench,10000)
% pts =
% 0.2021 0.1967 0.1956 0.1953
% 0.1972 0.1999 0.2016 0.1980
% 0.5527 0.1969 0.1989 0.2119
% 0 0.5552 0.1948 0.1839
%
% Wumpus =
% 0.0806 0.0800 0.0827 0.0720
% 0.0780 0.0738 0.0723 0.0717
% 0 0.0845 0.0685 0.0803
% 0 0 0.0741 0.0812
% Author:
% <Yucheng Yang>
% UU
% Fall 2017
%
 %initialize pit and wumpus prob arrays to 0
 board = zeors(4,4);
 pits = zeors(4,4);
 Wumpus = zeros(4,4);
 count = 0;
  for t = 1:num_trials
    satisfied = 0;
    t = 0;
    %b = get a board that satisfies the breeze and stench conditions
    while ~satisfied || t<100
        board = CS4300_gen_board(0.2);
        for i = 1:16
             col = mod(i-1,4)+1;
             row = 4 - fix((i-1)/4);
             agent.x = col;
             agent.y = 4-row+1;
             percept = CS4300_get_percept(board,agent,bumped,screamed);
             satisfied = 1;
             if percept(2)~= breezes(row,col) || percept(1) ~= stench(row,col)
                 satisfied = 0;
             end
        end
        t = t+1;
    end
    
    if satisfied
        %increment count
        count = count+1;
        %increment pit array based on b
        %increment wumpus array based on b
        for i = 1:16
            col = mod(i-1,4)+1;
            row = 4 - fix((i-1)/4);
            if board(row,col) == 1
                pits(row,col) = pits(row,col)+1;
            end
            if board(row,col) == 3 || board(row,col) == 4
                Wumpus(row,col) = Wumpus(row,col)+1;
            end
        end
    end  
  end
  %  normalize pit prob array using count
  % normalize wumpus prob array using count
  pits = pits/count;
  Wumpus = Wumpus/count;
 

end