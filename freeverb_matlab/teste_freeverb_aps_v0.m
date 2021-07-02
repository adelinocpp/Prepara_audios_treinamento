close all; clearvars; clc;

file = '../QST_debug/Rapahel_QST.wav';
[y,fs] = audioread(file);
out = freeverb(y,fs);