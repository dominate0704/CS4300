function D_revised = CS4300_AC3(G,D,P)
% CS4300_AC3 - AC3 function from Mackworth paper 1977
% On input:
% G (nxn array): neighborhood graph for n nodes
% D (nxm array): m domain values for each of n nodes
% P (string): predicate function name; P(i,a,j,b) takes as
% arguments:
% i (int): start node index
% a (int): start node domain value
% j (int): end node index
% b (int): end node domain value
% On output:
% D_revised (nxm array): revised domain labels
% Call:
% G = 1 - eye(3,3);
% D = [1,1,1;1,1,1;1,1,1];
% Dr = CS4300_AC3(G,D,¡¯CS4300_P_no_attack¡¯);
% Author:
% Yucheng Yang
% UU
% Fall 2017
%
workList = [];
[n,~] = size(G);
for i = 1:n
    for j = 1:n
        if G(i,j)
            workList = [workList;i,j];
        end
    end
end
%disp(workList);

while 1
    reduced = 0;
    A = workList(1,1:2);
    p = A(1);
    q = A(2);
    workList(1,:) = [];
    for i = find(D(p,:))
        domain2 = find(D(q,:));
        for j = domain2
            if feval(P,p,i,q,j)
                break;
            end
            if j == domain2(end)
                reduced = 1;
                D(p,i) = 0;   
            end
        end
    end
    
    if reduced
        for relative = 1:n
            if G(p,relative) && relative ~= q
                workList = [workList; relative, p];
            end
        end
    end
    %disp(workList);
    
    if isempty(workList)
        break;
    end
    D_revised = D;

end
end
