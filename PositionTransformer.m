function [xyz_position] = PositionTransformer(pos,origin)
%POSITIONTRANSFORMER 此处显示有关此函数的摘要
%   此处显示详细说明
lat = pos(1);
lon = pos(2);
lat0 = -32.1388893;
lon0 = 20.46750070;
x = 111.32 * (lon - lon0) * cos(lat * pi / 180);
y = 111.32 * (lat - lat0);
xyz_position = [0, sqrt(x^2+y^2)*1000+origin, 0];
end

