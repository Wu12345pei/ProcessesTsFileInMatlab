max_it = 80;
residual = zeros(length(X(:,1)),1);
vid = [];
goodpoint = [];
for it = 1:max_it
    weight = Huber(it,residual);
    bm = dot(X(:,2).*weight,X(:,1))/dot(X(:,1).*weight,X(:,1));
    residual = X(:,2) - X(:,1)*bm;
    if it == max_it - 1
        for id = 1:length(weight)
            if weight(id)>1e-4
                vid = cat(1,vid,[id]);
            end
            if weight(id)==1
                goodpoint = cat(1,goodpoint,[id]);
            end
        end
    end
end

N = length(vid);
Bmatrix = sqrt(1/dot(X(vid,1),X(vid,1)'));
Res = norm(X(vid,2)-bm*X(vid,1));
weightcoeff = 1/length(goodpoint);

errorm = sqrt(N-1)/N*Res*Bmatrix*weightcoeff;
% choose weight
function [weight] = Huber(it,residual)
    if it == 1
        weight = ones(length(residual),1);
    else
        x = abs(residual);
        scale = scale_mad(x);
        alph = 1.5;
        weight = (alph * scale) ./ x;
        for i = 1:length(weight)
            weight(i) = min([1,weight(i)]);
        end
    end
end

function [scale] = scale_mad(residual)
    med = median(residual);
    dev = abs(residual - med);
    mad = median(dev);
    scale = mad / 0.44845;
end