% f -- feedback
% d -- damping
function [out,filterstore,buff,idx] = comb(buff,idx,d,feedback,input,filterstore)

len = length(buff);
out = buff(idx);
filterstore = (out*(1-d)) + (filterstore*d);
buff(idx) = input + (filterstore*feedback);

% circularly wrap index
if ((idx + 1) > len)
    idx = 1;
else
    idx = idx + 1;
end

