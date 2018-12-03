%-------------------- FUNÇÃO DE MUTAÇÃO -----------------------------------
function [change] = mutate_fan(hand)
%realiza um "bit flip" em apenas 2 posições de 'hand'
prob = 0.05;
n = rand;
tam = length(hand);
change = hand;
if(n<prob)
    flip = randperm(tam,2);
    change(flip(1)) = change(flip(2));
    change(flip(2)) = hand(flip(1));
end

end %end of mutate
%--------------------------------------------------------------------------