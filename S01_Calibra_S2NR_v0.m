close all; clearvars; clc;
% -------------------------------------------------------------------------
addpath('/media/adelino/SMAUG/Verificacao_Locutor_SPAV/Bibliotecas/s2nr')
% -------------------------------------------------------------------------
load('Audios_data_v0.mat');

% 'VAD_GSM','VAD_PDR','VAD_QST','SNR_GSM','SNR_PDR','SNR_QST'
% -------------------------------------------------------------------------
S2NR = struct;
NFFT   = 1024;      % fft window size 
RTH    = 0.6;       % reliability threshold
sigma  = 0.1;       % image segmentation threshold
X = [NFFT; RTH; sigma; 1; 1; 1; 1; 1; 1];
timeStep    = 0.01;
timeWin     = 0.025;
% -------------------------------------------------------------------------
nEpocs = 10;
EQM     = zeros(nEpocs,1);
stdEQM  = zeros(nEpocs,1);
F_1 = 0;
F_2 = 0;
MU = 1;
X_1 = X;
Jg = [-1;1;-1;1;-1;1];
Dk = eye(9);
alfa = 0.01;
Kval = length(fullList);
vec_eqmByFile = zeros(Kval,1);
cellEQM = cell(nEpocs,1);
for nE = 1:nEpocs
    for k = 1:Kval
        [y, fs] = audioread(fullList{k});
        [~,~,S2NRk] = s2nr_function(y , fs, timeWin, timeStep,...
                X(1) , X(2), X(3));        
        vec_eqmByFile(k) = (fullSNR(k) - S2NRk)^2;
        F = (1/Kval)*(fullSNR(k) - S2NRk)^2 + ...
            X(4)*(128 - X(1)) + X(5)*(X(1) - 4096) + X(6)*(0.001 - X(2)) + ...
            X(7)*(X(2) - 1) + X(8)*(0.001 - X(3)) + X(9)*(X(3) - 1);
        F_2 = F_1;
        F_1 = F;
        if (k == 2)
            gk = (F_1 - F)./(2*(X_1 - X));
        end
        if (k > 3)
            gk_1 = gk;
            gk = (F_2 - F)./(2*(X_2 - X));
            dK = -Dk*gk;
            X = X + alfa*dK;
            rk = gk - gk_1;
            vk = X - X_1;
            C_DFP = vk*vk'/(vk'*rk) - Dk*rk*rk'*Dk/(rk'*Dk*rk);
            C_BFGS = (1 + (rk'*Dk*rk)/(rk'*vk)) - (vk&rk'*Dk + Dk*rk*vk')/(rk'*vk);
            Ck = 0.5*(C_DFP + C_BFGS);
            Dk = Dk+Ck;
        else
            X_2 = X_1 + alfa*X_1;
            X_1 = X + alfa*X;
        end
    end
    stdEQM(k)   = std(vec_eqmByFile);
    EQM(k)      = mean(vec_eqmByFile);
    cellEQM{k} = vec_eqmByFile;
end
figure, plot(EQM,'ko-.')
grid on;
save('Opt_Data.mat','X','EQM','stdEQM','cellEQM','-v7.3')
% -------------------------------------------------------------------------