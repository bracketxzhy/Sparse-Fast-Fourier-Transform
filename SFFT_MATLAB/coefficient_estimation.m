function X_estimated = estimation_loop(L, x, B, win, freq_indices, sigma, tau)
    
    n = length(x);
    num_freqs = length(freq_indices);
    
    G = fft(win) / length(win);

    X_all = zeros(L, num_freqs);
    
    for r = 1:L
        y = permute_sfft(x, sigma(r), tau(r)) .* win;

        Z = sub_fft(y, B);

        for i = 1:num_freqs
            f = freq_indices(i);

            h = mod(round(sigma(r) * f * B / n), B) + 1;

            o = sigma(r) * f - round(sigma(r) * f * B / n) * n / B;
            o = mod(round(o), n);

            phase_comp = exp(2j*pi*tau(r)*f/n);

            X_all(r, i) = Z(h) * phase_comp / G(o+1);
        end
    end

    X_estimated = median(X_all, 1)';
end