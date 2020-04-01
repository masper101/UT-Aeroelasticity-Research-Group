function A = Afilt(fvec)

Ra = fun_Ra(fvec);
A = 20*log10(Ra) - 20*log10(fun_Ra(1000));

function Ra = fun_Ra(f)
Ra = (12194^2 * f.^4) ./ ((f.^2 + 20.6^2) .* (f.^2 + 12194^2) .* sqrt((f.^2 + 107.7^2) .* (f.^2 + 737.9^2)));
Ra(f>20000) = nan;
end
end
