begin = 0;
endding = 0.95;
relres_list = zeros(length(begin:0.01:endding),1);
R_list = zeros(length(begin:0.01:endding),1);
for s = begin:0.01:endding
    run("SelectSignalByScore.m");
    [bi,~,relres] = lsqr(X(:,1),X(:,2));
    R = corrcoef(X(:,1),X(:,2));
    relres_list(round((s-begin)/0.01)+1) = relres*norm(X(:,2))/sqrt(length(X(:,1))-1)/norm(X(:,1)); 
    R_list(round((s-begin)/0.01)+1) = R(1,2)^2;
end
scatter(begin:0.01:endding,relres_list,5,'blue','filled');
yyaxis left;
plot(begin:0.01:endding,relres_list,'b');
ylabel('Standard deviation of Z','FontSize',20)
yyaxis right; 
plot(begin:0.01:endding,R_list,'r');
xlabel('WaveletCoherence','FontSize',20);
ylabel('coefficient','FontSize',20)