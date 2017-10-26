function Packet = CS4300_Packet_CNF(number)
%CS4300_Packet_CNF - make a CNF sentence
%On input:
% The index for this variable.
%On output:
% A packet contains simple CNF.
%Author:
% Yucheng Yang
%UU
% Fall 2017
%
Packet(1).clauses = number;
end