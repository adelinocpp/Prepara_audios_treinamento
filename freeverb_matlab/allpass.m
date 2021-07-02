function [out,buff,idx] = allpass(buff,idx,in)

feedback = 0.5;

len = length(buff);
bufout = buff(idx);
out = -1*in + bufout;
buff(idx) = in + (bufout*feedback);

if ((idx + 1) > len)
    idx = 1;
else
    idx = idx + 1;
end





