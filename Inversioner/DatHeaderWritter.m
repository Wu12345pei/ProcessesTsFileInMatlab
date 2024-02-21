function [] = DatHeaderWritter(fname,n_period, n_station, imp_type, unit, orientation, origin)
%DATWRITTER 此处显示有关此函数的摘要
%   此处显示详细说明
if(~exist('imp_type','var'))
    imp_type = 'TE_Impedance'; 
end
if(~exist('unit','var'))
    unit = '[mV/km]/[nT]'; 
end
if(~exist('orientation','var'))
    orientation = 0; 
end
if(~exist('origin','var'))
    origin = zeros(3); 
end
fid = fopen(fname,"w");
fprintf(fid, '# Synthetic 2D MT data written in Matlab by Wuph\n');
fprintf(fid, '# Period(s) Code GG_Lat GG_Lon X(m) Y(m) Z(m) Component Real Imag Error\n');
fprintf(fid,'> %s\n',imp_type);
fprintf(fid,'> %s\n','exp(-i\omega t)');
fprintf(fid,'> %s\n',unit);
fprintf(fid,'> %.2f\n',orientation);
fprintf(fid,'> %.3f %.3f\n',origin(1:2));
fprintf(fid,'> %d %d\n',n_period,n_station);
end

