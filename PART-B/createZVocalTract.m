% This function creates the V(z) of the vocal tract and uses the impulse
% response instead of the reverse z-transform, which is complicated in our
% situation.

% INPUT: F - vector with the basic frequencies of the phoneme
% OUPUT: V - vocal tract as a discrete-time signal

function [ V, enum, denom] = createZVocalTract(F)

    syms z
    Fs = 10000;
    Ts = 1/Fs;
    sigma_k = 30;


    a = -2*exp(-2*pi*sigma_k*Ts);
    b = cos(2*pi*F(1)*Ts);
    c = exp(-4*pi*sigma_k*Ts);
    d = cos(2*pi*F(2)*Ts);
    e = cos(2*pi*F(3)*Ts);

    enum = 1;
    denom = [1, a*(b+d+e), (a^2)*(b*d+b*e+d*e) + 3*c, (a^3)*b*d*e + 2*a*c*(b+d+e), (a^2)*c*(b*d + b*e + d*e)+ 3*c^2, a*c^2*(b+d+e), c^3];
    V = impz(1,denom);
    
end
