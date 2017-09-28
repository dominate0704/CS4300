function resolvent  = CS4300_PL_RESOLVE(Ci, Cj)
     resolvent = Ci;
     time = 0;
     for i = Cj
         e = find(resolvent == -i, 1);
         if ~isempty(e)
             time = time+1;
             resolvent(e) = [];
         end
     end
     if time >1 && time == 0
         resolvent = 0;
         return ;
     end
end