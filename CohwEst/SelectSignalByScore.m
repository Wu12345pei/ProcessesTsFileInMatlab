function[hx_use,hy_use,ex_use,ey_use,score_use_hxey,score_use_hyex] = SelectSignalByScore(s,p_index,s_hx,s_hy,s_ex,s_ey,score_hxey,score_hyex)

l_hxey = find(score_hxey>s);
l_hyex = find(score_hyex>s);

score_use_hxey = score_hxey(l_hxey);
score_use_hyex = score_hyex(l_hyex);
hx_use=s_hx(p_index,l_hxey)';
hy_use=s_hy(p_index,l_hyex)';
ex_use=s_ex(p_index,l_hyex)';
ey_use=s_ey(p_index,l_hxey)';
end


