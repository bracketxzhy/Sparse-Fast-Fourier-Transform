function y = permute_sfft(x, sigma, tau, varargin)

    p = inputParser;
    addParameter(p, 'direction', 'forward', @ischar);
    parse(p, varargin{:});
    
    n = length(x);
    
    if strcmp(p.Results.direction, 'forward')
        indices = mod((0:n-1)*sigma + tau, n) + 1;
    else
        if gcd(sigma, n) ~= 1
            error('The reverse permutation requires that sigma and n be coprime.');
        end
        sigma_inv = mod_inverse(sigma, n);
        indices = mod(sigma_inv * ((0:n-1) - tau), n) + 1;
    end
    
    y = x(indices);
end

function inv = mod_inverse(a, n)
    [g, x, ~] = gcd(a, n);
    if g ~= 1
        error('There is no modular inverse.');
    end
    inv = mod(x, n);
end