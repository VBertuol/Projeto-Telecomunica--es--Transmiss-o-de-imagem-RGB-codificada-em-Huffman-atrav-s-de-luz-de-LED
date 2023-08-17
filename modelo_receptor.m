% Projeto final de PSC 2023/1 versão 1 (22/06/2023)

clear; 
close all; 
clc;

%% TRANSMISSOR ------------------------------------------------------------

% Carrega imagem
X = imread('espectro_cor.png');
figure; imshow(X); title('Imagem Tx');	% Exibe a imagem a ser transmitida
Xtam = [size(X,1) size(X,2) size(X,3)]  % Dimensões da matriz da imagem
Nbytes_original = Xtam(1)*Xtam(2)*Xtam(3)
Nbits_original = Nbytes_original*8

% Faz análise estatística de toda a imagem
Ncor = 256; % para escala de 8 bits temos 256 níveis por cor
p = hist(double(X(:)),Ncor)/Nbytes_original;
% Gera o dicionário de huffman
list_symb  = unique(0:Ncor-1);
dict = huffmandict(list_symb,p);

% Cria um quadro para cada camada de cor
preambulo = de2bi(0b10000001,8,'left-msb'); % (pode mudar caso prefira)
for id = 1:3
    data_bytes = X(:,:,id); % Separa a camada (matriz 2-D) de cor
    data_bytes = data_bytes(:); % Transforma em um vetor
    
        data_bits{id} = huffmanenco( data_bytes, dict)';
    tamanho = de2bi(length(data_bits{id}),16);
    quadro_tx = [preambulo de2bi(id,2,'left-msb') tamanho de2bi(data_bits{id},1)'];
    quadro_tx = [quadro_tx de2bi(crc32(quadro_tx))]; % adiciona CRC
    tres_quadros{id} = quadro_tx;
end

% Codifica os 3 quadros em linha do tipo bipolar NRZ
Fs = 44100; % Freq. de amostragem típica de uma placa de áudio
baud_rate = 44100/10;       % Taxa de simbolos/segundo
s1 = ones(1, Fs/baud_rate); % Gera o sinal de marca (símbolo para bit = '1')
s0 = -ones(1, Fs/baud_rate); % Gera o sinal de marca (símbolo para bit = '0')
silencio  = zeros(1,Fs);    % silencio com duração de 1 seg
s = silencio; % começa com um silencio
for id = 1:3
    ini_quadro = length(s);
    quadro = tres_quadros{id};
    for n=1:length(quadro)      % Verifica todos os bits do quadro
      ini = ini_quadro + (n-1)*Fs/baud_rate+1;
      fim = ini_quadro + n*Fs/baud_rate;
      if quadro(n) == 1  % bit=1? (atribui os símbolos)
        s(ini:fim) = s1;
      else
        s(ini:fim) = s0;
      end
    end
    s = [s silencio]; % adiciona um silencio
end

%Plota o sinal no tempo
Ts = 1/Fs;  % Período de amostragem
t = 0:Ts:(length(s)-1)*Ts;
 figure; plot(t, s); ylim([-1.1 1.1]); title('Sinal banda base polar NRZ')
 xlabel('t [s]'); ylabel('s(t)');

%Salva o sinal banda base em um arquivo de áudio
audiowrite('tx.wav',s,Fs);
%soundsc(s,Fs); % Toca nas caixas de som


%% RECEPTOR ---------------------------------------------------------------
% Cada equipe pode customizar o código anterior do transmissor...
% e deve desenvolver o código do receptor
% (se preferir, pode usar outra linguagem: Phyton, C, Fortran etc)
% Detectar os bits: pode usar um "if" mesmo e testar bem no meio do símbolo
% - para isto, desenvolver um esquema para detectar o sincronismo
% De cada quadro: separar preâmbulo, id, data_bits e CRC_tx
% - calcular o CRC_rx no receptor
% - comparar com o CRC_tx do transmissor
% Se diferentes, descartar quadro e capturar novo

% Carrega o sinal recebido
[m, Fs] = audioread('tx.wav');

% Substitui todos os valores -1 por 0
m(m == -1) = 0;

% Reduz o tamanho do vetor e mantendo apenas o primeiro valor de cada grupo de 10
m = m(1:10:end);

m = reshape(m', 1, []);

% Cria um novo vetor com o mesmo número de posições que y
y = zeros(size(m));

for i = 1:length(m)
    if m(i) > 0.5
        y(i) = 1;
    end
end

rx_bits = cell(1, 3); % Vetor para armazenar os bits recebidos
vetcrc = cell(1, 3); % Vetor para armazenar os CRCs recebidos
tamanho_info_decimal = 0;

% Procura pela sequência "10000001"
seq = [1.0000 0 0 0 0 0 0 1.0000];
id2 = 0;
i = 1.0000;
while i < length(y)
     if isequal(y(i:i+7), seq)
        % Lê os próximos 2 bits e os transforma em decimal
        id2_decimal = bi2de(y(i+8:i+9), 'left-msb');
        id2 = id2_decimal;
        
        % Lê os próximos 16 bits e os transforma em decimal
        tamanho_info_decimal = bi2de(y(i+10:i+25));
        
        % Armazena os próximos "tamanho_info" bits em "rx_bytes" (em binário)
        rx_bits{id2} = y(i+26:i+26+tamanho_info_decimal);
        % Armazena os próximos 32 bits em "vetcrc" (em binário)
        vetcrc{id2} = y(i+26+tamanho_info_decimal:i+58+tamanho_info_decimal);

        i = i+58+tamanho_info_decimal;

        if isequal(id2, 3)
         i = length(y) - 1;
        end
        
    end
    i = i + 1;
end


% Se iguais, os bits foram detectados corretamente...
rx_bytes = zeros(3, Xtam(1)*Xtam(2));
for id = 1:3
    % Decodifica usando o mesmo dicionario do transmissor
    rx_bytes(id,:) = huffmandeco(rx_bits{id}, dict); 
    % Monta a matriz de imagem
    Y(:,:,id) = reshape(rx_bytes(id,:),[Xtam(1) Xtam(2)]);
end
Y = uint8(Y);   % Converte para inteiro de 8 bits
figure; imshow(Y); title('Imagem Rx');	% Exibe a imagem recebida
