close all; clearvars; clc;
% -------------------------------------------------------------------------
addpath('/media/adelino/SMAUG/Verificacao_Locutor_SPAV/Bibliotecas/s2nr')
addpath('/media/adelino/SMAUG/Verificacao_Locutor_SPAV/Bibliotecas/apstools')
% -------------------------------------------------------------------------
load('Audios_data_v0.mat');
% -------------------------------------------------------------------------
SNR_target = [12, 15, 18, 21, 24];
DIR_NOISE   = 'RUIDOS/';
DIR_OUT     = 'ZZ_treinamento/';
% -------------------------------------------------------------------------
listNOISE = lista_conteudo_pasta(DIR_NOISE,{'.wav'});
VAR_NOISE = zeros(length(listNOISE),1);
for k = 1:length(listNOISE)
    [y, fs] = audioread([DIR_NOISE,listNOISE{k}]);
    VAR_NOISE(k) = var(y);
end
% -------------------------------------------------------------------------
idxK = 1;
for k = 1:length(fullList)
    SNR_RAW  = fullSNR(k);
    SNR_File = round(SNR_RAW);
    idx = find((SNR_RAW - SNR_target) > 1);
    fileBasic = fullList{k};
    [y, fs] = audioread(fileBasic);
    fileInfo = split(fileBasic,'/');
    newFileBasic = sprintf('%04i_%03i_SNR_%03i_%s',idxK,k,SNR_File,fileInfo{2});
    audiowrite([DIR_OUT,newFileBasic],y,fs);
    idxK = idxK + 1;    
    S0 = fullSNR(k,2);
    N0 = fullSNR(k,3);
    lenY = length(y);
    for i = 1:length(idx)
        Gs = 10^(SNR_target(i)/10);
        for n = 1:length(VAR_NOISE)
            yn = audioread([DIR_NOISE,listNOISE{n}]);
            lenYn = length(yn);
            nRep = ceil(lenY/lenYn);
            yn = repmat(yn,nRep,1);
            N1 = VAR_NOISE(n);
            alfa = (S0 - N0*Gs)/(N1*(Gs-1));
            yc = y + sqrt(alfa)*yn(1:lenY);
            yc = yc./max(abs(yc));
            newFileBasic = sprintf('%04i_%03i_SNR_%03i_NT_%02i_%s',idxK,k,SNR_target(i),n,fileInfo{2});
            audiowrite([DIR_OUT,newFileBasic],yc,fs);
            idxK = idxK + 1;
        end
    end
end
