function [H,lever_value_real,lever_value_imag] = CalculateHatmatrix(data)
%CALCULATEHATMATRIX 此处显示有关此函数的摘要
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
    
    b = b_matrix;
    H = b*inv(b'*b)*b';
    lever_value = diag(H);
    lever_value_real = lever_value(1:2:end)*length(h_real);
    lever_value_imag = lever_value(2:2:end)*length(h_real);
end

