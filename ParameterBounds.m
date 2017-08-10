%% Lower and upper bounds for design variables %%

%% Lower Bounds for Positions %%
lb_r_1 = [-200 -380 -50]'*1e-3;    
lb_r_2 = [415 -390 -180]'*1e-3;
lb_r_3 = [-190 -460 -70]'*1e-3;

%% Upper Bounds for Positions %%
ub_r_1 = [250 400 215]'*1e-3;
ub_r_2 = [430 210 -170]'*1e-3;
ub_r_3 = [250 450 210]'*1e-3;

%% Lower Bounds for Orientation %%
lb_o_1 = o_1;%+[-0.1 -0.1 -0.1]'*pi/4;
lb_o_2 = o_2;%+[-0.1 -0.1 -0.1]'*pi/4;
lb_o_3 = o_3;%+[-0.1 -0.1 -0.1]'*pi/4;

%% Upper Bounds for Orientation %%
ub_o_1 = o_1;%+[0.1 0.1 0.1]'*pi/4;
ub_o_2 = o_2;%+[0.1 0.1 0.1]'*pi/4;
ub_o_3 = o_3;%+[0.1 0.1 0.1]'*pi/4;

%% Lower Bounds for Stiffness %%
lb_k_1 = [1e4 3e4 2e4]'*5;
lb_k_2 = [2e4 1e4 1.5e4]'*5;
lb_k_3 = [1e4 2e4 2e4]'*5;

%% Upper Bounds for Stiffness %%
ub_k_1 = [3e4 5e4 4e4]'*5;
ub_k_2 = [4e4 2e4 4e4]'*5;
ub_k_3 = [3e4 4e4 4e4]'*5;

%% Lower Bound for TRA frequency %%
lb_w_TRA = 2*pi*11;

%% Upper Bound for TRA frequency %%
ub_w_TRA = Inf;

%% Mode frequency bounds
f_nat_lb = [7;7;9;11;11;0];
f_nat_ub = [100;100;11;14;14;18];

%% Totally %%
lb = [lb_r_1; lb_r_2; lb_r_3; lb_o_1; lb_o_2; lb_o_3; lb_k_1; lb_k_2; lb_k_3; lb_w_TRA];
ub = [ub_r_1; ub_r_2; ub_r_3; ub_o_1; ub_o_2; ub_o_3; ub_k_1; ub_k_2; ub_k_3; ub_w_TRA];
