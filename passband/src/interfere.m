function y = interfere(x, samples_per_period, options)
%interfere - 相干
% y = interfere(x, carrier) 将波形 x 与 carrier 倍采样率的载波相干。（初相默认为零）
% y = interfere(x, carrier, "InitialPhase", phi) 将波形 x 与 carrier 倍采样率的载波相干，载波初相为 phi。

arguments
    x(1,:)
    samples_per_period(1,1) {mustBePositive}
    options.InitialPhase(1,1) = 0.
end

% t 是旋转周数，等于 f_carrier × time。
t = (0: length(x) - 1) / samples_per_period;
carrier = cos(2 * pi * t + options.InitialPhase);

y = carrier .* x;

end