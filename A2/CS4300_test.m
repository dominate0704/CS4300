clear CS4300_agent_Astar_AC;

board1 = [1,1,1,1;0,0,0,2;0,0,0,0;0,0,0,0];
board2 = [1,1,1,1;0,1,0,2;0,1,0,0;0,0,0,0];
board3 = [1,1,1,1;1,1,1,2;0,0,0,0;0,1,0,1];
t = CS4300_WW1(2000,'CS4300_agent_Astar_AC',board3);
M = CS4300_show_trace(t,0.0001);

% c= zeros(16,16);
% for i = 1:16
%     if mod(i,4) >0;
%         c(i,i+1) = 1;
%     end     
%     if mod(i,4) ~=1
%         c(i,i-1) = 1;
%     end
%     if i<13
%         c(i,i+4) = 1;
%     end
%     if i>4
%         c(i,i-4) = 1;
%     end
% end
% disp(c);