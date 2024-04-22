function[z,eps_real,eps_imag] = OLS(data)
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
    z = lsqr(b_matrix,e_vector);
    eps = e_vector - b_matrix * z;
    eps_real = eps(mod((1:length(eps)),2)==0);
    eps_imag = eps(mod((1:length(eps)),2)==1);
end
