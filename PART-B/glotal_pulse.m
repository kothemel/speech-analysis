function y = glotal_pulse(n)

    if (n>=0) && (n<=24)
        y = 0.5*(1-cos(pi*(n+1)/25));
    elseif (n>=25 && n<=33)
        y = cos(0.5*pi*(n-24)/10);
    else
        y = 0;
    end  
end