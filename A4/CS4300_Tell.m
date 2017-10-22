function KB_out = CS4300_Tell(KB,sentence)
% CS4300_Tell - Tell function for logic KB
% On input:
% KB (KB struct): Knowledge base (CNF)
% (k).clauses (1xp vector): disjunction clause
% sentence (KB struct): query theorem (CNF)
% (k).clauses (1xq vector): disjunction
% On output:
% KB_out (KB struct): revised KB
% Call:
% KB = CS4300_Tell([],[1]);
% Author:
% <Your name>
% UU
% Fall 2017
%
len = length(KB);
for vector = sentence
    clause = vector.clauses;
   
    if clause == -81
        %clear all relation about wumpus.
        for i = len:-1:1
           KBCur = KB(i).clause;
           if length(KBCur) == 1 && abs(KBCur)>= 49
               KB(i)= [];
           end
        end 
        for i = 1:16
            KB(end+1).clauses= -(64+i);
        end
    else
        KB(end+1).clauses= vector;
    end
end
KB_out = KB;
end