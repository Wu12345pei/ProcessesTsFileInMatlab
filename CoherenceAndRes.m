addpath("CalculateZ")
addpath("DataProcess")
addpath("ReadData")
addpath("Plotter")
addpath("test")

[pos, Time, EMsignal] = TsReaderFunc(145);
[Nonstormtimes, Stormtime, NonstormEMsignals, StormEMsignal] = StormDataExtractor(Time, EMsignal);

% Stormsignal-->stft-->plot Ex(omiga);Hy(omiga)-->colored by its wavelet coherence
sampling_freq = 0.2;
test_sig = StormEMsignal;
[s_hy,~,~] = stft(test_sig(:,2),sampling_freq); 
[s_ex,f,t] = stft(test_sig(:,4),sampling_freq);

f = f(size(f,1)/2+1:end);
p = 1./f;
s_hy = s_hy(size(s_hy,1)/2+1:end,:);
s_ex = s_ex(size(s_ex,1)/2+1:end,:);

[wcoh,period,~] = WaveletCoherence(test_sig, 'Hy', 'Ex');
index = 5;
p(index)
[~,period_row] = min(abs(seconds(period) - p(index)));

score = zeros(size(s_ex,2),1);
colorlist = zeros(size(s_ex,2),3);
for i = 1:length(score)
    row = period_row;
    if i>=2
        column_begin = round(t(i-1)/5);
    else
        column_begin =1;
    end
    column_end = round(t(i)/5);
    score(i) = mean(wcoh(row,column_begin:column_end));
    if score(i)<0.5
        colorlist(i,:) = [0,0,0];
    elseif score(i)<0.7
        colorlist(i,:) = [1,1,0];
    else
        colorlist(i,:) = [1,0,0];
    end
end

begin = 0.4;
endding = 0.96;
relres_list = zeros(length(begin:0.01:endding),1);
for s = begin:0.01:endding
    l = find(score>s);
    score = score(l);
    X = [abs(s_hy(3,l)); abs(s_ex(3,l))]';
    [coeff, ~,~,~,explained,~] = pca(X);
    X1 = X * coeff(:,1); 
    X2 = X * coeff(:,2);
    [b,~,relres] = lsqr(X(:,1),X(:,2));
    relres_list(round((s-begin)/0.01)+1) = relres; 
end
scatter(begin:0.01:endding,relres_list,5,'blue','filled');
plot(begin:0.01:endding,relres_list,'b');
ylim([0 1]);
% figure(1)
% scatter(X(:,1),X(:,2),[],score,"filled");
% b=colorbar();
% ylabel(b,'Wavelet Coherence')
% xlabel('Hy in frequency domain')
% ylabel('Ex in frequency domain')
% figure(2)
% bar({'PC1','PC2'},explained)
% ylim([0 100]);
% ylabel('Explained ratio');
% figure(3)
% subplot(2,2,1)
% scatter(X1,X1,5,'filled');
% subplot(2,2,2)
% scatter(X2,X1,5,'filled');
% subplot(2,2,3)
% scatter(X1,X2,5,"filled");
% subplot(2,2,4)
% scatter(X2,X2,5,'filled');



%想法：对数据直接傅里叶变换发现小波相关和点的线性关系并没有直观的展现
%高小波相关和磁暴时期剧烈变换时段吻合，可以将这部分点可视化


%弄清楚：阻抗的计算过程
%弄清楚：马氏距离和点的自动化挑选
