[y, z, origin] = GridGenerator(logspace(1, 4, 20), 1470.766*1000);
rho = zeros(length(y),length(z))+100;
write_mackie2d_model('test.rho',y,z,rho,'LINEAR');

[pos_ref1, Time_ref1, EMsigal_ref1] = TsReaderFunc('kap03/kap163as.ts');
Signalset_ref1 = SignalSetTransformer(Time_ref1(1,:), EMsigal_ref1{1});
[pos_ref2, Time_ref2, EMsigal_ref2] = TsReaderFunc('kap03/kap136as.ts');
Signalset_ref2 = SignalSetTransformer(Time_ref2(1,:), EMsigal_ref2{1});

[pos_ref_nonstorm, Time_ref_nonstorm, EMsigal_ref_nonstorm] = TsReaderFunc('kap03/kap175as.ts');
Signalset_ref_nonstorm1 = SignalSetTransformer(Time_ref_nonstorm(2,:), EMsigal_ref_nonstorm{2});
[pos_ref_nonstorm2, Time_ref_nonstorm2, EMsigal_ref_nonstorm2] = TsReaderFunc('kap03/kap169as.ts');
Signalset_ref_nonstorm2 = SignalSetTransformer(Time_ref_nonstorm2(1,:), EMsigal_ref_nonstorm2{1});

n_station = 21;
DatHeaderWritter('StormdataTE.dat',20,n_station,'TE_Impedance');
DatHeaderWritter('StormdataTM.dat',20,n_station,'TM_Impedance');

for id = 103:175
    if exist(strcat('kap03/kap',num2str(id),'as.ts'),'file') && id~=151 && id~=118
        fname = strcat('kap03/kap',num2str(id),'as.ts')
        [pos, Time, EMsignal] = TsReaderFunc(fname);
        [Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);
        if ~isempty(StormEMsignal)
            Signalset = SignalSetTransformer(Stormtime, StormEMsignal);
            Signalset_ref_forcal1 = Signalset_ref1;
            Signalset_ref_forcal2 = Signalset_ref2;
        else
            Signalset = SignalSetTransformer(Time(1,:), EMsignal{1});
            Signalset_ref_forcal1 = Signalset_ref_nonstorm1;
            Signalset_ref_forcal2 = Signalset_ref_nonstorm2;
        end
            if id<152
                [Impedance,periods] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref_forcal1);
            elseif id>152
                [Impedance,periods] = ImpedanceCalculaterBIRRP(Signalset, Signalset_ref_forcal2);
            end
            imp = double(Impedance.impedance);
            err = double(Impedance.error);
            xyz_position = PositionTransformer(pos,origin);
            DatDataWriter('StormdataTE.dat', periods, num2str(id), 0, 0, xyz_position,'TE', imp, err);
            DatDataWriter('StormdataTM.dat', periods, num2str(id), 0, 0, xyz_position,'TM', imp, err);
    end
end

copyfile('StormdataTE.dat','Stormdata.dat');
lines = readlines('StormdataTM.dat');
fid = fopen('Stormdata.dat','a');
for i = 1:length(lines)
    fprintf(fid,lines(i,1));
    fprintf(fid,'\n');
end
fclose(fid);

