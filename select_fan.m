%-------------------- FUNÇÃO DE SELEÇÃO -----------------------------------
function [rep_indx,del_indx,rand_indx] = select_fan(fitness)
    %seleciona os 5 melhores indivíduos para reproduzir entre si e com
    %outras soluções aleatórias
    %seleciona os 30 piores indivíduos para serem trocados
    [~,maxIndx] = sort(fitness,'descend');
    [~,minIndx] = sort(fitness);
    rep_indx = maxIndx(1:5);
    del_indx = minIndx(1:25);
    rand_indx = randperm(length(fitness),5);

end %end of select_fan
%--------------------------------------------------------------------------