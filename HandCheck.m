function [CardsValue,SuitsValue,HandIndx,H] = HandCheck(hand,Cards,Suits)
SuitsValue = ceil(hand./13);
%disp(Suits(SuitsValue));
CardsValue = hand-(SuitsValue-1)*13;
%disp(Cards(CardsValue));
fruvs = histcounts(CardsValue,1:14);
%flavio = histcounts(CardsValue,1:14);
[valor,indx] = max(fruvs);
[~,loc] = ismember(fruvs,valor);    %obtem os indices onde estão os valores maximos de fruvs
fravs = fruvs;        %armazena fruvs somente para o check de full house
fruvs(~loc) = 0;      % zera todos os valores que nao sao o max(fruvs), facilitando o switch seguinte
if(size(hand,2) == 3) %condição para avaliação da linha superior 
    switch valor
        case 3
            X = ['Trinca de ',Cards(indx)];
            H = indx;
            HandIndx = 7;
        case 2
            X = ['Par de ',Cards(indx)];
            H = indx;
            HandIndx = 9;
        case 1
           X = [Cards(max(CardsValue)),'High'];
           H = max(CardsValue);
           HandIndx = 10;
    end
    %disp(X);
    return;           %impede que o programa tente avaliar hand para uma mão de 5 cartas
end

switch sum(fruvs)
    case 2
        X = ['Par de ',Cards(indx)];
        HandIndx = 9;
        H = indx;
        %disp(X);
    case 3
        fll = ismember(2,fravs);
        if (fll==1)
         X = ['Full de ',Cards(indx)];
         HandIndx = 4;
         H = indx;
        else
         X = ['Trinca de ',Cards(indx)];      
         HandIndx = 7;
         H = indx;
        end
        %disp(X)
    case 4
        ccc= loc.*(1:13);
        ccc(ccc==0)=[];
         if(size(ccc)<2)
            X = ['Quadra de ',Cards(indx)];
            %disp(X);
            H = indx;
            HandIndx = 3;
         else
            X = ['Par de',Cards(max(ccc)),'e par de ',Cards(min(ccc))];
            %disp(X);
            H = max(ccc);
            HandIndx = 8;
         end
    otherwise
        sorted = sort(CardsValue);
        atest = diff(sorted,1);
        acuracia = sum(ismember(atest,[1 1 1 1]));
        kkk=ismember(sorted,[1 2 3 4 13],'rows');    %check da menor sequencia
        crabs = histc(SuitsValue,1:4);
        [val_crabs,indcr] = max(crabs);
         if ( (acuracia==4) || (kkk==1) )
            if(min(CardsValue)== 1)
                H = 4;
                S = ['Sequencia em',Cards(H)];
                HandIndx = 6;
                if(val_crabs>=4)
                   S = ['Straight Flush de',Suits(indcr),'em',Cards(H)];
                   HandIndx = 2;
                end
            else
                H = max(CardsValue);
                S = ['Sequencia em',Cards(H)];
                HandIndx = 6;
                if(val_crabs>4)
                   S = ['Straight Flush de',Suits(indcr),'em',Cards(H)];
                   HandIndx = 2;
                   rrr=ismember(sorted,[9 10 11 12 13],'rows');    %check de royal
                   if(rrr==1)
                       S = ['Royal Flush de',Suits(indcr)];
                       HandIndx = 1;
                   end
                end
            end
           %disp(S);
           
         elseif(val_crabs>4)
           fff = ['Flush de', Suits(indcr)];
           %disp(fff);
           H = max(CardsValue);
           HandIndx = 5;
         else
           X = [Cards(max(CardsValue)),'High'];
           %disp(X)
           H = max(CardsValue);
           HandIndx = 10;
         end
end



