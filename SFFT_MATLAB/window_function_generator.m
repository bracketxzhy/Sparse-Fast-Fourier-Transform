function g = window_generator(B, n, varargin)

    p = inputParser;
    addParameter(p, 'type', 'gaussian_sinc', @ischar);
    addParameter(p, 'symmetric', true, @islogical);
    parse(p, varargin{:});

    w = min(n, floor(B * log2(n) * 1.5));
    if p.Results.symmetric && mod(w, 2) == 0
        w = w + 1;  
    end

    t = (-(w-1)/2 : (w-1)/2)';

    switch lower(p.Results.type)
        case 'gaussian_sinc'
            sigma = B * sqrt(log2(n)) / 2.5;
            gauss = exp(-0.5 * (t/sigma).^2);
            
            fc = 1/(2*B);
            sinc_win = sinc_filter(t, 'fc', fc);
            
            g_short = gauss .* sinc_win;
            
        case 'gaussian'
            sigma = B * sqrt(log2(n)) / 2.5;
            g_short = exp(-0.5 * (t/sigma).^2);
            
        case 'hamming'
            g_short = 0.54 - 0.46*cos(2*pi*(0:w-1)'/(w-1));
            
        otherwise
            error('Unknown window type');
    end

    g_short = g_short / max(g_short);

    g = zeros(n, 1);
    center_idx = ceil(n/2);
    start_idx = center_idx - floor(w/2);
    end_idx = start_idx + w - 1;
    
    g(start_idx:end_idx) = g_short;
end