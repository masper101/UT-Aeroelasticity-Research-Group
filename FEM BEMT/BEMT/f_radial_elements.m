function [y,r,dr] = f_radial_elements(R,N,cutout)
%RADIAL LOCATIONS OF EACH ELEMENT WITH LENGTH R/N

if cutout>0
    dy = (R-R*cutout)/(N-1);
    y = R*cutout:dy:R;
else
    dy = R/N;
    y = dy:dy:R;
end

y(end) = 0.9999 * y(end);

dr = dy/R;
r = y/R;