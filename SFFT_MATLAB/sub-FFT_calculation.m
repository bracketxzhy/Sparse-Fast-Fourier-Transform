function f = sub_fft(x, B, varargin)

    p = inputParser;
    addParameter(p, 'method', 'sum', @ischar);
    addParameter(p, 'zero_padding', true, @islogical);
    parse(p, varargin{:});
    
    n = length(x);

    if mod(n, B) ~= 0
        if p.Results.zero_padding
            n_new = ceil(n/B) * B;
            x_padded = zeros(n_new, 1);
            x_padded(1:n) = x;
            x = x_padded;
            n = n_new;
        else
            error('n cannot be divided by B');
        end
    end
    
    M = n / B;

    x_reshaped = reshape(x, B, M);

    switch p.Results.method
        case 'sum'
            y = sum(x_reshaped, 2);
        case 'mean'
            y = mean(x_reshaped, 2);
        otherwise
            y = sum(x_reshaped, 2);
    end

    f = fft(y) / B;
end