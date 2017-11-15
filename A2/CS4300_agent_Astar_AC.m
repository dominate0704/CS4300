function action = CS4300_agent_Astar_AC(percept)
% CS4300_agent_Astar_AC - A* search agent with AC
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
persistent G;
persistent D;
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
if isempty(G)
    G= zeros(16,16);
    for i = 1:16
        if mod(i,4) >0
            G(i,i+1) = 1;
        end     
        if mod(i,4) ~=1
            G(i,i-1) = 1;
        end
        if i<13
            G(i,i+4) = 1;
        end
        if i>4
            G(i,i-4) = 1;
        end
    end
end
if isempty(D)
    D = ones(16,3);
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
        x = start_state(1);
        if x ~= -1
            available_Board(5-start_state(2),x) = 0;
        end  
        get_Gold = 1;
        [so,~] = CS4300_Wumpus_A_star(available_Board, start_state,end_state,'CS4300_heuristic');
         steps = so(:,4);
         steps(1) = [];
         action = 4;
         return
    else
         if ~isempty(steps)
            action = steps(1);
            start_state = CS4300_Wumpus_transition(start_state,action,[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0]);
             x = start_state(1);
            if x ~= -1
                available_Board(5-start_state(2),x) = 0;
            end  
            steps(1) = [];
            return
         else
            x = start_state(1);
            y = start_state(2);
            index = x+4*y-4;
            perfer = 0;
            if percept(2) ~= 1
                D(index,3) =0;
                D(index,2) =0;
            end
            if percept(2) ==1
                perfer =1;
                D(index,1) = 0;
                D(index,2) = 0 ;
            end
            D = CS4300_AC3(G,D,'CS4300_P');
            domain1 =[];
            if perfer
                domain1 = find(~G(index,:));
                domain2 = find(G(index,:));
            end
            if isempty(domain1)
                domain = 1:16;
                for i = 1:16
                    choose = randi(17-i);
                    domain(choose) = [];
                    if D(choose,2) ==0 || D(choose,3) ==0
                        x1 = mod(choose,4);
                        y1 = 5-floor((choose-1)/4+1);
                        if x1 == 0
                            x1 = 4;
                        end
                        if available_Board(y1,x1)
                            available_Board(y1,x1) =0;
                            [so,~] = CS4300_Wumpus_A_star(available_Board, start_state,[x1,5-y1,0],'CS4300_heuristic');
                            available_Board(y1,x1) =1;
                            if ~isempty(so)
                                 so(1,:) =[];
                                steps = so(:,4);
                                break;
                            end
                        end
                    end
                end
            else
                domainTrack = domain1;
                len = length(domain1);
                for i  = 1:len
                    choose = randi(len+1-i);
                    index = domainTrack(choose);
                    domainTrack(choose) = []; 
                    if D(index,2) ==0 || D(index,3) ==0
                        x1 = mod(index,4);
                        y1 = 5-floor((index-1)/4+1);
                        if x1 == 0
                            x1 = 4;
                        end
                        if available_Board(y1,x1)
                            available_Board(y1,x1) =0;
                            [so,~] = CS4300_Wumpus_A_star(available_Board, start_state,[x1,5-y1,0],'CS4300_heuristic');
                            available_Board(y1,x1) =1;
                            if ~isempty(so)
                                 so(1,:) =[];
                                steps = so(:,4);
                                break;
                            end
                        end
                    end
                end
                if isempty(steps)
                    domainTrack = domain2;
                    len = length(domain2);
                    for i = 1:len
                        choose = randi(len+1-i);
                        index = domainTrack(choose);
                        domainTrack(choose) = [];
                        if D(index,2) ==0 || D(index,3) ==0
                            x1 = mod(index,4);
                            y1 = 5-floor((index-1)/4+1);
                            if x1 == 0
                                x1 = 4;
                            end
                            if available_Board(y1,x1)
                                available_Board(y1,x1) =0;
                                [so,~] = CS4300_Wumpus_A_star(available_Board, start_state,[x1,5-y1,0],'CS4300_heuristic');
                                available_Board(y1,x1) =1;
                                if ~isempty(so)
                                     so(1,:) =[];
                                    steps = so(:,4);
                                break;
                                end
                            end
                        end
                    end 
                end
            end
         end 
        if ~isempty(steps)
            action = steps(1);
            steps(1) = [];
        else
            action = randi([1,3],1,1);
        end
        start_state = CS4300_Wumpus_transition(start_state,action,[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0]);

        x = start_state(1);
        if x ~= -1
            available_Board(5-start_state(2),x) = 0;
        end     
    end
end
