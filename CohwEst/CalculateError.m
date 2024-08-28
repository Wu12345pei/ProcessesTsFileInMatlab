function [err] = CalculateError(e,h,z,len_vid)
%CALCULATEERROR 此处显示有关此函数的摘要
% 自由度n，参数个数p，数据点N
% n = 2*N，p = 2(二维情况)
% 输入参数H，设计矩阵（H'H）-1
% r = E - ZH(待议)

%calculate diag element (H'H)-1
n = length(e);
iiinv = sqrt(abs(diag(inv(h'*h))));
res = norm (e - h*z);
r = sqrt(n -2)/n;
err = (res / r / len_vid) * iiinv;
end

