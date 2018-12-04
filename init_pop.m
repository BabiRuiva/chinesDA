%-------------------- FUNÇÃO DE INICIALIZAÇÃO -----------------------------
function [population] = init_pop(size_pop)
%a população representa as decisões a serem tomadas com o 'draw'

%vetor que facilita na criação da população inicial aleatória:
aux_vec = [1 1 1 1 1 2 2 2 2 2 3 3 3 0];
population = zeros(size_pop,14);
%criação da população aleatória
for i=1:size_pop
    population(i,:) = aux_vec(randperm(length(aux_vec)) );
end

end %end of init_pop
%--------------------------------------------------------------------------