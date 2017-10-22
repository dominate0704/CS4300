function [KB,KBi,vars] = CS4300_gen_KB
% BR_gen_KB - generate Wumpus World logic in KB
% On input:
% N/A
% On output:
% KB (CNF KB): KB with Wumpus logic (atom symbols)
% (k).clauses (string): string form of disjunction
% KBi (CNF KB): KB with Wumpus logic (integers)
% (k).clauses (1xp vector): integer form of disjunction
% vars(struct: vector of strings): list of atom strings
% (k).var (string): name of atom
% Call:
% [KB,KBi,vars] = CS4300_gen_KB;
% Author:
% <Your name>
% UU
% Fall 2017
%
% Pit: 1-16
% Glitter: 17-32
% Breeze: 33-48
% Stench: 49-64
% Wempus 65-80

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

KB = [];
KBi = [];
vars = [];
for i  = 1: 16
    x = mod(i-1,4)+1;
    y = floor((i-1)/4)+1;
    vars(i).var = "P"+ x+y;
    vars(i+16*1).var = "G"+ x+y;
    vars(i+16*2).var = "B"+ x+y;
    vars(i+16*3).var = "S"+ x+y;
    vars(i+16*4).var = "W"+ x+y;
end

for i = 1: 16
   
    list = find(G(i,:));   % the next grids of this grid.
     % the next of B must have at least one P.
    baseBi = i+16*2;
    baseB = vars(i+16*2).var;
    vectorB = -baseBi;
    stringB = "-"+baseB;
     % the next of S must have at least one W.
    baseSi = i+16*3;
    baseS = vars(i+16*3).var;
    vectorS = -baseSi;
    stringS = "-"+baseS;
    
    for j = list
        stringB = stringB + " " + vars(j).var;
        KB(end+1).clauses = baseB + "-"+ vars(j).var;
        stringS = stringS + " " + vars(j+16*4).var;
        KB(end+1).clauses = baseS + "-"+ vars(j+16*4).var;
        
        vectorB(end+1) =  j;
        KBi(end+1).clauses = [baseBi -j];
        vectorS(end+1) = j+16*4;
        KBi(end+1).clauses = [baseSi -(j+16*4)];
    end
    KB(end+1).clauses = stringB;
    KB(end+1).clauses = stringS;
    KBi(end+1).clauses = vectorB;
    KBi(end+1).clauses = vectorS;
    
    
    
    if i < 16
        
        % only one W.
        baseWi = i+16*4;
        baseW = vars(i+16*4).var;
        vectorW = baseWi;
        stringW = baseW;
        
        % only one G.
        baseGi = i+16;
        baseG = vars(i+16).var;
        vectorG = baseGi;
        stringG = baseG;
        
        
        
        for j = (i+1):16
            
            stringW = stringW + " "+ vars(j+16*4).var;
            KB(end+1).clauses = "-"+baseW + " -" +vars(j+16*4).var;
            vectorW(end+1) = j+16*4;
            KBi(end+1).clauses = [-baseWi -(j+16*4)];
            
            
            stringG = stringG + " "+ vars(j+16).var;
            KB(end+1).clauses = "-"+baseG + " -" +vars(j+16).var;
            vectorG(end+1) = j+16;
            KBi(end+1).clauses = [-baseGi -(j+16)];
        end
        
        if i == 1
            KB(end+1).clauses = stringW;
            KBi(end+1).clauses = vectorW;
        
            KB(end+1).clauses = stringG;
            KBi(end+1).clauses = vectorG;
        end
    end
    
    % if there is a P , then there will  be neither a W or a G. 
    KB(end+1).clauses = "-"+ vars(i).var+" -"+ vars(i+16*4).var;
    KBi(end+1).clauses = [-i -(i+16*4)];
        
    KB(end+1).clauses = "-"+ vars(i).var+" -"+ vars(i+16).var;
    KBi(end+1).clauses = [-i -(i+16)];
    
    
end

