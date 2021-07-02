function out = saturate(y,percSD)

minY = min(y);
maxY = max(y);
avgY = mean(y);
stdY = std(y);
lenY = length(y);
percS = sum((y >= 1) || (y <= -1))/lenY;

if (percSD < percS)
    out = y;
    return
end
