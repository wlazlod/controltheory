function [ u ] = trap( t, r1, r2 )
    u = t;
    for i=1:length(t)
        if ((t(i)>0) && (t(i)<r1/r2))
            u(i) = r2*t(i);
        elseif (t(i)>= r1/r2)
            u(i) = r1;
        else
            u(i) = 0;
        end
    end
end

