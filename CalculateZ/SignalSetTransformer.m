function [signalset] = SignalSetTransformer(Time, EMsignal)
%SIGNALSETTRANSFORMER 此处显示有关此函数的摘要
%   此处显示详细说明
Hx = py.numpy.array(EMsignal(:, 1));
Hy = py.numpy.array(EMsignal(:, 2));
Hz = py.numpy.array(EMsignal(:, 3));
Ex = py.numpy.array(EMsignal(:, 4));
Ey = py.numpy.array(EMsignal(:, 5));
dict = py.dict(bx = int8(0), by = int8(1), bz = int8(2), ex = int8(3), ey = int8(4), B = py.tuple([int8(0), int8(1)]), E = py.tuple([int8(3), int8(4)]));
channel_list = py.list({Hx, Hy, Hz, Ex, Ey});
signalset = py.razorback.SignalSet(dict, py.razorback.SyncSignal(channel_list, 0.2, Time(1)) );
end

