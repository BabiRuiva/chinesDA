%-------------------- FUNÇÃO DE REPRODUÇÃO --------------------------------
function [new_pop] = reproduce(population,rep_indx,del_indx,rand_indx)
size = length(rep_indx);
ind_aux =1;
ind_rand =1;
new_pop = population;
for i=1:(size-1)
   for j=(i+1):size
       prob = rand;
       if((prob>0.6)&&(prob<0.9))
           offspring = CutAndCrossfill_Crossover([population(rep_indx(i),:);population(rep_indx(j),:)]);
           aux = zeros(2,3);
           for k=1:3
              aux(1,k) = sum(ismember(offspring(1,:),k));
              aux(2,k) = sum(ismember(offspring(2,:),k));
           end
           %se a solução implica em um número maior ou menor de cartas em uma
           %linha, trocá-la pelo pai
           if( (aux(1,1)~=5)||(aux(1,2)~=5)||(aux(1,3)~=3) )
               offspring(1,:) = population(rep_indx(i),:);
           end
           if( (aux(2,1)~=5)||(aux(2,2)~=5)||(aux(2,3)~=3) )
               offspring(2,:) = population(rep_indx(j),:);
           end
           new_pop(del_indx(ind_aux),:) = mutate_fan(offspring(1,:));
           new_pop(del_indx(ind_aux+1),:) = mutate_fan(offspring(2,:));
       end
       ind_aux = ind_aux +2;
   end
   %reproduz os melhores com os aleatorios
   offspring = CutAndCrossfill_Crossover([population(rep_indx(i),:);population(rand_indx(ind_rand),:)]);
    for k=1:3
        aux(1,k) = sum(ismember(offspring(1,:),k));
        aux(2,k) = sum(ismember(offspring(2,:),k));
    end
    if( (aux(1,1)~=5)||(aux(1,2)~=5)||(aux(1,3)~=3) )
        offspring(1,:) = population(rep_indx(i),:);
    elseif( (aux(2,1)==5)&&(aux(2,2)==5)&&(aux(2,3)==3) )
        offspring(1,:) = offspring(2,:);
    end
    new_pop(del_indx(ind_aux),:) = mutate_fan(offspring(1,:));
    
    ind_rand = ind_rand+1;
    ind_aux = ind_aux +1;
end

%reproduz o indivíduo faltante
    offspring = CutAndCrossfill_Crossover([population(rep_indx(i+1),:);population(rand_indx(ind_rand),:)]);
    for k=1:3
        aux(1,k) = sum(ismember(offspring(1,:),k));
        aux(2,k) = sum(ismember(offspring(2,:),k));
    end
    if( (aux(1,1)~=5)||(aux(1,2)~=5)||(aux(1,3)~=3) )
        offspring(1,:) = population(rep_indx(i+1),:);
    elseif( (aux(2,1)==5)&&(aux(2,2)==5)&&(aux(2,3)==3) )
        offspring(1,:) = offspring(2,:);
    end
    new_pop(del_indx(ind_aux),:) = mutate_fan(offspring(1,:));
    
end %end of reproduce
%--------------------------------------------------------------------------