function mix = freeverb(input,fs)

len = length(input);
output = zeros(len,1);

% freverb options
% combs = 8;
% allpasses = 4;
% muted = 9;
delay = ceil(0.008*fs);
fixedgain = 0.015;
proprOut = 0.5;     % Proportion of mix,  original = 0.8
% scalewet = 3;
% scaledry = 2;
% scaledamp = 0.4;
% scaleroom = 0.28;
% offsetroom= 0.7;
% initialroom = 0.5;
% initialdamp = 0.5;
% initialwet = 1/scalewet;
% initialdry = 0;
% initialwidth = 1;
% initialmode = 0;
% freezemode= 0.5;
% stereospread = 23;
% off = 0;

% lowpass-feedback-comb-filter params
lbcf = [1557 1617 1491 1422 1277 1356 1188 1116];
d = 0.2; % decay,  original = 0.2
f = 0.5; % feedback, max 0.98 for stability, original = 0.84

% allpass params
ap = [225 556 441 341]; % allpass filter frequencies
apg = 0.5;


% initialize comb filter state buffers
comb1 = zeros(lbcf(1),1);
comb2 = zeros(lbcf(2),1);
comb3 = zeros(lbcf(3),1);
comb4 = zeros(lbcf(4),1);
comb5 = zeros(lbcf(5),1);
comb6 = zeros(lbcf(6),1);
comb7 = zeros(lbcf(7),1);
comb8 = zeros(lbcf(8),1);

% initialize allpass filter state buffers
allpass1 = zeros(ap(1),1);
allpass2 = zeros(ap(2),1);
allpass3 = zeros(ap(3),1);
allpass4 = zeros(ap(4),1);

% comb filter write indices
Cidx = ones(8,1);

% comb filter filterstores
filterstore = zeros(8,1);

% allpass filter write indices
Aidx = ones(8,1);

% loop through reverberator sample by sample
for i = (1 + delay) : len

  in = input(i-delay);
  out = 0;

  % combs in parallel
  [out1,filterstore(1),comb1,Cidx(1)] = comb(comb1,Cidx(1),d,f,in,filterstore(1));
  out = out + out1;
  [out2,filterstore(2),comb2,Cidx(2)] = comb(comb2,Cidx(2),d,f,in,filterstore(2));
  out = out + out2;
  [out3,filterstore(3),comb3,Cidx(3)] = comb(comb3,Cidx(3),d,f,in,filterstore(3));
  out = out + out3;
  [out4,filterstore(4),comb4,Cidx(4)] = comb(comb4,Cidx(4),d,f,in,filterstore(4));
  out = out + out4;
  [out5,filterstore(5),comb5,Cidx(5)] = comb(comb5,Cidx(5),d,f,in,filterstore(5));
  out = out + out5;
  [out6,filterstore(6),comb6,Cidx(6)] = comb(comb6,Cidx(6),d,f,in,filterstore(6));
  out = out + out6;
  [out7,filterstore(7),comb7,Cidx(7)] = comb(comb7,Cidx(7),d,f,in,filterstore(7));
  out = out + out7;
  [out8,filterstore(8),comb8,Cidx(8)] = comb(comb8,Cidx(8),d,f,in,filterstore(8));
  out = out + out8;
  
  % allpasses in series
  [out,allpass1,Aidx(1)] = allpass(allpass1,Aidx(1),out);
  [out,allpass2,Aidx(2)] = allpass(allpass2,Aidx(2),out);
  [out,allpass3,Aidx(3)] = allpass(allpass3,Aidx(3),out);
  [out,allpass4,Aidx(4)] = allpass(allpass4,Aidx(4),out);

  % apply gain reduction  
  output(i) = out * fixedgain;

end

% output result 20/80 dry-wet mix
mix = ((1-proprOut) .* input) + (proprOut .* output);
