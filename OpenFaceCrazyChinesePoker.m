

num_players = 2; %o algoritmo não será feito para um jogo de 3 pessoas
Cards = {'2','3','4','5','6','7','8','9','10','J','Q','K','A'};
Suits = {'S','C','D','H'};   %espadas paus ouros e copas '?','?','?','?'
Baralho = length(Cards) * length(Suits);
Hands = {'Royal Flush';
         'Straight Flush';
         'Quadra';
         'Full House';
         'Flush';
         'Sequência';
         'Trinca';
         'Dois Pares';
         'Um Par';
         'High Card';
         };
Player = {'Humano','Algoritmo'};
%distriuição de cartas para cada jogada i
CardsDeal = [5 3 3 3 3];     
%numero de cartas totais em cada linha
NumTop = 3;
NumMid = 5;
NumBot = 5;
%hand = [39 13 52];
flipcoin = rand<0.5;
order = [flipcoin ~flipcoin];
fantasy = [0 0];
num_rod = 1;
rodadas = input('Quantas rodadas deseja jogar? ');
divida = zeros(1,rodadas);
while ((num_rod<= rodadas) || (sum(fantasy)>0))
    hllo = ['Rodada ',num2str(num_rod)];
    disp(hllo);
    Deck = randperm(Baralho);
        if sum(fantasy)==0
            order = ~order;
        end
        play_order = 2.^order;
        txt = ['Primeiro player:',Player{play_order(1)}];
        disp(txt);
        bordo{1} = zeros(1,3);bordo{2} = zeros(1,3);bordo{3} = zeros(1,3);
        bordo{1}(bordo{1}==0)=[];bordo{2}(bordo{2}==0)=[];bordo{3}(bordo{3}==0)=[];
        pp=zeros(1,3);bb=zeros(1,5);tt=zeros(1,5);
        pp(pp==0)=[];bb(bb==0)=[];tt(tt==0)=[];
    for i=1:5

        for j=1:2
            if(play_order(j) == 1)
                if(~fantasy(1) || i==1 )
                    if(fantasy(1))
                        draw = Deck(1:14);
                        Deck(1:14) = [];
                    else
                        draw = Deck(1:CardsDeal(i));
                        Deck(1:CardsDeal(i)) = [];
                    end
                    
                    SV = ceil(draw./13);
                    CV = draw-(SV-1)*13; 
                    draw_show = strcat(Cards(CV),Suits(SV));
                    disp('---------------------------------------------');
                    disp('DRAW:');
                    if(fantasy(1))
                        [~,map] = ismember(sort(draw_show),draw_show);
                        indice = map.';
                        Fantasy = sort(draw_show).';
                        tabu = table(Fantasy,indice);
                        disp(tabu);
                    else
                        disp(draw_show);
                    end
                    disp('---------------------------------------------');
                    d_num = 0;
                    while (d_num ~=1)
                        prompt = {'Cabeça','Meio','Base'};
                        title = 'Bordo';
                        dims = [1 35];
                        answer = inputdlg(prompt,title,dims);
                        d_num = numel(str2num(answer{1}))+numel(str2num(answer{2}))+numel(str2num(answer{3}));
                        cabec_size = numel(bordo{3}); meio_size = numel(bordo{2});base_size = numel(bordo{1});
                        error = (base_size==NumBot && ~isempty(answer{3})) || (meio_size==NumMid && ~isempty(answer{2}))|| ...
                            (cabec_size==NumTop && ~isempty(answer{1}));

                        if(error == 1)
                            disp('Linha já completa');
                            d_num = 0;
                        elseif(i==1 || d_num == 2)
                            break;
                        else
                            disp('Descarte UMA carta');
                        end
                    end

                    %Imprime o bordo do player
                    aux1 = numel(str2num(answer{1}));aux2 = numel(str2num(answer{2}));aux3 = numel(str2num(answer{3}));
                    bordo{3}(cabec_size+1:cabec_size+aux1) = draw(str2num(answer{1}));
                    bordo{2}(meio_size+1:meio_size+aux2) = draw(str2num(answer{2}));
                    bordo{1}(base_size+1:base_size+aux3) = draw(str2num(answer{3}));
                    base_show = strcat(Cards(bordo{1}-((ceil(bordo{1}./13) )-1)*13),Suits(ceil(bordo{1}./13) ) );
                    mid_show = strcat(Cards(bordo{2}-((ceil(bordo{2}./13) )-1)*13),Suits(ceil(bordo{2}./13) ) );
                    top_show = strcat(Cards(bordo{3}-((ceil(bordo{3}./13) )-1)*13),Suits(ceil(bordo{3}./13) ) );
                    disp('BORDO:');
                    disp('Cabeça:');
                    disp(top_show);
                    disp('Meio:');
                    disp(mid_show);
                    disp('Base:');
                    disp(base_show);
                end
            else
            %vez do segundo jogador
                if(~fantasy(2) || i==1 )
                    if(fantasy(2))
                        draw2 = Deck(1:14);
                        Deck(1:14) = [];
                    else
                        draw2 = Deck(1:CardsDeal(i));
                        Deck(1:CardsDeal(i)) = [];
                    end
                        if i>1
                            draw2(randi(3)) = [];
                        end
                        for k=1:length(draw2)
                            turn = 1;
                            while turn
                            sizep = numel(pp);sizeb = numel(bb);sizet = numel(tt);
                            r = rand;
                                if(r<0.6 && sizep<3)
                                    pp(sizep+1) = draw2(k);
                                    turn=0;
                                elseif(r>0.9 && sizet<5)
                                    tt(sizet+1) = draw2(k);
                                    turn=0;
                                elseif(0.6<=r && r<= 0.9 && sizeb<5)
                                    bb(sizeb+1) = draw2(k);
                                    turn = 0;
                                else
                                end
                            end
                        end       
                    %Imprime o P2 do player
                    base_show2 = strcat(Cards(tt-((ceil(tt./13) )-1)*13),Suits(ceil(tt./13) ) );
                    mid_show2 = strcat(Cards(bb-((ceil(bb./13) )-1)*13),Suits(ceil(bb./13) ) );
                    top_show2 = strcat(Cards(pp-((ceil(pp./13) )-1)*13),Suits(ceil(pp./13) ) );
                    disp('BORDO    2:');
                    disp('Cabeça:');
                    disp(top_show2);
                    disp('Meio:');
                    disp(mid_show2);
                    disp('Base:');
                    disp(base_show2);
                end
            end

        end
        p2{1} = tt;p2{2} = bb; p2{3}= pp;
    end


    for i=fliplr(1:3)
    [CardsValue{i},SuitsValue{i},HandIndx(i),HC1(i)] = HandCheck(bordo{i},Cards,Suits);
    disp(Hands(HandIndx(i)));
    end
    disp('-----------');

    for i=fliplr(1:3)
    [CardsValue2{i},SuitsValue2{i},HandIndx2(i),HC2(i)] = HandCheck(p2{i},Cards,Suits);
    disp(Hands(HandIndx2(i)));
    %disp(Hands(HandIndx(i)));
    end

    [Total, fantasia] = PontuaMao(HandIndx,HandIndx2,HC1,HC2,CardsValue,CardsValue2,fantasy);
    fantasy = fantasia;
    zzz = ['Pontos Totais: ', num2str(Total)];
    disp(zzz);
    if(num_rod>1)
        divida(num_rod) = divida(num_rod-1)+ Total;
    else
       divida(num_rod) = Total; 
    end
             input('Press enter to continue...');
num_rod = num_rod +1;
end
disp(divida);

%{
figure('Color','green')
rectangle('position',[0 0 1.1 2],'curvature',[.1 .1],'facecolor','w');
rectangle('position',[1 1 2.2 4],'curvature',[.1 .1],'facecolor','w');
text(.25,1,'AC','fontname','courier','backgroundcolor','none',...
    'color','r','fontweight','bold','hittest','off');
axis off
%}
