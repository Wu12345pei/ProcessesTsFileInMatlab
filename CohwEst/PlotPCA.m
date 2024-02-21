% figure(1)
% scatter(X(:,1),X(:,2),[],score_use,"filled");
% b=colorbar();
% ylabel(b,'Wavelet Coherence')
% xlabel('Hy in frequency domain')
% ylabel('Ex in frequency domain')
figure(2)
bar({'PC1','PC2'},explained)
ylim([0 100]);
ylabel('Explained ratio');
% figure(3)
% subplot(2,2,1)
% scatter(X1,X1,5,'filled');
% subplot(2,2,2)
% scatter(X2,X1,5,'filled');
% subplot(2,2,3)
% scatter(X1,X2,5,"filled");
% subplot(2,2,4)
% scatter(X2,X2,5,'filled');
