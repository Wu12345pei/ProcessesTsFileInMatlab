function [Impedance, periods] = ImpedanceCalculaterBIRRP(local_EMsignal_set, reference_EMsignal_set, freq)
%IMPEDANCECALCULATER 此处显示有关此函数的摘要
%   此处显示详细说明
dict = py.dict(bx_ref = int8(0), by_ref = int8(1), bz_ref = int8(2), ex_ref = int8(3), ey_ref = int8(4), Bremote = py.tuple([int8(0), int8(1)]));
reference_EMsignal_set.tags = dict;
signalset_for_calculate = local_EMsignal_set.merge(reference_EMsignal_set);

if(~exist('freq','var'))
    periods = py.numpy.logspace(1, 4, int8(20));
    freq = 1 / periods;  
end

freq = py.numpy.array(freq)
periods = double(1/freq);
Impedance = py.razorback.utils.impedance(signalset_for_calculate, freq, ...
    remote='Bremote',weights = py.razorback.weights.mest_weights, ...
    fourier_opts=py.dict( Nper= 8,  overlap= 0.71));
end

