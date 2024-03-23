color_score = score_use;
%color_score = X(:,1)./M';
P = X;
P(:,1) = normalize(X(:,1));
P(:,2) = normalize(X(:,2));
P(:,3) = normalize(X(:,3));


% scatter3(P(:,1),P(:,2),P(:,3),[],color_score,"filled");
scatter(X(:,1),X(:,2),[],color_score,"filled");
b=colorbar();
ylabel(b,'Wavelet Coherence')
xlabel('Hy in frequency domain')
ylabel('Ex in frequency domain')
zlabel('k in frequency domain')