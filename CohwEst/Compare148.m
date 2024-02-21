load('goodZ148.mat')
bias0 = b0_list - good148Z;
biasm = bm_list - good148Z;
biasi = bi_list - good148Z;
plot(abs(bias0./good148Z));
hold on;
plot(abs(biasm./good148Z));
hold on;
plot(abs(biasi./good148Z));
hold on;
legend('OLS','Mestimator','WcohMestimator','Fontsize',15)