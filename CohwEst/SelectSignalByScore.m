l = find(score>s);
score_use = score(l);
phase_use = phase(l);
X = [abs(s_hy(index,l)); abs(s_ex(index,l))]';
M = abs(s_hx(index,l));
s_time = s_time(l);