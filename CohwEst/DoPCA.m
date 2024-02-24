    run("SelectSignalByScore.m");
    [coeff, ~,~,~,explained,~] = pca(X);
    X1 = X * coeff(:,1); 
    X2 = X * coeff(:,2);