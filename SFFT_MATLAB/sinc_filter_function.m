function y = sinc_filter(x, varargin)

    p = inputParser;
    addParameter(p, 'fc', 0.5, @isscalar);
    addParameter(p, 'tolerance', 1e-12, @isscalar);
    parse(p, varargin{:});
    
    fc = p.Results.fc;

    y = zeros(size(x));
    idx = abs(x) > tol;
    
    y(idx) = sin(2*pi*fc*x(idx)) ./ (pi * 2 * fc * x(idx));
    y(~idx) = 1;
end