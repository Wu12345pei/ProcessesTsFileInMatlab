function [PD_E_beta,PD_H_beta] = CalculatePolarization(Hx,Hy,Ex,Ey,timepoint,timelist)
%% timelist 代表 需要计算极化的时间点
%% timestart 给出了开始时间

%% 对应于每个timelist的点，可以计算出相对开始点的位置
%% 取附近的点，计算极化，作为对应点的极化状态
position_list = findposition(timepoint,timelist);
window_half_length = (position_list(1));

for i = 1:length(position_list)
    start = position_list(i) - window_half_length + 1;
    endding = position_list(i) + window_half_length;
    if endding > length(Ey)
        endding = length(Ey);
    end
    
    Ex_cal = Ex(start:endding);
    Ey_cal = Ey(start:endding);
    Hx_cal = Hx(start:endding);
    Hy_cal = Hy(start:endding);

    pow_ExEy(i) = mean(Ex_cal.*conj(Ey_cal)); 
    pow_ExEx(i) = mean(Ex_cal.*conj(Ex_cal)); 
    pow_EyEy(i) = mean(Ey_cal.*conj(Ey_cal)); 
    pow_HxHy(i) = mean(Hx_cal.*conj(Hy_cal));
    pow_HxHx(i) = mean(Hx_cal.*conj(Hx_cal));
    pow_HyHy(i) = mean(Hy_cal.*conj(Hy_cal));
end

PD_E_beta = atan(2*real(pow_ExEy./ (pow_ExEx-pow_EyEy)));
PD_H_beta = atan(2*real(pow_HxHy./ (pow_HxHx-pow_HyHy)));
end

