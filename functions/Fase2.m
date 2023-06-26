% Alínea B)

% Define o caminho para a pasta "start"
folder_path = 'train1/';

% Define as dimensões das imagens
image_size = [25 25];

% Define o número de classes (0 a 9 + operações matemáticas)
num_classes = 14;

% Cria matrizes para armazenar os dados de treinamento e rótulos
training_data = zeros(num_classes*50, image_size(1)*image_size(2)); % [700 , 625]
training_labels = zeros(num_classes*50, num_classes);  % Target [700  , 14]

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
    for j = 1:50
        % Define o caminho para a imagem atual
        current_image = imread(strcat(current_folder, num2str(j), '.png'));
        
        % Redimensiona a matriz binária para a dimensão das imagens
        resized_image = imresize(current_image, image_size);
        
        % Adiciona a matriz redimensionada à matriz de dados de treinamento
        training_data((i*50)+j, :) = resized_image(:)'; % resized_image(:) -> o operador ':' é usado para transformar a matriz 2D em 1D || rezised_image[1x625] -- training_data[70x625]
        
        % Adiciona o target correspondente à matriz de targets de treinamento
        training_labels((i*50)+j, i+1) = 1; % Target
    end
end

training_data = training_data';
training_labels = training_labels';

%Média das 10 execuções
num_execucoes=10;
accuracy_Total=zeros(num_execucoes,1);% [10 1]
accuracy_Teste=zeros(num_execucoes,1);% [10 1]

%loop
for l=1:num_execucoes

    % Cria a rede neural 
    net = feedforwardnet([200 100 50 30]);
    
    % Define as opções de treinamento
    net.trainFcn = 'traingdx'; 
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'tansig'; 
     
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = .7;
    net.divideParam.valRatio = 0.0;
    net.divideParam.testRatio = 0.3; 
    
    net.trainParam.epochs = 100;
    net.trainParam.lr = 0.001; 
    
    net.performParam.regularization = 0.01;
    net.performParam.normalization = 'none';
    net.performFcn = 'mse';

    % Treina a rede neural
    [net, tr] = train(net, training_data, training_labels);

    %Simular
    out = sim(net, training_data);

    %Visualizar Desempenho 
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
    accuracy_Total(l) = accuracy;


    % Simular a rede apenas no conjunto de teste
    TInput = training_data(:, tr.testInd);
    TTargets = training_labels(:, tr.testInd);
    
    out = sim(net, TInput);
    out = out>=0.5;

    %Calcula e mostra a percentagem de classificacoes corretas no conjunto de teste
    r=0;
    for i=1:size(out,2)                     % Para cada classificacao  
      [a, b] = max(out(:,i));               % b guarda a linha onde encontrou valor mais alto da saida obtida
      [c, d] = max(TTargets(:,i));          % d guarda a linha onde encontrou valor mais alto da saida desejada
      if b == d                             % se estao na mesma linha, a classificacao foi correta (incrementa 1)
          r = r+1;
      end
    end

    accuracy = r/size(tr.testInd,2)*100;
    accuracy_Teste(l) = accuracy;

    fprintf('[%d]: Accuracy_Total[%.1f%%] || Accuracy_Teste[%.1f%%]\n',l, accuracy_Total(l), accuracy_Teste(l));
    
end

media_accuracy_total = mean(accuracy_Total);
media_accuracy_teste = mean(accuracy_Teste);
fprintf(['Média da precisão total (10 execuções) nos 700 exemplos: %.1f %%\n' ...
    'Média da precisão de teste (10 execuções) nos 700 exemplos: %.1f %%\n'], media_accuracy_total, media_accuracy_teste);


