function [Data_hxey,Data_hyex,p,stft_t_gap] = GatherData(station_id,pick_storm,period_index,coherence_threshold)
Data_hxey = zeros(0,5);
Data_hyex = zeros(0,5);
T_list_hxey = zeros(0,1);
T_list_hyex = zeros(0,1);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = ReadSignal(station_id);
if pick_storm == 1
    Time_begin = Stormtime(1);
    [p,sig,t,s_hx,s_hy,s_ex,s_ey] = GetEMChannel(pick_storm,1,NonstormEMsignals,StormEMsignal);
    [score_hxey,score_hyex] = Calculatescore(period_index,sig,s_ex,t,p);
    [hx_use,hy_use,ex_use,ey_use,score_use_hxey,score_use_hyex,t_hxey,t_hyex] = SelectSignalByScore(coherence_threshold,period_index,s_hx,s_hy,s_ex,s_ey,score_hxey,score_hyex,t,Time_begin);
    Data_hxey = cat(2,real(hx_use),imag(hx_use),real(ey_use),imag(ey_use),score_use_hxey);
    Data_hyex = cat(2,real(hy_use),imag(hy_use),real(ex_use),imag(ex_use),score_use_hyex);
    T_list_hxey = cat(1,T_list_hxey,t_hxey);
    T_list_hyex = cat(1,T_list_hyex,t_hyex);
elseif pick_storm == 0
    for i =1:length(Nonstormtimes)
        nonstorm_index = i;
        Time_begin = Nonstormtimes(nonstorm_index,1);
        [p,sig,t,s_hx,s_hy,s_ex,s_ey] = GetEMChannel(pick_storm,nonstorm_index,NonstormEMsignals,StormEMsignal);
        [score_hxey,score_hyex] = Calculatescore(period_index,sig,s_ex,t,p);
        [hx_use,hy_use,ex_use,ey_use,score_use_hxey,score_use_hyex,t_hxey,t_hyex] = SelectSignalByScore(coherence_threshold,period_index,s_hx,s_hy,s_ex,s_ey,score_hxey,score_hyex,t,Time_begin);
        Data_hxey_one = cat(2,real(hx_use),imag(hx_use),real(ey_use),imag(ey_use),score_use_hxey);
        Data_hyex_one = cat(2,real(hy_use),imag(hy_use),real(ex_use),imag(ex_use),score_use_hyex);
        Data_hxey = cat(1,Data_hxey,Data_hxey_one);
        Data_hyex = cat(1,Data_hyex,Data_hyex_one);
        T_list_hxey = cat(1,T_list_hxey,t_hxey);
        T_list_hyex = cat(1,T_list_hyex,t_hyex);
    end
end
stft_t_gap = t(2) - t(1);
Data_hxey(:,6) = sqrt(Data_hxey(:,3).^2 + Data_hxey(:,4).^2)./sqrt(Data_hxey(:,1).^2 + Data_hxey(:,1).^2);
Data_hxey(:,7) = angle((Data_hxey(:,3)+1i*Data_hxey(:,4))./(Data_hxey(:,1)+1i*Data_hxey(:,2)));
Data_hyex(:,6) = sqrt(Data_hyex(:,3).^2 + Data_hyex(:,4).^2)./sqrt(Data_hyex(:,1).^2 + Data_hyex(:,1).^2);
Data_hyex(:,7) = angle((Data_hyex(:,3)+1i*Data_hyex(:,4))./(Data_hyex(:,1)+1i*Data_hyex(:,2)));
Data_hxey(:,8) = T_list_hxey;
Data_hyex(:,8) = T_list_hyex;
end
