score = zeros(size(s_ex,2),1);
for i = 1:length(score)
    row = period_row;
    if i>=2
        column_begin = round(t(i-1)/5);
    else
        column_begin =1;
    end
    column_end = round(t(i)/5);
    score(i) = mean(wcoh(row,column_begin:column_end));
end