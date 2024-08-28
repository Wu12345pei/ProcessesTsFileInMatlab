function [f] = CalculateDistribution(xi,yi,x,y)
[f, ~, ~] = ksdensity([x y], [xi(:) yi(:)]);
f = reshape(f, size(xi,1),[]);
end

