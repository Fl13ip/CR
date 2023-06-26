% Alínea A)

% Define o caminho para a pasta "start"
folder_path = 'start/';

% Define as dimensões das imagens
image_size = [25 25];

% Define o número de classes (0 a 9 + operações matemáticas)
num_classes = 14;

% Cria matrizes para armazenar os dados de treinamento e targets
training_data = zeros(num_classes*5, image_size(1)*image_size(2)); % [70 , 625]
training_labels = zeros(num_classes*5, num_classes);  % Target [70  , 14]

% Cria um loop para percorrer todas as pastas
for i = 0:13
    % Define o nome da pasta atual
    if i <= 9
        current_folder_name = num2str(i);
    elseif i == 10
        current_folder_name = 'add';
    elseif i == 11
        current_folder_name = 'div';
    elseif i == 12
        current_folder_name = 'mul';
    elseif i == 13
        current_folder_name = 'sub';
    end
    
    % Define o caminho para a pasta atual
    current_folder = strcat(folder_path, current_folder_name, '/');
    
    % Cria um loop para percorrer todas as imagens na pasta atual
    for j = 1:5
        % Define o caminho para a imagem atual
        current_image = imread(strcat(current_folder, num2str(j), '.png'));
        
        % Redimensiona a matriz binária para a dimensão das imagens
        resized_image = imresize(current_image, image_size);
        
        % Adiciona a matriz redimensionada à matriz de dados de treinamento
        training_data((i*5)+j, :) = resized_image(:); % resized_image(:) -> o operador ':' é usado para transformar a matriz 2D em 1D || rezised_image[1x625] -- training_data[70x625]
        
        % Adiciona o target correspondente à matriz de targets de treinamento
        training_labels((i*5)+j, i+1) = 1; % Target
    end
end

training_data = training_data';
training_labels = training_labels';

% Média das 10 execuções
num_execucoes=10;
acuracias=zeros(num_execucoes,1);% [10 1]

    % loop
    for i=1:num_execucoes

        % Cria a rede neural
        net = feedforwardnet(10); 
        
        % Define as opções de treinamento
        net.trainFcn = 'traingdx';
        net.divideFcn = '';
        net.trainParam.epochs = 2500;

        [net, tr] = train(net, training_data, training_labels);

        % Simular
        out = sim(net, training_data);

        % Visualizar desempenho
        plotconfusion(training_labels, out);

            % Cálculo da accuracy
            r=0;
            for j=1:size(out,2)                    % Para cada classificacao  
              [a, b] = max(out(:,j));              % b guarda a linha onde encontrou valor mais alto da saida obtida
              [c, d] = max(training_labels(:,j));  % d guarda a linha onde encontrou valor mais alto da saida desejada
              if b == d                            % se estao na mesma linha, a classificacao foi correta (incrementa 1)
                  r = r+1;
              end
            end

            accuracy = r/size(out,2)*100;
            fprintf('[%d]->[%f%%]\n',i, accuracy);
            acuracias(i)= accuracy;
    end

% Cáculo da média
media_acuracias = mean(acuracias);
fprintf('Média da precisão total (10 execuções) nos 70 exemplos: %.1f %%\n', media_acuracias);
