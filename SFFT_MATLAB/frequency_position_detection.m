function [candidate_freqs, info] = location_loop(L, x, B, win, k, sigma, tau, varargin)
% 频率位置检测循环
%
% 输入参数：
%   L - 循环次数
%   x - 输入信号
%   B - 哈希桶大小
%   win - 窗函数
%   k - 稀疏度
%   sigma - 缩放因子向量
%   tau - 平移因子向量
%   varargin - 可选参数
%
% 输出参数：
%   candidate_freqs - 候选频率（每个循环的检测结果）
%   info - 检测信息

    % 参数解析
    p = inputParser;
    addParameter(p, 'parallel', false, @islogical);
    addParameter(p, 'oversampling', 1.5, @isscalar);
    addParameter(p, 'verbose', false, @islogical);
    parse(p, varargin{:});
    
    n = length(x);
    candidate_freqs = cell(L, 1);
    energies = cell(L, 1);
    
    if p.Results.parallel && L > 1
        if p.Results.verbose, fprintf('Utilize parallel computing...\n'); end
        parfor r = 1:L
            [candidate_freqs{r}, energies{r}] = single_location_detection(...
                x, B, win, k, sigma(r), tau(r), p.Results.oversampling);
        end
    else
        for r = 1:L
            [candidate_freqs{r}, energies{r}] = single_location_detection(...
                x, B, win, k, sigma(r), tau(r), p.Results.oversampling);
            
            if p.Results.verbose && mod(r, ceil(L/10)) == 0
                fprintf('  Position detection progress: %d/%d\n', r, L);
            end
        end
    end
    
    info = struct();
    info.num_candidates = cellfun(@length, candidate_freqs);
    info.avg_candidates = mean(info.num_candidates);
end

function [freqs, energy] = single_location_detection(x, B, win, k, sigma, tau, oversampling)
    
    n = length(x);
    
    y = permute_sfft(x, sigma, tau) .* win;
    
    Z = sub_fft(y, B);
    energy = abs(Z).^2;
    
    num_select = ceil(oversampling * k);
    [~, sorted_idx] = sort(energy, 'descend');
    selected_buckets = sorted_idx(1:min(num_select, B));
    
    freq_indices = 0:n-1;
    hash_values = mod(round(sigma * freq_indices * B / n), B) + 1;
    
    is_member = ismember(hash_values, selected_buckets);
    freqs = freq_indices(is_member);
end