function F = obj_Ar(x11,T,F,x_init,T1, ComponentSelector, OptTypeSelector, w, f, M, sus, a, b, d)
% 960906 Code Readed
x = T * (F .* x_init + T1*x11');

r_1 = x(1:3);
r_2 = x(4:6);
r_3 = x(7:9);

b_1 = [0 -r_1(3) r_1(2) ; r_1(3) 0 -r_1(1) ; -r_1(2) r_1(1) 0];       %Cross Product Matrix For Mount 1
b_2 = [0 -r_2(3) r_2(2) ; r_2(3) 0 -r_2(1) ; -r_2(2) r_2(1) 0];
b_3 = [0 -r_3(3) r_3(2) ; r_3(3) 0 -r_3(1) ; -r_3(2) r_3(1) 0];

R_1 = sus.E_cm + r_1;
R_2 = sus.E_cm + r_2;
R_3 = sus.E_cm + r_3;

B_1 = [0 -R_1(3) R_1(2) ; R_1(3) 0 -R_1(1) ; -R_1(2) R_1(1) 0];       %Cross Product Matrix For Mount 1
B_2 = [0 -R_2(3) R_2(2) ; R_2(3) 0 -R_2(1) ; -R_2(2) R_2(1) 0];
B_3 = [0 -R_3(3) R_3(2) ; R_3(3) 0 -R_3(1) ; -R_3(2) R_3(1) 0];

[M_v,C_v,K_v] = BodyParameters(x,sus,M);

A = 0; E = 0; D = 0;
lng = length(w);

for i = 1:lng
    q_hat = (-w(i)^2*M_v+1i*w(i)*C_v+K_v)^(-1)*[zeros(11,1); f(i);0;0];
    
    % Temp_A = ComponentSelector.*[abs((-w(i)^2*([zeros(1,4) 1 zeros(1,8)]-[zeros(1,6) R_1(1) zeros(1,6)]+[zeros(1,5) R_1(2) zeros(1,7)])*q_hat)/...
    %                                                                 (-w(i)^2*([zeros(1,9) 1 zeros(1,3)]-[zeros(1,11) r_1(1) zeros(1,1)]+[zeros(1,10) r_1(2) zeros(1,2)])*q_hat)); ...
    %                                                         abs((-w(i)^2*([zeros(1,4) 1 zeros(1,8)]-[zeros(1,6) R_2(1) zeros(1,6)]+[zeros(1,5) R_2(2) zeros(1,7)])*q_hat)/...
    %                                                                 (-w(i)^2*([zeros(1,9) 1 zeros(1,3)]-[zeros(1,11) r_2(1) zeros(1,1)]+[zeros(1,10) r_2(2) zeros(1,2)])*q_hat));...
    %                                                         abs((-w(i)^2*([zeros(1,4) 1 zeros(1,8)]-[zeros(1,6) R_3(1) zeros(1,6)]+[zeros(1,5) R_3(2) zeros(1,7)])*q_hat)/...
    %                                                                 (-w(i)^2*([zeros(1,9) 1 zeros(1,3)]-[zeros(1,11) r_3(1) zeros(1,1)]+[zeros(1,10) r_3(2) zeros(1,2)])*q_hat))];
    
    aE_1 = [eye(3) b_1']*q_hat(8:13);
    aB_1 = [eye(3) B_1']*[0;0;q_hat(5:7);0];
    aE_2 = [eye(3) b_2']*q_hat(8:13);
    aB_2 = [eye(3) B_2']*[0;0;q_hat(5:7);0];
    aE_3 = [eye(3) b_3']*q_hat(8:13);
    aB_3 = [eye(3) B_3']*[0;0;q_hat(5:7);0];
    
    Temp_A = ComponentSelector.*[abs(aE_1(1)/aB_1(1)) abs(aE_1(2)/aB_1(2)) abs(aE_1(3)/aB_1(3)) abs(aE_1)/abs(aB_1);
                                                            abs(aE_2(1)/aB_2(1)) abs(aE_2(2)/aB_2(2)) abs(aE_2(3)/aB_2(3)) abs(aE_2)/abs(aB_2);
                                                            abs(aE_3(1)/aB_3(1)) abs(aE_3(2)/aB_3(2)) abs(aE_3(3)/aB_3(3)) abs(aE_3)/abs(aB_3)];
    
    Temp_A = OptTypeSelector * [max(max(Temp_A)); sum(sum(Temp_A))];
    A = A + Temp_A;
    
    [K,~] = stiff_cal(x,i);
    KEF = KEF_cal(K,M_e(1:6,1:6));
    
    for j = 1:6
        E = E + (100-max(KEF(:,j)))^2;
        %     E = E + heaviside(max(KEF(:,j))-85)^2;           % Must be changed
    end
    
    % f_nat_lb = 1.05*[7;7;9;11;11;0];
    % f_nat_ub = 0.95*[100;100;11;14;14;18];
    f_nat = NF_Calculator(x,M_e(1:6,1:6));
    
    for j = 1:6
        P_low = heaviside(f_nat_lb(j)-f_nat(j))*(f_nat_lb(j)-f_nat(j));
        P_High = heaviside(f_nat(j)-f_nat_ub(j))*(f_nat(j)-f_nat_ub(j));
        D = D + P_low + P_High;
    end
    
end

F = a*A + b*E + d*D;