[b0,~,relres] = lsqr(X(:,1),X(:,2));
R = corrcoef(X(:,1),X(:,2));
error0 = relres*norm(X(:,2))/sqrt(length(X(:,1))-1)/norm(X(:,1));
