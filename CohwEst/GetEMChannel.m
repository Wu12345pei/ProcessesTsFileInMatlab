sampling_freq = 0.2;
if pick_storm == 0 
    test_sig = NonstormEMsignals{nonstorm_index};
elseif pick_storm == 1
    test_sig = StormEMsignal;
else
    test_sig = cat(1,NonstormEMsignals{1},StormEMsignal);
end
[s_hy,~,~] = stft(test_sig(:,2),sampling_freq,"Window",hann(512,"periodic")); 
[s_hx,~,~] = stft(test_sig(:,1),sampling_freq,"Window",hann(512,"periodic")); 
[s_ex,f,t] = stft(test_sig(:,4),sampling_freq,"Window",hann(512,"periodic"));

f = f(size(f,1)/2+1:end);
p = 1./f;
s_hy = s_hy(size(s_hy,1)/2+1:end,:);
s_hx = s_hx(size(s_hx,1)/2+1:end,:);
s_ex = s_ex(size(s_ex,1)/2+1:end,:);
s_time = 1:length(s_ex);
s_time = s_time';
