function [C] = convolutionFunc(A,B)
%CONVOLUTIONFUNC 此处显示有关此函数的摘要
%   此处显示详细说明
C = conv(A,B);
L = length(C) - length(A);
C = C(L/2+1:end-L/2);
end

