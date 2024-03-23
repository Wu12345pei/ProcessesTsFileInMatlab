% 对每个频率，计算
errorbar(p_list,b0_list,b0err_list)
hold on;
errorbar(p_list,bm_list,bmerr_list)
hold on;
errorbar(p_list,bi_list,bierr_list)  
legend('OLS','Mestimator','WcohMestimator','Fontsize',15)
xlabel('Periods(s)','FontSize',20)
ylabel('Z Amp(mv/km/nT)','FontSize',20)
title(strcat(num2str(station_id),'  Ifstorm',num2str(pick_storm)),"FontSize",20)