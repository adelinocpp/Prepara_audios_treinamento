close all; clearvars; clc;
% -------------------------------------------------------------------------
addpath('/media/adelino/SMAUG/Verificacao_Locutor_SPAV/Bibliotecas/voicebox')
addpath('/media/adelino/SMAUG/Verificacao_Locutor_SPAV/Bibliotecas/apstools')
addpath('/media/adelino/SMAUG/Verificacao_Locutor_SPAV/Bibliotecas/s2nr')
% -------------------------------------------------------------------------
m           = 'a';
pp.pr       = 0.85; % default = 0.70
timeStep    = 0.01;
timeWin     = 0.025;
% -------------------------------------------------------------------------
S2NR = struct;
S2NR.NFFT   = 1024;    % fft window size 
S2NR.RTH    = 0.6;      % reliability threshold
S2NR.alpha  = 0.5;    % fft window overlap 
S2NR.sigma  = 0.1;    % image segmentation threshold
% -------------------------------------------------------------------------
DIR_GSM = 'GSM_debug/';
DIR_PDR = 'PDR_debug/';
DIR_QST = 'QST_debug/';
% -------------------------------------------------------------------------
listGSM = lista_conteudo_pasta(DIR_GSM,{'.wav'});
listPDR = lista_conteudo_pasta(DIR_PDR,{'.wav'});
listQST = lista_conteudo_pasta(DIR_QST,{'.wav'});
for k = 1:length(listGSM)
    listGSM{k} = [DIR_GSM,listGSM{k}];
end
for k = 1:length(listPDR)
    listPDR{k} = [DIR_PDR,listPDR{k}];
end
for k = 1:length(listQST)
    listQST{k} = [DIR_QST,listQST{k}];
end
fullList = [listGSM;listPDR;listQST];
% -------------------------------------------------------------------------
fullVAD = cell(length(fullList),1);
fullSNR = zeros(length(fullList),3);
for i = 1:length(fullList)
    [y, fs] = audioread(fullList{i});
    fullVAD{i} = vadsohn(y,fs,m,pp);
    idsVoice = find(fullVAD{i} == 1);
    idsBackG = find(fullVAD{i} == 0);
    [A,B, C] = basicSNR(var(y(idsVoice)), var(y(idsBackG)));
    fullSNR(i,:) = [A,B, C];
end
% -------------------------------------------------------------------------
save('Audios_data_v0.mat','fullList','fullVAD',...
                     'fullSNR','-v7.3');
% -------------------------------------------------------------------------