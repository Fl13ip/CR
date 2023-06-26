function [resultado,number] = identificarImagem(nomeRede , flag)

    caminhoRede = append("...",nomeRede);
    
    load(caminhoRede,'net');
    
    matrizBinaria = imagemBinaria(); 
    out = sim(net , matrizBinaria);

    [~,b] = max(out);
    disp(b);

    number=-1;
    resultado='';
    if(flag==0)
        switch(b)
        case 1 
            number = 0;
        case 2 
            number = 1;
        case 3 
            number = 2;
        case 4 
            number = 3;
        case 5  
            number = 4;
        case 6  
            number = 5;
        case 7 
            number = 6;
        case 8  
            number = 7;
        case 9  
            number = 8;
        case 10  
            number = 9;
        otherwise 
            number = -1;
        end
    elseif(flag==1)
        switch(b)
        case 1
            resultado = "+";
        case 2
            resultado = ":";
        case 3
            resultado = "x";
        case 4
            resultado = "-";
        otherwise
            resultado = "?";
        end
    end
end