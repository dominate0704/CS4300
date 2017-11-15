function boolean= CS4300_P(i,a,j,b)
% On input:
% i (int): start node index
% a (int): start node domain value
% j (int): end node index
% b (int): end node domain value
% On output:
% boolean : 1 or 2
% Author:
% Yucheng Yang
% UU
% Fall 2017
%
    boolean = 1;
    if a == 1 && b == 2
        boolean = 0;
    end
    if a == 2 && b ~= 3
        boolean = 0;
    end
end