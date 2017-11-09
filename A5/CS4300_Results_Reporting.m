clear all;
load('A5_boards.mat');
% No_MC = [0,0,0];
% MC_50 = [0,0,0];
MC_100 = zeros(2,250);
% MC_200 = [0,0,0];
for i = 1:250
%     clear('CS4300_MC_agent');
%     [s,t] = CS4300_WW1(1000,'CS4300_MC_agent',boards(i).board);
%     MC_200(1)= MC_250(1)+s;
%     if t(end).action == 6
%         MC_200(2)=MC_200(2)+1;
%     else
%         MC_200(3)=MC_200(3)+1;
%     end

    clear('CS4300_MC_agent');
    [s,t] = CS4300_WW1(1000,'CS4300_MC_agent',boards(i).board);
    MC_100(1,i)= s;
    if t(end).action == 6
        MC_100(2,1)=MC_100(2,1)+1;
    else
        MC_100(2,2)=MC_100(2,2)+1;
    end

%     clear('CS4300_MC_agent');
%     [s,t] = CS4300_WW1(50,'CS4300_MC_agent',boards(i).board);
%     MC_50(1)= MC_50(1)+s;
%     if t(end).action == 6
%         MC_50(2)=MC_50(2)+1;
%     else
%         MC_50(3)=MC_50(3)+1;
%     end
%     clear('CS4300_agent_Astar');
%     [s,t] = CS4300_WW1(50,'CS4300_agent_Astar',boards(i).board);
%     MC_100(1,i)= s;
%     if t(end).action == 6
%         MC_100(2,1)=MC_100(2,1)+1;
%     else
%         MC_100(2,2)=MC_100(2,2)+1;
%     end
end
% MC_200(1) = MC_200(1)/250;
 var_100 =  var(MC_100(1,1:end));
 x = MC_100(1,1:end);
 SEM = std(x)/sqrt(length(x));               
ts = tinv([0.025  0.975],length(x)-1);      
CI = mean(x) + ts*SEM;                     
 mean = mean(MC_100(1,1:end));
% MC_50(1) = MC_50(1)/250;
% No_MC(1) = No_MC(1)/250;