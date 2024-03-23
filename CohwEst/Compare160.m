load('goodZ160.mat')
bias0 = b0_list - good160Z;
biasm = bm_list - good160Z;
biasi = bi_list - good160Z;
plot(abs(bias0./good160Z));
hold on;
plot(abs(biasm./good160Z));
hold on;
plot(abs(biasi./good160Z));
hold on;
legend('OLS','Mestimator','WcohMestimator','Fontsize',15)