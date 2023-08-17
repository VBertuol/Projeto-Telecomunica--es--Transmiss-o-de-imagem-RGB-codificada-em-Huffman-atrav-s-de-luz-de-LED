Objetivo: 

Durante o primeiro semestre de 2023, na matéria de Principios de Sistems de telecomunicações do curso de Engenharia de computação, foi proposto aos alunos um trabalho envolvendo codificação, transmissão, recepção, decodificação e remontagem de uma imagem RGB utilizando diferentes meios de comunicação.

No meu caso, o desafio era transmitir o código através de uma luz de LED e receber por um fotodiodo.

 Passo-a-Passo:

 Passo 1: Pegar uma imagem (logo utfpr) e codificar utilizando Huffman dentro do Matlab.

 Passo 2: Transformar a imagem em Aúdio

 Passo 3: Reproduzir o som do Aúdio pelo computador, porém com a saída de som acoplada em um circuito eletrônico terminado em uma luz de LED que piscava conforme o sinal binário recebido recebido: luz = 0, não-luz = 1.

 OBS: tanto na transmissão quanto na recepção os sinais de corrente elétrica não eram 100% digitais, variando dentro de um espectro, assim foi traçado um limiar X, acima de X = 0, abaixo de X = 1.

 Passo 4: Receber o arquivo sinal de luz através de um fotodiodo que converte estimulo luminoso em corrente.

 Passo 5: Passar o sinal coletado para um ociloscópio que gravou as amostras em um arquivo CSV.

 OBS: inicialmente iriamos captar através de outra entrada de aúdio de computador, mas o sinal era muito distorcido pela placa de entrada de som do computador, impedindo decodificar a mensagem corretamente.

 Passo 6: decodificar o arquivo CSV e remontar a imagem

 [Projeto-Final-PSC (1).pdf](https://github.com/VBertuol/Projeto-Telecomunicacoes--Transmissao-de-imagem-RGB-codificada-em-Huffman-atraves-de-luz-de-LED/files/12373553/Projeto-Final-PSC.1.pdf)
