function [] = DatDataWriter(fname, period, station_id, Lat, Lon, pos, imp_type, imp, err)
%DATDATAWRITER 此处显示有关此函数的摘要
%   此处显示详细说明
if(~exist('Lat','var'))
    Lat = '0.000'; 
end
if(~exist('Lon','var'))
    Lon = '0.000'; 
end
fid = fopen(fname,"a");
for i = 1:length(period)
    if err(i,1,2)<10 && err(i,2,1)<10
        fprintf(fid, '%12.6E ', period(i)); 
        fprintf(fid, '%s %8.3f %8.3f ', station_id, Lat, Lon);
        fprintf(fid, '%12.3f %12.3f %7.3f ', pos(1), pos(2), pos(3)); % receiver x,y,z
        if imp_type == 'TE'
            fprintf(fid, '%s %15.6E %15.6E %15.6E\n', imp_type, real(imp(i,1,2)), imag(imp(i,1,2)), max([err(i,1,2),0.01*abs(imp(i,1,2))])); % data
        end

        if imp_type == 'TM'
            fprintf(fid, '%s %15.6E %15.6E %15.6E\n', imp_type, real(imp(i,2,1)), imag(imp(i,2,1)), max([err(i,2,1),0.01*abs(imp(i,2,1))])); % data
        end
    end
end

