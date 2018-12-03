function [Pontos,fantasy] = PontuaMao(HandIndx1,HandIndx2,HC1,HC2,CardsValue1,CardsValue2,padaria)
%Vetor que mostra a pontuação para cada mão de 5 cartas para a primeira
%linha
%[1]Royal[2]SF[3]Quadra[4]Full[5]Flush[6]Sequencia[7]Trinca[8]DoisPares[9]Par[10]HighCard
%A segunda linha tem os pontos como o dobro de PtVector, com a adição de
%uma pontuação para trinca => 2pontos
PtVector = [25 15 10 6 4 2 0 0 0 0];
bsop1 = 0;
bsop2 = 0;
fantasy = [0 0];
%------------------------------------------------------------------------
%Player1
%------------------------------------------------------------------------
%confere se a linha anterior é maior que a de cima
if (HandIndx1(1)>HandIndx1(2)) || (HandIndx1(2)>HandIndx1(3))
    pt1 = zeros(1,3);
    bsop1 = 1;
elseif (HandIndx1(1)<HandIndx1(2)) && (HandIndx1(2)<HandIndx1(3))
%calculo dos pontos do jogador1
    pt1 = [1 2].*PtVector(HandIndx1(1:2));
%caso haja uma trinca na segunda linha, são considerados 2 pontos
    if(HandIndx1(2) == 7)
        pt1(2) = 2;
    end
%Caso as mãos sejam "iguais"
%Para uma mão de 5 cartas, isso só ocorre se base=topo
else
    switch HandIndx1(2)
        case 1
            pt1 = [1 2].*PtVector(HandIndx1(1:2)); 
        case 2
            if(HC1(1)>=HC1(2))  % >= pois possibilidade de 2 straight flushes iguais, mas com naipes diferentes
              pt1 = [1 2].*PtVector(HandIndx1(1:2));
            else
              pt1 = zeros(1,3);
              bsop1 = 1;
            end
        case 3 
            if(HC1(1)>HC1(2))
              pt1 = [1 2].*PtVector(HandIndx1(1:2));
            else   %como é impossivel a ocorrencia de duas quadras iguais, ou HC1(1)é maior ou menor que HC1(2)
              pt1 = zeros(1,3);
              bsop1=1;
            end
        case 4
            if(HC1(1)>HC1(2)) %impossível 2 full houses iguais
              pt1 = [1 2].*PtVector(HandIndx1(1:2));
            else
              pt1 = zeros(1,3);
              bsop1=1;
            end
        case 5 
            if(HC1(1)>HC1(2)) 
              pt1 = [1 2].*PtVector(HandIndx1(1:2));
            elseif(HC1(1)<HC1(2))
              pt1 = zeros(1,3);
              bsop1=1;
            else % para que o flush seja considerado igual, todas as 5 cartas devem ser iguais
                test1 = sort(CardsValue1{1});
                test2 = sort(CardsValue1{2});
                f = find(test1==test2);
                test1(f)=[];test2(f)=[];
                if (~isempty(test2))
                    if(max(test1)>max(test2))
                    % existe alguma carta na base>meio
                        pt1 = [1 2].*PtVector(HandIndx1(1:2));
                    else
                    % o meio é maior que a base
                        pt1 = zeros(1,3);
                        bsop1=1;
                    end
                else
                % as duas mão são realmente iguais
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));
                end 
            end
        case 6 
            if(HC1(1)>HC1(2))
                pt1 = [1 2].*PtVector(HandIndx1(1:2));
            elseif(HC1(1)== HC1(2))
                pt1 = [1 2].*PtVector(HandIndx1(1:2));
            else
                pt1 = zeros(1,3);
                bsop1 = 1;
            end
        case 7
              if(HandIndx1(1)<HandIndx1(2))
                  pt1 = PtVector(HandIndx1(1));
                  %entao o meio tem a mesma mao que o topo
                  if(HC1(2)>HC1(3))
                      pt1(2) = 2;
                  else
                  %o meio SÓ pode ser menor que a cabeça
                    pt1 = zeros(1,3);
                    bsop1 = 1;
                  end
              else
              %base é igual ao meio
                if(HC1(1)>HC1(2))
                    if(HandIndx1(2)<HandIndx1(3))
                        pt1 = PtVector(HandIndx1(1));
                        pt1(2) = 2;
                        bsop1=0;
                    else
                        if(HC1(2)>HC1(3))
                            pt1 = PtVector(HandIndx1(1));
                            pt1(2) = 2;
                            bsop1=0;
                        else
                            pt1 = zeros(1,3);
                            bsop1 = 1;
                        end
                    end                        
                else
                    pt1 = zeros(1,3);
                    bsop1 = 1;
                end                  
              end
        case 8
        if(HandIndx1(1)<HandIndx1(2))
            if(HandIndx1(2)>HandIndx1(3))
                pt1 = zeros(1,3);
                bsop1 = 1;
            else
                pt1 = [1 2].*PtVector(HandIndx1(1:2));
                bsop1 = 0;
            end
        elseif(HandIndx1(1)>HandIndx1(2))
            pt1 = zeros(1,3);
            bsop1 = 1;
        elseif(HandIndx1(1)>HandIndx1(3) ||  HandIndx1(2)>HandIndx1(3))
            pt1 = zeros(1,3);
            bsop1 = 1;
        else
        %como o topo nao assume dois pares, base deve ser igual o meio
            if(HC1(1)>HC1(2))
                pt1 = [1 2].*PtVector(HandIndx1(1:2));
            elseif(HC1(1)<HC1(2))
                pt1 = zeros(1,3);
                bsop1 = 1;
            else
            % as high cards sao iguais
                fruvs1 = histcounts(CardsValue1{1},1:14); fruvs2 = histcounts(CardsValue1{2},1:14);
                [~,loc1] = ismember(fruvs1,2);    %obtem os indices onde estão os valores maximos de fruvs
                [~,loc2] = ismember(fruvs2,2);
                A2= loc2.*(1:13);A1=loc1.*(1:13);
                A2(A2==0)=[];A1(A1==0)=[];
                if(min(A1)>min(A2))
                %segundo par da base maior que do meio
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));
                    bsop1 = 0;
                elseif(min(A1) < min(A2))
                    pt1 = zeros(1,3);
                    bsop1 = 1;
                else
                    test1 = sort(CardsValue1{1});
                    test2 = sort(CardsValue1{2});
                    f = find(test1==test2);
                    test1(f)=[];test2(f)=[];
                    if (~isempty(test2))
                        if(max(test1)>max(test2))
                        % existe alguma carta na base>meio
                            pt1 = [1 2].*PtVector(HandIndx1(1:2));
                        else
                        % o meio é maior que a base
                            pt1 = zeros(1,3);
                            bsop1=1;
                        end
                    else
                    % as duas mão são realmente iguais
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));
                    end 
                end
            end
        end    
        case 9
        if(HandIndx1(1)<HandIndx1(2))
            if(HandIndx1(2)>HandIndx1(3))
                pt1 = zeros(1,3);
                bsop1 = 1;
            elseif(HandIndx1(2)<HandIndx1(3))
                pt1 = [1 2].*PtVector(HandIndx1(1:2));
                bsop1 = 0;
            else
                if(HC1(2)>HC1(3))
                   pt1 = [1 2].*PtVector(HandIndx1(1:2));
                   bsop1 = 0;
                elseif(HC1(2)<HC1(3))
                   pt1 = zeros(1,3);
                   bsop1 = 1;
                else
                   test2 = sort(CardsValue1{2});
                   test3(1:5) = [0 0 CardsValue1{3}];
                   test3 = sort(test3);
                   f = find(test3==test2);
                   test2(f)=[];test3(f)=[];test3(test3==0)=[];
                    if (~isempty(test3))
                        if(max(test2)>max(test3))
                        % existe alguma carta na meio>topo
                            pt1 = [1 2].*PtVector(HandIndx1(1:2));
                        else
                        % o topo é maior que o meio
                            pt1 = zeros(1,3);
                            bsop1=1;
                        end
                    else
                    % as duas mãos são ""iguais""
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));
                    end 
                end
            end
        elseif(HandIndx1(1)>HandIndx1(2))
            pt1 = zeros(1,3);
            bsop1 = 1;
        elseif(HandIndx1(2)>HandIndx1(3) ||  HandIndx1(1)>HandIndx1(3) )
            pt1 = zeros(1,3);
            bsop1 = 1;
        else
            if(HC1(1)>HC1(2))
                if(HandIndx1(2)==HandIndx1(3))
                if(HC1(2)>HC1(3))
                   pt1 = [1 2].*PtVector(HandIndx1(1:2));
                   bsop1 = 0;
                elseif(HC1(2)<HC1(3))
                   pt1 = zeros(1,3);
                   bsop1 = 1;
                else
                    test2 = sort(CardsValue1{2});
                    test3(1:5) = [0 0 CardsValue1{3}];
                    test3 = sort(test3);
                    f = find(test3==test2);
                    test2(f)=[];test3(f)=[];test3(test3==0)=[];
                    if (~isempty(test3))
                        if(max(test2)>max(test3))
                        % existe alguma carta na meio>topo
                            pt1 = [1 2].*PtVector(HandIndx1(1:2));
                        else
                        % o topo é maior que o meio
                            pt1 = zeros(1,3);
                            bsop1=1;
                        end
                    else
                    % as duas mãos são ""iguais""
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));
                    end 
                end
                else
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));
                end
            elseif(HC1(1)<HC1(2))
                pt1 = zeros(1,3);
                bsop1 = 1;
            elseif(HC1(1)<HC1(3))
                pt1 = zeros(1,3);
                bsop1 = 1;
            else
            %HC1(1) = HC1(2) e HC1(1)>=HC1(3)
                test1 = sort(CardsValue1{1});
                test2 = sort(CardsValue1{2});
                f = find(test1==test2);
                test1(f)=[];test2(f)=[];
                if(max(test1)>=max(test2))
                %é impossível que HC1(3) seja igual HC1(1) e HC1(2)
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));                    
                else
                    pt1 = zeros(1,3);
                    bsop1=1;  
                end
            end
        end    
        case 10
        if(HandIndx1(1)<HandIndx1(2))
            if(HandIndx1(2)>HandIndx1(3))
                pt1 = zeros(1,3);
                bsop1 = 1;
            elseif(HandIndx1(2)<HandIndx1(3))
                pt1 = [1 2].*PtVector(HandIndx1(1:2));
                bsop1 = 0;
            else
                if(HC1(2)>HC1(3))
                   pt1 = [1 2].*PtVector(HandIndx1(1:2));
                   bsop1 = 0;
                elseif(HC1(2)<HC1(3))
                   pt1 = zeros(1,3);
                   bsop1 = 1;
                else
                    test2 = sort(CardsValue1{2});
                    test3(1:5) = [0 0 CardsValue1{3}];
                    test3 = sort(test3);
                    f = find(test3==test2);
                    test2(f)=[];test3(f)=[];test3(test3==0)=[];
                    if (~isempty(test3))
                        if(max(test2)>max(test3))
                        % existe alguma carta na meio>topo
                            pt1 = [1 2].*PtVector(HandIndx1(1:2));
                        else
                        % o topo é maior que o meio
                            pt1 = zeros(1,3);
                            bsop1=1;
                        end
                    else
                    % as duas mãos são ""iguais""
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));
                    end 
                end
            end
        elseif(HandIndx1(1)>HandIndx1(2))
            pt1 = zeros(1,3);
            bsop1 = 1;
        elseif(HandIndx1(2)>HandIndx1(3) ||  HandIndx1(1)>HandIndx1(3) )
            pt1 = zeros(1,3);
            bsop1 = 1;
        else
            if(HC1(1)>HC1(2))
                if(HC1(2)>HC1(3))
                   pt1 = [1 2].*PtVector(HandIndx1(1:2));
                   bsop1 = 0;
                elseif(HC1(2)<HC1(3))
                   pt1 = zeros(1,3);
                   bsop1 = 1;
                else
                    test2 = sort(CardsValue1{2});
                    test3(1:5) = [0 0 CardsValue1{3}];
                    test3 = sort(test3);
                    f = find(test3==test2);
                    test2(f)=[];test3(f)=[];test3(test3==0)=[];
                    if (~isempty(test3))
                        if(max(test2)>max(test3))
                        % existe alguma carta na meio>topo
                            pt1 = [1 2].*PtVector(HandIndx1(1:2));
                        else
                        % o topo é maior que o meio
                            pt1 = zeros(1,3);
                            bsop1=1;
                        end
                    else
                    % as duas mãos são ""iguais""
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));
                    end 
                end
            elseif(HC1(1)<HC1(2))
                pt1 = zeros(1,3);
                bsop1 = 1;
            elseif(HC1(1)<HC1(3) || HC1(2)<HC1(3))
                pt1 = zeros(1,3);
                bsop1 = 1;
            else
            %HC1(1) = HC1(2) e HC1(1)>=HC1(3)
                test1 = sort(CardsValue1{1});
                test2 = sort(CardsValue1{2});
                f = find(test1==test2);
                test1(f)=[];test2(f)=[];
                if (~isempty(test2))
                if(max(test1)>=max(test2))
                    if(HC1(2)>HC1(3))
                        pt1 = [1 2].*PtVector(HandIndx1(1:2));
                    else
                    %High Cards iguais
                        test2 = sort(CardsValue1{2});
                        test3(1:5) = [0 0 CardsValue1{3}];
                        test3 = sort(test3);
                        f = find(test3==test2);
                        test2(f)=[];test3(f)=[];test3(test3==0)=[];
                        if (~isempty(test3))
                            if(max(test2)>max(test3))
                            % existe alguma carta na meio>topo
                                pt1 = [1 2].*PtVector(HandIndx1(1:2));
                            else
                            % o topo é maior que o meio
                                pt1 = zeros(1,3);
                                bsop1=1;
                            end
                        else
                        % as duas mãos são ""iguais""
                            pt1 = [1 2].*PtVector(HandIndx1(1:2));
                        end                    
                    end
                    
                else
                    pt1 = zeros(1,3);
                    bsop1=1;  
                end
                else
                    %sao literalmente iguais
                    pt1 = [1 2].*PtVector(HandIndx1(1:2));
                end
            end
        end
    end
end
  if(~bsop1)  
    switch HandIndx1(3)
        case 9
            if HC1(3)<5          %se o par for menor que par de 6
                pt1(3) = 0;
            else
                pt1(3) = HC1(3) -4;
                if(HC1(3)>10)
                   fantasy(1) = 1; 
                end
            end
        case 7
            pt1(3) = HC1(3) + 9;
            fantasy(1) = 1;
        otherwise
            pt1(3) = 0;
            fantasy(1) = 0;
    end
    if(padaria(1))
        %se existe trinca na cabeça ou [full,royal] no meio:
        %refantasy
        if((pt1(3)>=10) || (pt1(2)>=12))
            fantasy(1) =1;
        else
            fantasy(1) =0;
        end
    end
  end
%disp(pt1);

%------------------------------------------------------------------------
%Player2
%------------------------------------------------------------------------
%confere se a linha anterior é maior que a de cima
if (HandIndx2(1)>HandIndx2(2)) || (HandIndx2(2)>HandIndx2(3))
    pt2 = zeros(1,3);
    bsop2 = 1;
elseif (HandIndx2(1)<HandIndx2(2)) && (HandIndx2(2)<HandIndx2(3))
%calculo dos pontos do jogador1
    pt2 = [1 2].*PtVector(HandIndx2(1:2));
%caso haja uma trinca na segunda linha, são considerados 2 pontos
    if(HandIndx2(2) == 7)
        pt2(2) = 2;
    end
%Caso as mãos sejam "iguais"
%Para uma mão de 5 cartas, isso só ocorre se base=topo
else
    switch HandIndx2(2)
        case 1
            pt2 = [1 2].*PtVector(HandIndx2(1:2)); 
        case 2
            if(HC2(1)>=HC2(2))  % >= pois possibilidade de 2 straight flushes iguais, mas com naipes diferentes
              pt2 = [1 2].*PtVector(HandIndx2(1:2));
            else
              pt2 = zeros(1,3);
              bsop2 = 1;
            end
        case 3 
            if(HC2(1)>HC2(2))
              pt2 = [1 2].*PtVector(HandIndx2(1:2));
            else   %como é impossivel a ocorrencia de duas quadras iguais, ou HC2(1)é maior ou menor que HC2(2)
              pt2 = zeros(1,3);
              bsop2=1;
            end
        case 4
            if(HC2(1)>HC2(2)) %impossível 2 full houses iguais
              pt2 = [1 2].*PtVector(HandIndx2(1:2));
            else
              pt2 = zeros(1,3);
              bsop2=1;
            end
        case 5 
            if(HC2(1)>HC2(2)) 
              pt2 = [1 2].*PtVector(HandIndx2(1:2));
            elseif(HC2(1)<HC2(2))
              pt2 = zeros(1,3);
              bsop2=1;
            else % para que o flush seja considerado igual, todas as 5 cartas devem ser iguais
                test1 = sort(CardsValue2{1});
                test2 = sort(CardsValue2{2});
                f = find(test1==test2);
                test1(f)=[];test2(f)=[];
                if (~isempty(test2))
                    if(max(test1)>max(test2))
                    % existe alguma carta na base>meio
                        pt2 = [1 2].*PtVector(HandIndx2(1:2));
                    else
                    % o meio é maior que a base
                        pt2 = zeros(1,3);
                        bsop2=1;
                    end
                else
                % as duas mão são realmente iguais
                    pt2 = [1 2].*PtVector(HandIndx2(1:2));
                end 
            end
        case 6 
            if(HC2(1)>HC2(2))
                pt2 = [1 2].*PtVector(HandIndx2(1:2));
            elseif(HC2(1)== HC2(2))
                pt2 = [1 2].*PtVector(HandIndx2(1:2));
            else
                pt2 = zeros(1,3);
                bsop2 = 1;
            end
        case 7
              if(HandIndx2(1)<HandIndx2(2))
                  pt2 = PtVector(HandIndx2(1));
                  %entao o meio tem a mesma mao que o topo
                  if(HC2(2)>HC2(3))
                      pt2(2) = 2;
                  else
                  %o meio SÓ pode ser menor que a cabeça
                    pt2 = zeros(1,3);
                    bsop2 = 1;
                  end
              else
              %base é igual ao meio
                if(HC2(1)>HC2(2))
                    if(HandIndx2(2)<HandIndx2(3))
                        pt2 = PtVector(HandIndx2(1));
                        pt2(2) = 2;
                        bsop2=0;
                    else
                        if(HC2(2)>HC2(3))
                            pt2 = PtVector(HandIndx2(1));
                            pt2(2) = 2;
                            bsop2=0;
                        else
                            pt2 = zeros(1,3);
                            bsop2 = 1;
                        end
                    end                        
                else
                    pt2 = zeros(1,3);
                    bsop2 = 1;
                end                  
              end
        case 8
        if(HandIndx2(1)<HandIndx2(2))
            if(HandIndx2(2)>HandIndx2(3))
                pt2 = zeros(1,3);
                bsop2 = 1;
            else
                pt2 = [1 2].*PtVector(HandIndx2(1:2));
                bsop2 = 0;
            end
        elseif(HandIndx2(1)>HandIndx2(2))
            pt2 = zeros(1,3);
            bsop2 = 1;
        elseif(HandIndx2(1)>HandIndx2(3) ||  HandIndx2(2)>HandIndx2(3))
            pt2 = zeros(1,3);
            bsop2 = 1;
        else
        %como o topo nao assume dois pares, base deve ser igual o meio
            if(HC2(1)>HC2(2))
                pt2 = [1 2].*PtVector(HandIndx2(1:2));
            elseif(HC2(1)<HC2(2))
                pt2 = zeros(1,3);
                bsop2 = 1;
            else
            % as high cards sao iguais
                fruvs1 = histcounts(CardsValue2{1},1:14); fruvs2 = histcounts(CardsValue2{2},1:14);
                [~,loc1] = ismember(fruvs1,2);    %obtem os indices onde estão os valores maximos de fruvs
                [~,loc2] = ismember(fruvs2,2);
                A2= loc2.*(1:13);A1=loc1.*(1:13);
                A2(A2==0)=[];A1(A1==0)=[];
                if(min(A1)>min(A2))
                %segundo par da base maior que do meio
                    pt2 = [1 2].*PtVector(HandIndx2(1:2));
                    bsop2 = 0;
                elseif(min(A1) < min(A2))
                    pt2 = zeros(1,3);
                    bsop2 = 1;
                else
                    test1 = sort(CardsValue2{1});
                    test2 = sort(CardsValue2{2});
                    f = find(test1==test2);
                    test1(f)=[];test2(f)=[];
                    if (~isempty(test2))
                        if(max(test1)>max(test2))
                        % existe alguma carta na base>meio
                            pt2 = [1 2].*PtVector(HandIndx2(1:2));
                        else
                        % o meio é maior que a base
                            pt2 = zeros(1,3);
                            bsop2=1;
                        end
                    else
                    % as duas mão são realmente iguais
                    pt2 = [1 2].*PtVector(HandIndx2(1:2));
                    end 
                end
            end
        end    
        case 9
        if(HandIndx2(1)<HandIndx2(2))
            if(HandIndx2(2)>HandIndx2(3))
                pt2 = zeros(1,3);
                bsop2 = 1;
            elseif(HandIndx2(2)<HandIndx2(3))
                pt2 = [1 2].*PtVector(HandIndx2(1:2));
                bsop2 = 0;
            else
                if(HC2(2)>HC2(3))
                   pt2 = [1 2].*PtVector(HandIndx2(1:2));
                   bsop2 = 0;
                elseif(HC2(2)<HC2(3))
                   pt2 = zeros(1,3);
                   bsop2 = 1;
                else
                   test2 = sort(CardsValue2{2});
                   test3(1:5) = [0 0 CardsValue2{3}];
                   test3 = sort(test3);
                   f = find(test3==test2);
                   test2(f)=[];test3(f)=[];test3(test3==0)=[];
                    if (~isempty(test3))
                        if(max(test2)>max(test3))
                        % existe alguma carta na meio>topo
                            pt2 = [1 2].*PtVector(HandIndx2(1:2));
                        else
                        % o topo é maior que o meio
                            pt2 = zeros(1,3);
                            bsop2=1;
                        end
                    else
                    % as duas mãos são ""iguais""
                    pt2 = [1 2].*PtVector(HandIndx2(1:2));
                    end 
                end
            end
        elseif(HandIndx2(1)>HandIndx2(2))
            pt2 = zeros(1,3);
            bsop2 = 1;
        elseif(HandIndx2(2)>HandIndx2(3) ||  HandIndx2(1)>HandIndx2(3) )
            pt2 = zeros(1,3);
            bsop2 = 1;
        else
            if(HC2(1)>HC2(2))
                if(HandIndx2(2) == HandIndx2(3))
                if(HC2(2)>HC2(3))
                   pt2 = [1 2].*PtVector(HandIndx2(1:2));
                   bsop2 = 0;
                elseif(HC2(2)<HC2(3))
                   pt2 = zeros(1,3);
                   bsop2 = 1;
                else
                    test2 = sort(CardsValue2{2});
                    test3(1:5) = [0 0 CardsValue2{3}];
                    test3 = sort(test3);
                    f = find(test3==test2);
                    test2(f)=[];test3(f)=[];test3(test3==0)=[];
                    if (~isempty(test3))
                        if(max(test2)>max(test3))
                        % existe alguma carta na meio>topo
                            pt2 = [1 2].*PtVector(HandIndx2(1:2));
                        else
                        % o topo é maior que o meio
                            pt2 = zeros(1,3);
                            bsop2=1;
                        end
                    else
                    % as duas mãos são ""iguais""
                    pt2 = [1 2].*PtVector(HandIndx2(1:2));
                    end 
                end
                else
                  pt2 = [1 2].*PtVector(HandIndx2(1:2));  
                end
            elseif(HC2(1)<HC2(2))
                pt2 = zeros(1,3);
                bsop2 = 1;
            elseif(HC2(1)<HC2(3))
                pt2 = zeros(1,3);
                bsop2 = 1;
            else
            %HC2(1) = HC2(2) e HC2(1)>=HC2(3)
                test1 = sort(CardsValue2{1});
                test2 = sort(CardsValue2{2});
                f = find(test1==test2);
                test1(f)=[];test2(f)=[];
                if(~isempty(test2))
                if(max(test1)>max(test2))
                %é impossível que HC2(3) seja igual HC2(1) e HC2(2)
                    pt2 = [1 2].*PtVector(HandIndx2(1:2));   
                    bsop2 = 0;
                else
                    pt2 = zeros(1,3);
                    bsop2=1;  
                end
                else
                %sao iguais
                    pt2 = [1 2].*PtVector(HandIndx2(1:2));
                end
            end
        end    
        case 10
        if(HandIndx2(1)<HandIndx2(2))
            if(HandIndx2(2)>HandIndx2(3))
                pt2 = zeros(1,3);
                bsop2 = 1;
            elseif(HandIndx2(2)<HandIndx2(3))
                pt2 = [1 2].*PtVector(HandIndx2(1:2));
                bsop2 = 0;
            else
                if(HC2(2)>HC2(3))
                   pt2 = [1 2].*PtVector(HandIndx2(1:2));
                   bsop2 = 0;
                elseif(HC2(2)<HC2(3))
                   pt2 = zeros(1,3);
                   bsop2 = 1;
                else
                    test2 = sort(CardsValue2{2});
                    test3(1:5) = [0 0 CardsValue2{3}];
                    test3 = sort(test3);
                    f = find(test3==test2);
                    test2(f)=[];test3(f)=[];test3(test3==0)=[];
                    if (~isempty(test3))
                        if(max(test2)>max(test3))
                        % existe alguma carta na meio>topo
                            pt2 = [1 2].*PtVector(HandIndx2(1:2));
                        else
                        % o topo é maior que o meio
                            pt2 = zeros(1,3);
                            bsop2=1;
                        end
                    else
                    % as duas mãos são ""iguais""
                    pt2 = [1 2].*PtVector(HandIndx2(1:2));
                    end 
                end
            end
        elseif(HandIndx2(1)>HandIndx2(2))
            pt2 = zeros(1,3);
            bsop2 = 1;
        elseif(HandIndx2(2)>HandIndx2(3) ||  HandIndx2(1)>HandIndx2(3) )
            pt2 = zeros(1,3);
            bsop2 = 1;
        else
            if(HC2(1)>HC2(2))
                if(HC2(2)>HC2(3))
                   pt2 = [1 2].*PtVector(HandIndx2(1:2));
                   bsop2 = 0;
                elseif(HC2(2)<HC2(3))
                   pt2 = zeros(1,3);
                   bsop2 = 1;
                else
                    test2 = sort(CardsValue2{2});
                    test3(1:5) = [0 0 CardsValue2{3}];
                    test3 = sort(test3);
                    f = find(test3==test2);
                    test2(f)=[];test3(f)=[];test3(test3==0)=[];
                    if (~isempty(test3))
                        if(max(test2)>max(test3))
                        % existe alguma carta na meio>topo
                            pt2 = [1 2].*PtVector(HandIndx2(1:2));
                        else
                        % o topo é maior que o meio
                            pt2 = zeros(1,3);
                            bsop2=1;
                        end
                    else
                    % as duas mãos são ""iguais""
                    pt2 = [1 2].*PtVector(HandIndx2(1:2));
                    end 
                end
            elseif(HC2(1)<HC2(2))
                pt2 = zeros(1,3);
                bsop2 = 1;
            elseif((HC2(1)<HC2(3)) || (HC2(2)<HC2(3)))
                pt2 = zeros(1,3);
                bsop2 = 1;
            else
            %HC2(1) = HC2(2) e HC2(1)>=HC2(3)
                test1 = sort(CardsValue2{1});
                test2 = sort(CardsValue2{2});
                f = find(test1==test2);
                test1(f)=[];test2(f)=[];
                if (~isempty(test2))
                if(max(test1)>=max(test2))
                    if(HC2(2)>HC2(3))
                        pt2 = [1 2].*PtVector(HandIndx2(1:2));
                    else
                    %High Cards iguais
                        test2 = sort(CardsValue2{2});
                        test3(1:5) = [0 0 CardsValue2{3}];
                        test3 = sort(test3);
                        f = find(test3==test2);
                        test2(f)=[];test3(f)=[];test3(test3==0)=[];
                        if (~isempty(test3))
                            if(max(test2)>max(test3))
                            % existe alguma carta na meio>topo
                                pt2 = [1 2].*PtVector(HandIndx2(1:2));
                            else
                            % o topo é maior que o meio
                                pt2 = zeros(1,3);
                                bsop2=1;
                            end
                        else
                        % as duas mãos são ""iguais""
                            pt2 = [1 2].*PtVector(HandIndx2(1:2));
                        end                    
                    end
                else
                    pt2 = zeros(1,3);
                    bsop2=1;  
                end
                else
                %são literalmente iguais
                pt2 = [1 2].*PtVector(HandIndx2(1:2));
                end
            end
        end
    end
end
  if(~bsop2)  
    switch HandIndx2(3)
        case 9
            if HC2(3)<5          %se o par for menor que par de 6
                pt2(3) = 0;
            else
                pt2(3) = HC2(3) -4;
                if(HC2(3)>10)
                   fantasy(2) = 1; 
                end
            end
        case 7
            pt2(3) = HC2(3) + 9;
            fantasy(2) = 1;
        otherwise
            pt2(3) = 0;
            fantasy(2) = 0;
    end
    if(padaria(2))
        %se existe trinca na cabeça ou [full,royal] no meio:
        %refantasy
        if((pt2(3)>=10) || (pt2(2)>=12))
            fantasy(2) =1;
        else
            fantasy(2)=0;
        end
    end
  end
%disp(pt2);
%------------------------------------------------------------------------
%Player1 x Player2
%------------------------------------------------------------------------
    %Pontos positivo = Player1 está melhor
    %Pontos negativo = Player2 está melhor
Pontos = sum(pt1-pt2);
S = sign(pt1-pt2);
M = mean(S);
if(bsop1 || bsop2)
%adiciona pontos de scoop, caso occora
    if(M>0 || (bsop2 && ~bsop1))
        Pontos = Pontos + 6;
    elseif(M<0 || (bsop1 && ~bsop2))
        Pontos = Pontos - 6;
    else
        Pontos = 0;
    end
else
    %compara as mão de 5 cartas primeiro, para ver quem ganha a linha
    for i=1:2
        if(HandIndx1(i)<HandIndx2(i))
        %p1 ganha a linha
            S(i)=1;
        elseif(HandIndx1(i)>HandIndx2(i))
        %p2 ganha a linha
            S(i)= -1;
        else
        %ambos tem a mesma mão
        %é realizada uma comparação de high cards
            switch HandIndx1(i)
                case 1
                %royals são iguais
                S(i)= 0;
                case 2
                    if(HC1(i)>HC2(i))
                    %p1 ganha a linha
                        S(i)=1;
                    elseif(HC1(i)<HC2(i))
                        S(i)= -1;
                    else
                    %straigth flushes iguais
                        S(i)=0;
                    end
                case 3
                    if(HC1(i)>HC2(i))
                    %p1 ganha a linha
                        S(i)=1;
                    else
                    %nao existem 2 quadras iguais
                        S(i)= -1;
                    end
                case 4
                    if(HC1(i)>HC2(i))
                    %p1 ganha a linha
                        S(i)= 1;
                    else
                    %nao existem 2 fulls iguais
                        S(i)= -1;
                    end
                case 5
                    if(HC1(i)>HC2(i))
                    %p1 ganha a linha
                        S(i)= 1;
                    elseif(HC1(i)<HC2(i))
                        S(i)= -1;
                    else
                    %high cards são iguais
                        test1 = sort(CardsValue1{i});
                        test2 = sort(CardsValue2{i});
                        f = find(test1==test2);
                        test1(f)=[];test2(f)=[];
                        if (~isempty(test2))
                            if(max(test1)>max(test2))
                            % existe alguma carta de p1>p2
                            	S(i)= 1;
                            else
                            %p2>p1
                                S(i)= -1;
                            end
                        else
                        % as duas mão são realmente iguais
                            S(i)=0;
                        end 
                    end
                case 6
                    if(HC1(i)>HC2(i))
                    %p1 ganha a linha
                        S(i)= 1;
                    elseif(HC1(i)== HC2(i))
                    %empate
                    S(i)= 0;
                    else
                    %p2 ganha
                        S(i)= -1;
                    end
                case 7
                    if(HC1(i)>HC2(i))
                    %p1 ganha
                        S(i)= 1;
                    else
                    %p2 ganha    
                        S(i)= -1;
                    end                  
                case 8
                    if(HC1(i)>HC2(i))
                    %p1 ganha
                        S(i)= 1;
                    elseif(HC1(i)<HC2(i))
                    %p2 ganha
                        S(i)= -1;
                    else
                    % as high cards sao iguais
                        fruvs1 = histcounts(CardsValue1{i},1:14); fruvs2 = histcounts(CardsValue2{i},1:14);
                        [~,loc1] = ismember(fruvs1,2);    %obtem os indices onde estão os valores maximos de fruvs
                        [~,loc2] = ismember(fruvs2,2);
                        A2= loc2.*(1:13);A1=loc1.*(1:13);
                        A2(A2==0)=[];A1(A1==0)=[];
                        if(min(A1)>min(A2))
                        %segundo par de p1>p2
                            S(i)=1;
                        elseif(min(A1) < min(A2))
                        %segundo par de p1<p2
                            S(i)= -1;
                        else
                        %ambos os pares sao iguais
                            test1 = sort(CardsValue1{i});
                            test2 = sort(CardsValue2{i});
                            f = find(test1==test2);
                            test1(f)=[];test2(f)=[];
                            if (~isempty(test2))
                                if(max(test1)>max(test2))
                                % existe alguma carta de p1>p2
                                    S(i)= 1 ;
                                else
                                %p2>p1
                                    S(i)= -1;
                                end
                            else
                            % as duas mão são realmente iguais
                                S(i)= 0;
                            end 
                        end
                    end
                case 9
                    if(HC1(i)>HC2(i))
                    %p1 ganha
                        S(i)= 1;
                    elseif(HC1(i)<HC2(i))
                    %p2 ganha
                        S(i)= -1;
                    else
                    %HC2(1) = HC2(2)
                        test1 = sort(CardsValue1{i});
                        test2 = sort(CardsValue2{i});
                        f = find(test1==test2);
                        test1(f)=[];test2(f)=[];
                        if(max(test1)>max(test2))
                        %Alguma carta de p1>p2
                            S(i)= 1;                    
                        elseif(max(test1)<max(test2))
                        %P2 ganha
                            S(i)= -1;
                        else
                            S(i)= 0;
                        end
                    end
                case 10
                    if(HC1(i)>HC2(i))
                    %p1 ganha    
                        S(i)= 1;  
                    elseif(HC1(i)<HC2(i))
                    %p2 ganha
                        S(i)= - 1;
                    else
                    %HC2(1) = HC2(2)
                        test1 = sort(CardsValue1{i});
                        test2 = sort(CardsValue2{i});
                        f = find(test1==test2);
                        test1(f)=[];test2(f)=[];
                        if(max(test1)>max(test2))
                        %P1 ganha    
                            S(i)=1;
                        elseif(max(test1)<max(test2))
                        %p2 ganha    
                            S(i)= -1;
                        else
                            S(i)= 0;
                        end
                    end
            end
        end
        
    end
    %compara o topo de p1 e p2
    if(HandIndx1(3)<HandIndx2(3))
    %p1 ganha a linha
        S(3)=1;
    elseif(HandIndx1(3)>HandIndx2(3))
    %p2 ganha a linha
        S(3)= -1;
    else
    %ambos tem a mesma mão
        switch HandIndx2(3)
        case 9
            if (HC1(3)>HC2(3))
            %p1 ganha
                S(3)=1;
            elseif(HC1(3)<HC2(3))
            %p2 ganha
                S(3)= -1;
            else
            %High Cards iguais
            test1 = sort(CardsValue1{3});
            test2 = sort(CardsValue2{3});
            f = find(test1==test2);
            test1(f)=[];test2(f)=[];
                if(max(test1)>max(test2))
                %P1 ganha    
                    S(3)=1;
                elseif(max(test1)<max(test2))
                %p2 ganha    
                    S(3)= -1;
                else
                    S(3)= 0;
                end
            end
        case 7
            if(HC1(3)>HC2(3))
            %p1 ganha
                S(3)=1;
            else
            %p2 ganha // impossivel ter a mesma high card
                S(3)= -1;
            end
        otherwise
            if(HC1(3)>HC2(3))
            %p1 ganha
                S(3)=1;
            elseif(HC1(3)<HC2(3))
            %p2 ganha 
                S(3)= -1;
            else
            %High Cards iguais
            test1 = sort(CardsValue1{3});
            test2 = sort(CardsValue2{3});
            f = find(test1==test2);
            test1(f)=[];test2(f)=[];
            if(~isempty(test1))
                if(max(test1)>max(test2))
                %P1 ganha    
                    S(3)=1;
                elseif(max(test1)<max(test2))
                %p2 ganha    
                    S(3)= -1;
                else
                    S(3)= 0;
                end
            else
                S(3) = 0;
            end
            end
        end
    end
    %disp(sum(S));
    if(sum(S) == 3)
    %p1 da scoop em p2
        Pontos = Pontos +6;
    elseif(sum(S)==-3)
    %p2 da scoop em p1
        Pontos = Pontos -6;
    else
        Pontos = Pontos + sum(S);
    end
end

end %end of function