function Sip = CS4300_RTP(sentences,thm,vars)
% CS4300_RTP - resolution theorem prover
% On input:
% sentences (CNF data structure): array of conjuctive clauses
% (i).clauses
% each clause is a list of integers (- for negated literal)
% thm (CNF datastructure): a disjunctive clause to be tested
% vars (1xn vector): list of variables (positive integers)
% On output:
% Sip (CNF data structure): results of resolution
% []: proved sentence |- thm
% not []: thm does not follow from sentences
% Call: (example from Russell & Norvig, p. 252)
% DP(1).clauses = [-1,2,3,4];
% DP(2).clauses = [-2];
% DP(3).clauses = [-3];
% DP(4).clauses = [1];
% thm(1).clauses = [4];
% vars = [1,2,3,4];
% Sr = CS4300_RTP(DP,thm,vars);
% Author:
% <Your name>
% UU
% Fall 2017
%
CNF = sentences;
vector = thm(1).clauses;
for i = 1:length(vector)
    CNF(end+1).clauses = -vector(i);
end
Sip = [0 0];
newSpace = [];
resolvents = [];
gate = 0;

while gate == 0
    if isempty(newSpace)
        len = length(CNF);
        for  i = 1: len
            if i < len 
                for j = (i+1):length(CNF)
                     current= CS4300_PL_RESOLVE(CNF(i).clauses,CNF(j).clauses);
                     if current ~= 0
                         if isempty(current)
                             Sip =[];
                             return 
                         else
                             resolvents(end+1).clauses = current;
                         end
                     end
                end
            end
        end
        
        
    else
        
        
        
        
    end
    
    
    
    
    
    
end

end