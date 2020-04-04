function [unreliableDisp] = unreliableDisparities(disparityMap)
% Remove unreliable disparities from disparity map

unreliableDisp = ones(size(disparityMap));
unreliableDisp(disparityMap ~= 0) = 0;
unreliableDisp(disparityMap == -realmax('single')) = 1; 

end