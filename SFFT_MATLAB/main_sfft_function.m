function [X, freq_indices, info] = sfft_main(x, k, varargin)

    p = inputParser;
    addRequired(p, 'x', @isvector);
    addRequired(p, 'k', @isscalar);
    addParameter(p, 'B', [], @isscalar);
    addParameter(p, 'L', [], @isscalar);
    addParameter(p, 'window_type', 'gaussian_sinc', @ischar);
    addParameter(p, 'voting_threshold', 0.5, @isscalar);
    addParameter(p, 'parallel', false, @islogical);
    addParameter(p, 'verbose', true, @islogical);
    parse(p, x, k, varargin{:});
    
    x = x(:); 
    n = length(x);

    if isempty(p.Results.B)
        B = min(2*k, n/4);
    else
        B = p.Results.B;
    end
    
    if isempty(p.Results.L)
        L = max(5, ceil(5*log2(n)));
    else
        L = p.Results.L;
    end
    
    if k > n
        error('The sparsity k cannot exceed the signal length n.');
    end
    
    info = struct();
    info.n = n;
    info.k = k;
    info.B = B;
    info.L = L;
    info.window_type = p.Results.window_type;
    info.start_time = datetime();
    
    if p.Results.verbose
        fprintf('Starting sFFT calculation...\n');
        fprintf('Signal length: %d, Sparsity: %d\n', n, k);
        fprintf('Hash bucket size: %d, Number of iterations: %d\n', B, L);
    end
    
    if p.Results.verbose, fprintf('Generate random parameters...\n'); end
    [sigma, tau] = generate_hash_parameters(n, L);
    
    if p.Results.verbose, fprintf('Generate window function...\n'); end
    win = window_generator(B, n, p.Results.window_type);
    
    if p.Results.verbose, fprintf('Frequency position detection...\n'); end
    tic;
    [candidate_freqs, detection_info] = location_loop(L, x, B, win, k, sigma, tau, ...
        'parallel', p.Results.parallel, 'verbose', p.Results.verbose);
    info.detection_time = toc;
    
    if p.Results.verbose, fprintf('Frequency filtering...\n'); end
    freq_indices = vote_and_select_frequencies(candidate_freqs, L, ...
        p.Results.voting_threshold, k);
    
    if p.Results.verbose, fprintf('Coefficient estimation...\n'); end
    tic;
    X_estimated = estimation_loop(L, x, B, win, freq_indices, sigma, tau);
    info.estimation_time = toc;

    X = zeros(n, 1);
    X(freq_indices + 1) = X_estimated;  % MATLAB索引从1开始

    info.total_time = info.detection_time + info.estimation_time;
    info.end_time = datetime();
    info.num_detected = length(freq_indices);
    info.detection_info = detection_info;
    
    if p.Results.verbose
        fprintf('sFFT calculation completed\n');
        fprintf('Detected %d frequencies\n', length(freq_indices));
        fprintf('Total calculation time: %.4f seconds\n', info.total_time);
    end
end

function [sigma, tau] = generate_hash_parameters(n, L)
    sigma = zeros(L, 1);
    tau = randi([0, n-1], L, 1);
    
    for r = 1:L
        while true
            s = randi([1, n/2]) * 2 - 1;  % 生成奇数
            if gcd(s, n) == 1
                sigma(r) = s;
                break;
            end
        end
    end
end

function freq_indices = vote_and_select_frequencies(candidate_freqs, L, threshold, k)
    freq_counts = containers.Map('KeyType', 'double', 'ValueType', 'double');
    
    for r = 1:L
        freqs = candidate_freqs{r};
        for i = 1:length(freqs)
            f = freqs(i);
            if isKey(freq_counts, f)
                freq_counts(f) = freq_counts(f) + 1;
            else
                freq_counts(f) = 1;
            end
        end
    end
    
    all_freqs = keys(freq_counts);
    all_counts = values(freq_counts);
    vote_ratios = [all_counts{:}] / L;
    
    selected_mask = vote_ratios >= threshold;
    selected_freqs = cell2mat(all_freqs(selected_mask));
    
    if length(selected_freqs) > k
        selected_ratios = vote_ratios(selected_mask);
        [~, sort_idx] = sort(selected_ratios, 'descend');
        selected_freqs = selected_freqs(sort_idx(1:k));
    end
    
    freq_indices = selected_freqs(:);
end