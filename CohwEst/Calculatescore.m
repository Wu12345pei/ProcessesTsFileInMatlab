function[score_hxey,score_hyex] = Calculatescore(p_index,sig,s_ex,t,p)
    
    [wcoh,~,period,~] = WaveletCoherence(sig, 'Hy', 'Ex');
    [~,period_row] = min(abs(seconds(period) - p(p_index)));
    score_hyex = zeros(size(s_ex,2),1);
    for i = 1:length(score_hyex)
        row = period_row;
        if i>=2
            column_begin = round(t(i-1)/5);
        else
            column_begin =1;
        end
        column_end = round(t(i)/5);
        score_hyex(i) = mean(wcoh(row,column_begin:column_end));
    end
    
    [wcoh,~,period,~] = WaveletCoherence(sig, 'Hx', 'Ey');
    [~,period_row] = min(abs(seconds(period) - p(p_index)));
    score_hxey = zeros(size(s_ex,2),1);
    for i = 1:length(score_hxey)
        row = period_row;
        if i>=2
            column_begin = round(t(i-1)/5);
        else
            column_begin =1;
        end
        column_end = round(t(i)/5);
        score_hxey(i) = mean(wcoh(row,column_begin:column_end));
    end
end