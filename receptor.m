clc;
clear;

% Definir o tempo de gravação (em segundos)
tempo_gravacao = 23;

% Definir a taxa de amostragem e o número de amostras
taxa_amostragem = 44100; % Pode variar dependendo do sistema
numero_amostras = taxa_amostragem * tempo_gravacao;

% Inicializar o vetor para armazenar os dados
dados_audio = zeros(numero_amostras, 1);

% Gravar áudio do microfone
disp('Gravando áudio...');
recorder = audiorecorder(taxa_amostragem, 16, 1);
recordblocking(recorder, tempo_gravacao);
disp('Gravação concluída.');

% Obter os dados gravados
dados_gravados = getaudiodata(recorder);

% Armazenar os dados no vetor
dados_audio(1:length(dados_gravados)) = dados_gravados;

% Criar vetor de tempo
tempo = (0:(numero_amostras-1)) / taxa_amostragem;

% Plotar o gráfico
plot(tempo, dados_audio);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Gráfico da Entrada de Som do Microfone');

audiowrite("audio_recebido.wav",dados_audio,taxa_amostragem);

