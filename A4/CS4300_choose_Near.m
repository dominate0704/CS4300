function loc = CS4300_choose_Near(safe,visited,mod,x,y)
% CS4300_choose_Near - choose a nearest place to go
% On input:
%     safe (4x4 array): 1 if safe, else 0
%     visited (4x4 array): 1 if visited, else 0
%     mod(boolean): 1: safe mod, 0 uncertain mod.
% On output:
%     loc (1x2 vector): [x y] location
% Call:
%     loc = CS4300_choose1(safe,visited);
% Author:
%     T. Henderson
%     UU
%     Fall 2015
%

loc = [];
if mod
    [rows,cols] = find(safe==1 & visited==0);
else
    [rows,cols] = find(safe==0 & visited==0);
end


if ~isempty(rows)
    loc = [cols(1),4-rows(1)+1,0];
    dis = CS4300_A_star_Man(loc,[x,y]);
    for i = 2:length(rows(:,1))
        cur = [cols(i),4-rows(i)+1,0];
        curDis = CS4300_A_star_Man(cur,[x,y,0]);
        if dis > curDis
            dis =curDis;
            loc = [cur(1),cur(2)];
        end
    end
end