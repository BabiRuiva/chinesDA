%-------------------- FUNÇÃO DE MUTAÇÃO -----------------------------------
function [change] = mutate_fan(hand)
%realiza um "bit flip" em apenas todas as posições 'hand' de acordo com prob
prob = 0.3;
tam = length(hand);
change = hand;
flip = randperm(tam);
odds = 1:14;
odds(mod(odds,2)==0)=[];
for i=odds
    n = rand;
    if(n<prob)
        change(flip(i)) = change(flip(i+1));
        change(flip(i+1)) = hand(flip(i));
    end
end
end %end of mutate
%--------------------------------------------------------------------------
