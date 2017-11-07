function [row,col] = CS4300_frontier(visited)
%

row = [];
col = [];

for r = 1:4
    for c = 1:4
        if visited(r,c)==1
            nei = BR_Wumpus_neighbors(c,4-r+1);
            num_nei = length(nei(:,1));
            for n = 1:num_nei
                if visited(4-nei(n,2)+1,nei(n,1))==0
                    row(end+1) = 4 - nei(n,2) + 1;
                    col(end+1) = nei(n,1);
                end
            end
        end
    end
end
end