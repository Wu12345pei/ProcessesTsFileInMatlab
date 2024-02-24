<<<<<<< HEAD
fname = 'kap03/kap160as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);

fname = 'kap03/kap163as.ts';
[pos_ref, Time_ref, EMsigal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsigal_ref{1});
period_list = logspace(2,4,20);
    
len = 21;
rho_xy = zeros(len, 20);
rho_yx = zeros(len, 20);
err_yx = zeros(len, 20);
err_xy = zeros(len, 20);
length_list = zeros(len, 20);

for i = 1:20
    periods_for_cal = [period_list(i) 10000];
    freq = 1./periods_for_cal;

    gap = 2000;
    
    for cut_length = 0 : gap : (len-1)*3000
        index = cut_length / gap + 1;
        Signaltime = [Stormtime(1)+cut_length Stormtime(2)];
        EMsignal = StormEMsignal(round(cut_length/5)+1:end, :);
        Signalset = SignalSetTransformer(Signaltime, EMsignal);
    
        [Impedance, period_cal] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref, freq);
        imp = double(Impedance.impedance);
        err = double(Impedance.error);
        
        rho_yx(index, i) = 0.2 * periods_for_cal(1)* abs(imp(1, 2, 1))^2;
        rho_xy(index, i) = 0.2 * periods_for_cal(1)* abs(imp(1, 1, 2))^2;
        
        err_yx(index, i) = 0.2 * periods_for_cal(1)* err(1, 2, 1)^2;
        err_xy(index, i) = 0.2 * periods_for_cal(1)* err(1, 1, 2)^2;
        l = (Signaltime(2) - Signaltime(1))/period_cal(1);
        length_list(index, i) = l;
    end
end
xx = reshape(length_list, [1 size(length_list,1)*size(length_list,2)]);
yy = reshape(rho_xy(:,:)./rho_xy(1,:), [1 size(rho_xy,1)*size(rho_xy,2)]);
xx(isnan(yy)) = [];
yy(isnan(yy)) = [];
figure(1)
scatter(xx, yy,'.')
xscale('log')
yline(1.03,'r')
yline(0.97,'r')
xlabel('N times of T',FontSize=20)
ylabel('Rho_xy/Rho_xy0',FontSize=20)
hold on;
% figure(1)
% scatter(length_list,err_xy ./ rho_xy)
% xscale('log')
% yscale('log')
=======
fname = 'kap03/kap160as.ts';
[pos, Time, EMsignal] = TsReaderFunc(fname);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);

fname = 'kap03/kap163as.ts';
[pos_ref, Time_ref, EMsigal_ref] = TsReaderFunc(fname);
Signalset_ref = SignalSetTransformer(Time_ref(1,:),EMsigal_ref{1});
period_list = logspace(2,4,20);
    
len = 21;
rho_xy = zeros(len, 20);
rho_yx = zeros(len, 20);
err_yx = zeros(len, 20);
err_xy = zeros(len, 20);
length_list = zeros(len, 20);

for i = 1:20
    periods_for_cal = [period_list(i) 10000];
    freq = 1./periods_for_cal;

    gap = 2000;
    
    for cut_length = 0 : gap : (len-1)*3000
        index = cut_length / gap + 1;
        Signaltime = [Stormtime(1)+cut_length Stormtime(2)];
        EMsignal = StormEMsignal(round(cut_length/5)+1:end, :);
        Signalset = SignalSetTransformer(Signaltime, EMsignal);
    
        [Impedance, period_cal] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref, freq);
        imp = double(Impedance.impedance);
        err = double(Impedance.error);
        
        rho_yx(index, i) = 0.2 * periods_for_cal(1)* abs(imp(1, 2, 1))^2;
        rho_xy(index, i) = 0.2 * periods_for_cal(1)* abs(imp(1, 1, 2))^2;
        
        err_yx(index, i) = 0.2 * periods_for_cal(1)* err(1, 2, 1)^2;
        err_xy(index, i) = 0.2 * periods_for_cal(1)* err(1, 1, 2)^2;
        l = (Signaltime(2) - Signaltime(1))/period_cal(1);
        length_list(index, i) = l;
    end
end
xx = reshape(length_list, [1 size(length_list,1)*size(length_list,2)]);
yy = reshape(rho_xy(:,:)./rho_xy(1,:), [1 size(rho_xy,1)*size(rho_xy,2)]);
xx(isnan(yy)) = [];
yy(isnan(yy)) = [];
figure(1)
scatter(xx, yy,'.')
xscale('log')
yline(1.03,'r')
yline(0.97,'r')
xlabel('N times of T',FontSize=20)
ylabel('Rho_xy/Rho_xy0',FontSize=20)
hold on;
% figure(1)
% scatter(length_list,err_xy ./ rho_xy)
% xscale('log')
% yscale('log')
>>>>>>> 4b6c50e2f385fa5287298c4db6cb261a9dae6e24
% hold on;