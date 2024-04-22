function [Data_hxey,Data_hyex] = GatherData(station_id,pick_storm,period_index,coherence_threshold)
Data_hxey = zeros(0,5);
Data_hyex = zeros(0,5);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = ReadSignal(station_id);
if pick_storm == 1
    [p,sig,t,s_hx,s_hy,s_ex,s_ey] = GetEMChannel(pick_storm,1,NonstormEMsignals,StormEMsignal);
    [score_hxey,score_hyex] = Calculatescore(period_index,sig,s_ex,t,p);
    [hx_use,hy_use,ex_use,ey_use,score_use_hxey,score_use_hyex] = SelectSignalByScore(coherence_threshold,period_index,s_hx,s_hy,s_ex,s_ey,score_hxey,score_hyex);
    Data_hxey = cat(2,real(hx_use),imag(hx_use),real(ey_use),imag(ey_use),score_use_hxey);
    Data_hyex = cat(2,real(hy_use),imag(hy_use),real(ex_use),imag(ex_use),score_use_hyex);
elseif pick_storm == 0
    for i =1:length(Nonstormtimes)
        nonstorm_index = i;
        [p,sig,t,s_hx,s_hy,s_ex,s_ey] = GetEMChannel(pick_storm,i,NonstormEMsignals,StormEMsignal);
        [score_hxey,score_hyex] = Calculatescore(period_index,sig,s_ex,t,p);
        [hx_use,hy_use,ex_use,ey_use,score_use_hxey,score_use_hyex] = SelectSignalByScore(coherence_threshold,period_index,s_hx,s_hy,s_ex,s_ey,score_hxey,score_hyex);
        Data_hxey_one = cat(2,real(hx_use),imag(hx_use),real(ey_use),imag(ey_use),score_use_hxey);
        Data_hyex_one = cat(2,real(hy_use),imag(hy_use),real(ex_use),imag(ex_use),score_use_hyex);
        Data_hxey = cat(1,Data_hxey,Data_hxey_one);
        Data_hyex = cat(1,Data_hyex,Data_hyex_one);
    end
end

