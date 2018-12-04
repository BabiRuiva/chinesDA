%função que maximiza os pontos da fantasy island
%function [bordo] = GA_fantasy(draw,Cards,Suits)
%sendo 'draw' um vetor de 14 posições
clear;clc;
Cards = {'2','3','4','5','6','7','8','9','10','J','Q','K','A'};
Suits = {'S','C','D','H'}; 
draw = [13 12 11 10 9 26 25 24 23 22 8 21 34 1];
for i=1:100
max_gen = 500;
size_pop = 200;
fit_mean = zeros(1,max_gen);fit_best = zeros(1,max_gen);
population = init_pop(size_pop);
gen = 1;
tt = 1;
while tt ~=104
%for gen=1:max_gen
    %disp(gen);
   fit = fit_fan(population,draw,Cards,Suits);
   [rep_indx,del_indx,rand_indx] = select_fan(fit);
   population = reproduce(population,rep_indx,del_indx,rand_indx);
   fit_mean(gen) = mean(fit);
   fit_best(gen) = max(fit);
   tt = max(fit);
   gen = gen+1;
  % plot(fit_mean,gen);
end
%{
figure(1)
    h1 = scatter(0:gen-1,fit_mean,[],'b','filled','o');
    hold on
    h2 = scatter(0:gen-1,fit_best,[],'m','filled','p');
    title('Fitness de cada geração')
    legend('Fitness Média','Melhor Fitness')
    xlabel('Geração')
    ylabel('Fitness')
%}
%%{
test(i) = gen;
disp(i);
    figure(3)
    h1 = plot(i,test(i));
    set(h1,'Xdata',1:i,'Ydata',test(1:i));
    xlabel('Iteração');
    ylabel('Gerações para convergir');
    pause(0.1);
end
%%}
%end %end of  GA_fantasy
%--------------------------------------------------------------------------



