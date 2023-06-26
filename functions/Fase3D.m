% Alínea C) - Digitos

load('.mat'); % Carrega para a ver net

% Define o caminho para a pasta "start"
folder_path = 'dataset';

% Define as dimensões das imagens
image_size = [25 25];

% Define o número de classes (0 a 9)
num_classes = 10;

% Cria matrizes para armazenar os dados de treinamento e targets
training_data = zeros(num_classes*3, image_size(1)*image_size(2)); % [30 , 25*25]
training_labels = zeros(num_classes*3, num_classes);  % Target [30  , 10]

% Cria um loop para percorrer todas as pastas
for i = 0:9
    % Define o nome da pasta atual
        current_folder_name = num2str(i);
    
    % Define o caminho para a pasta atual
    current_folder = strcat(folder_path, current_folder_name, '/');
    
    % Cria um loop para percorrer todas as imagens na pasta atual
    for j = 1:3
        % Define o caminho para a imagem atual
        current_image = imread(strcat(current_folder, num2str(j), '.png'));
        
        % Redimensiona a matriz binária para a dimensão das imagens
        resized_image = imresize(current_image, image_size);
        
        % Adiciona a matriz redimensionada à matriz de dados de treinamento
        training_data((i*3)+j, :) = resized_image(:)'; % resized_image(:) -> o operador ':' é usado para transformar a matriz 2D em 1D || rezised_image[1x625] -- training_data[70x625] 

        % Adiciona o target correspondente à matriz de targets de treinamento
        training_labels((i*3)+j, i+1) = 1; % Target
    end
end

training_data = training_data';
training_labels = training_labels';

% Classificar o conjunto de teste usando a rede neural carregada
out = sim(net, training_data);

% Mostrar a matriz de confusão
plotconfusion(training_labels, out);

% Calcula accuracy total do modelo
r=0;
for i=1:size(out,2)                     % Para cada classificacao  
  [a, b] = max(out(:,i));               % b guarda a linha onde encontrou valor mais alto da saida obtida
  [c, d] = max(training_labels(:,i));   % d guarda a linha onde encontrou valor mais alto da saida desejada
  if b == d                             % se estao na mesma linha, a classificacao foi correta (incrementa 1)
      r = r+1;
  end
end

accuracy = r/size(out,2)*100;
fprintf('Precisao total %.1f %%\n', accuracy)