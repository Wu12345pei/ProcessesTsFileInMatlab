[wcoh,wcs,period,~] = WaveletCoherence(test_sig, 'Hy', 'Ex');
[~,period_row] = min(abs(seconds(period) - p(index)));
