function [SNR, S0, N] = basicSNR(S,N)
K = (10*log10(S)+120)/(10*log10(N)+120);
Mn = 10*log10(S)+120;
N0 = 10^(Mn/10);
SNR = 10*log10(N0^(K-1) -1);
SNR_d = 10^(SNR/10);
S0 = SNR_d*N;