function [Median] = WeightedMedian(A,weight)
%WEIGHTEDMEDIAN 此处显示有关此函数的摘要
%   此处显示详细说明
A(:,2) = weight;
A = sortrows(A);
S = sum(A(:,2));
A(:,2) = A(:,2) ./ S;
p=0;
for i = 1:length(A)
    p = p + A(i,2);
    if p>=0.5
        break
    end
end
Median = A(i,1);
if p == 0.5
    Median = (A(i,1)+A(i+1,1))/2
end
