clear all; clc;

%Define global variables
global id

%Define constraints & Initialization
iter_max = 1;
u_SW_max = 540;
u_SW_min = -540;
LTR_max = 1;
LTR_min = -1;
sampling_step_size = 0.01;
cst_input_init = 0;
t_p = 0;
t_i = 1;
t_f = 3;
tspan = [t_p t_f];
J = [];
terminate = 0;
color = 'g-';

T = [tspan(1):sampling_step_size:tspan(2)]';

figure(1); hold on
plot(T, 0.*T + u_SW_max, 'k--', 'LineWidth', 3);
plot(T, 0.*T + u_SW_min, 'k--', 'LineWidth', 3);
xlabel('t [s]');
ylabel('u_{SW} [deg]');

figure (2); hold on
xlabel('t [s]');
ylabel('Tire Vertical Load');

figure(3); hold on
plot(T, 0.*T + LTR_max, 'k--', 'LineWidth', 3);
plot(T, 0.*T + LTR_min, 'k--', 'LineWidth', 3);
xlabel('iteration');
ylabel('Load Transfer Ratio J');


%Control Initial guess
u_SW = cst_input_init.*zeros(size(T));

for iter = 1:iter_max
    fprintf('iter = %i\n', iter);
    
    %Nominal State Trajectory
    options = simset('SrcWorkspace','current'); 
    sim('Rollover_Driver',tspan,options);
    x1 = interp1(u.Time, u.Data, T);
    x2 = interp1(v.Time, v.Data, T);
    x3 = interp1(r.Time, r.Data, T);
    x4 = interp1(p.Time, p.Data, T);
    x5 = interp1(phi.Time, phi.Data, T);
    x6 = interp1(F_z_L1.Time, F_z_L1.Data, T);
    x7 = interp1(F_z_L2.Time, F_z_L2.Data, T);
    x8 = interp1(F_z_R1.Time, F_z_R1.Data, T);
    x9 = interp1(F_z_R2.Time, F_z_R2.Data, T);
    u_ref = interp1(u_SW_ref.Time, u_SW_ref.Data, T);
    if u_SW ~= u_ref
       fprintf("input steering wheel angle doesn't match monitered value"); 
    end
    x = [x1 x2 x3 x4 x5 x6 x7 x8 x9];
    
    %Cost Evaluation
    K = (x(end, 8) + x(end, 9) - x(end, 6) - x(end, 7))/(x(end, 8) + x(end, 9) + x(end, 6) + x(end, 7));
    J = [J K];
    plot(iter, K, 'b.', 'MarkerSize', 12);
    
    if K < -1
       terminate = 1;
       color = 'b-';
    end
    
    %plot current input
    figure(1); hold on
    plot(T, u_SW, color, 'LineWidth', 1);
    
    %plot current state trajectories
    figure(2); hold on
    plot(T, x6, 'g-', 'LineWidth', 1);
    hold on
    plot(T, x7, 'r-', 'LineWidth', 1);
    hold on
    plot(T, x8, 'm-', 'LineWidth', 1);
    hold on
    plot(T, x9, 'y-', 'LineWidth', 1);
    
    if terminate == 1
       break; 
    end
    
    %System Identification
    id = 0;
    x_id = cell(18, 1);
    dxdt_id = cell(18, 1);
    for id = 1 : 18
         T_0 = [t_p: sampling_step_size: t_i];
         T_1 = [t_i: sampling_step_size: t_f];
         u_SW_id = 
    end
    
end