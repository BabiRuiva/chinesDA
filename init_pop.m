%-------------------- FUN��O DE INICIALIZA��O -----------------------------
function [population] = init_pop(size_pop)
%a popula��o representa as decis�es a serem tomadas com o 'draw'

%vetor que facilita na cria��o da popula��o inicial aleat�ria:
aux_vec = [1 1 1 1 1 2 2 2 2 2 3 3 3 0];
population = zeros(size_pop,14);
%cria��o da popula��o aleat�ria
for i=1:size_pop
    population(i,:) = aux_vec(randperm(length(aux_vec)) );
end

end %end of init_pop
%--------------------------------------------------------------------------