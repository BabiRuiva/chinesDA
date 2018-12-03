%-------------------- FUNÇÃO DE FITNESS -----------------------------------
function [fitness] = fit_fan(population,draw)

Cards = {'2','3','4','5','6','7','8','9','10','J','Q','K','A'};
Suits = {'S','C','D','H'};   %espadas paus ouros e copas '?','?','?','?'
     
     
indx_aux = 1:14;
size_pop = length(population(:,1));
fitness = zeros(1,size_pop);
fantasy = [1 0];

%cria um bordo 2 para scoop
CardsValue2{1} = [14 18 24 38 5];CardsValue2{2} = [1 2 3 4 5];CardsValue2{3} = [13 26 39];
HandIndx2(1:3) = [10 2 7];HC2(1:3) = [1 5 13];

for i = 1:size_pop
    %formulação do bordo a partir da população
    [~,loc_base] = ismember(population(i,:),1); loc_base = indx_aux.*loc_base;
    loc_base(loc_base==0) = [];
    bordo{1} = draw(loc_base);
    [~,loc_meio] = ismember(population(i,:),2); loc_meio = indx_aux.*loc_meio;
    loc_meio(loc_meio==0) = [];
    bordo{2} = draw(loc_meio);
    [~,loc_cabec] = ismember(population(i,:),3); loc_cabec = indx_aux.*loc_cabec;
    loc_cabec(loc_cabec==0) = [];
    bordo{3} = draw(loc_cabec);
    for j=fliplr(1:3)
        [CardsValue{j},SuitsValue{j},HandIndx(j),HC1(j)] = HandCheck(bordo{j},Cards,Suits);
    end
    [Total, fantasia] = PontuaMao(HandIndx,HandIndx2,HC1,HC2,CardsValue,CardsValue2,fantasy);
    if((Total - 6) < 0)
       Total = 6; 
    end
    fitness(i) = (fantasia(1)*5)+(Total -6);
end

end %end of fit_fan
%--------------------------------------------------------------------------