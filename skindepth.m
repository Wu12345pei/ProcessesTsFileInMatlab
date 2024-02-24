<<<<<<< HEAD
mu = 4*pi*10^(-7);
omega_min = 2*pi*1/1200;
omega_max = 2*pi*1/1200;
rho_min = 1;
rho_max = 100;
skin_depth_min = sqrt(2*rho_min/(omega_max*mu));
skin_depth_avg = sqrt(2*100/(1000*mu))
skin_depth_max = sqrt(2*rho_max/(omega_min*mu));
=======
mu = 4*pi*10^(-7);
omega_min = 2*pi*1/1200;
omega_max = 2*pi*1/1200;
rho_min = 1;
rho_max = 100;
skin_depth_min = sqrt(2*rho_min/(omega_max*mu));
skin_depth_avg = sqrt(2*100/(1000*mu))
skin_depth_max = sqrt(2*rho_max/(omega_min*mu));
>>>>>>> 4b6c50e2f385fa5287298c4db6cb261a9dae6e24
skin_depth = [skin_depth_min skin_depth_max]/1000