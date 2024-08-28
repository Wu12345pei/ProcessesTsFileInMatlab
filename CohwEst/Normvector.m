function [r] = Normvector(X,a,b)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
r = sqrt(X(:,a).^2+X(:,b).^2);
end

