fname = 'kap03/kap160as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);

fname = 'kap03/kap163as.ts';
[pos_ref, Time_ref, EMsigal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsigal_ref{1});
period_list = [100 500 1000];
pernum = length(period_list);
    
len = 81;
rho_xy = zeros(len, pernum);
rho_yx = zeros(len, pernum);
err_yx = zeros(len, pernum);
err_xy = zeros(len, pernum);
length_list = zeros(len, pernum);

for i = 1:pernum
    periods_for_cal = [period_list(i) 10000];
    freq = 1./periods_for_cal;
    
    cut_length = 200 * periods_for_cal(1);
    
    for index = 1 : len
        Signaltime = [Stormtime(1) + 5*round((index-1)/(len-1)*(Stormtime(2) - Stormtime(1) ...
            - cut_length)/5) Stormtime(1) + 5*round((index-1)/(len-1)*(Stormtime(2) - Stormtime(1) ...
            - cut_length)/5) + cut_length];
        startline = (Signaltime(1) - Stormtime(1))/5 + 1;
        endline = (Signaltime(2) - Signaltime(1))/5 + startline;
        EMsignal = StormEMsignal(startline:endline, :);
        Signalset = SignalSetTransformer(Signaltime, EMsignal);
    
        [Impedance, period_cal] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref, freq);
        imp = double(Impedance.impedance);
        err = double(Impedance.error);
        
        rho_yx(index, i) = 0.2 * periods_for_cal(1)* abs(imp(1, 2, 1));
        rho_xy(index, i) = 0.2 * periods_for_cal(1)* abs(imp(1, 1, 2));
        
        err_yx(index, i) = 0.2 * periods_for_cal(1)* err(1, 2, 1)^2;
        err_xy(index, i) = 0.2 * periods_for_cal(1)* err(1, 1, 2)^2;
        l = (Signaltime(2) - Signaltime(1))/period_cal(1);
        length_list(index, i) = l;
    end
end

for j = 1: pernum
    subplot(pernum,1,j)
    m = median(rho_yx(:,j),"omitmissing");
    histfit(rho_yx(:,j)/m,20,'kernel')
    xlim([0.9 1.1])
end
% figure(1)
% scatter(length_list,err_xy ./ rho_xy)
% xscale('log')
% yscale('log')
% hold on;