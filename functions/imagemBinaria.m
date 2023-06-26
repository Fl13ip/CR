function[matrizBinaria] = imagemBinaria(~)

    % Define as dimensões da imagem
    image_size = [25 25];    
 
    matrizBinaria = zeros(1 , image_size(1)*image_size(2)); % [1 , 25*25]

    caminhoImagem = 'imagem.png';

    if exist(caminhoImagem, 'file') ~= 2
        error('O arquivo de imagem não existe ou o caminho está incorreto.');
    end

    current_image = imread(caminhoImagem); 
   
    %Redimensiona a matriz binária para a dimensão das imagens
    resized_image = imresize(current_image, image_size);

    % Verificar se as bordas são pretas
    if ~all(resized_image(1,:) == 0) || ~all(resized_image(end,:) == 0) || ...
            ~all(resized_image(:,1) == 0) || ~all(resized_image(:,end) == 0)
        % Preencher as bordas com valor máximo (branco)
        resized_image(1,:) = 255; % Primeira linha
        resized_image(end,:) = 255; % Última linha
        resized_image(:,1) = 255; % Primeira coluna
        resized_image(:,end) = 255; % Última coluna
    end
    
    % Adiciona a matriz redimensionada à matriz de dados
    matrizBinaria(1, :) = resized_image(:)';
    
    matrizBinaria = matrizBinaria';  

    imshow(resized_image);
end