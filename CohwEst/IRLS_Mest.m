function[z,eps_real,eps_imag] = IRLS_Mest(data)
    h_real = data(:,1);
    h_imag = data(:,2);

    e_vector = zeros(2*length(h_real),1);
    b_matrix = zeros(2*length(h_real),2);
    
    for i = 1:length(h_real)
        row = 2*i;
        b_matrix(row-1,:) = [h_real(i), -h_imag(i)];
        b_matrix(row,:) = [h_imag(i), h_real(i)];
        e_vector(row-1,:) = data(i,3);
        e_vector(row,:) = data(i,4);
    end

    max_it = 80;
    residual = zeros(2*length(h_real),1);
    vid = [];
    goodpoint = [];
    for it = 1:max_it
        weight = Huber(it,residual);
        z = (b_matrix'*weight*b_matrix)^(-1)*(b_matrix'*weight*e_vector);
        residual = e_vector - b_matrix*z;
        if it == max_it - 1
            for id = 1:length(weight)
                if weight(id,id)>1e-4
                    vid = cat(1,vid,[id]);
                end
                if weight(id,id)==1
                    goodpoint = cat(1,goodpoint,[id]);
                end
            end
        end
    end
    
    eps = residual;
    eps_real = eps(mod((1:length(eps)),2)==0);
    eps_imag = eps(mod((1:length(eps)),2)==1);
end
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
    weight = diag(weight);
end

function [scale] = scale_mad(residual)
    med = median(residual);
    dev = abs(residual - med);
    mad = median(dev);
    scale = mad / 0.44845;
end