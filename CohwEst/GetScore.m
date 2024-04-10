score = zeros(size(s_ex,2),1);
phase = zeros(size(s_ex,2),1);
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
%     score(i) = abs(s_ex(index,i)*conj(s_hy(index,i)))/abs(s_ex(index,i))/abs(s_hy(index,i));
    phase(i) = mean(angle(wcs(row,column_begin:column_end)));
    if score(i)<0.5
        colorlist(i,:) = [0,0,0];
    elseif score(i)<0.7
        colorlist(i,:) = [1,1,0];
    else
        colorlist(i,:) = [1,0,0];
    end
end