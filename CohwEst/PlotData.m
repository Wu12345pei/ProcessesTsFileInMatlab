color_score = score_use;
%color_score = X(:,1)./M';

scatter(X(:,1),X(:,2),[],color_score,"filled");
b=colorbar();
ylabel(b,'Wavelet Coherence')
xlabel('Hy in frequency domain')
ylabel('Ex in frequency domain')