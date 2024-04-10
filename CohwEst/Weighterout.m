function [out] = Weighterout(A,weight)
%WEIGHTEROUT 此处显示有关此函数的摘要
%   此处显示详细说明
M1 = WeightedMedian(A,weight);
A_Res_M1 = abs(A - M1);
M2 = WeightedMedian(A_Res_M1,weight);
out = A_Res_M1>3*M2;
end

