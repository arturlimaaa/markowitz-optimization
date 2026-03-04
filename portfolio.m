prices = xlsread("stock_price_data.xlsx");
prices_2024 = prices(1:252, :);    % jan 2024 - dec 2024
prices_0201_0125 = prices(22:272, :); % feb 2024 - jan 2025
prices_0301_0225 = prices(42:291, :); % mar 2024 - feb 2025
prices_0401_0325 = prices(62:312, :); % apr 2024 - mar 2025
prices_0501_0425 = prices(84:333, :); % may 2024 - apr 2025
prices_0603_0530 = prices(106:354, :); % jun 2024 - may 2025
prices_0701_0630 = prices(125:374, :); % jul 2024 - jun 2025
prices_0801_0731 = prices(147:396, :); % aug 2024 - jul 2025
prices_0903_0829 = prices(169:417, :); % sep 2024 - aug 2025
prices_1001_0930 = prices(189:438, :); % oct 2024 - sep 2025
prices_1101_1031 = prices(212:461, :); % nov 2024 - oct 2025
prices_1202_1128 = prices(232:480, :); % dec 2024 - nov 2025
prices_2025 = prices(253:502, :);    % jan 2025 - dec 2025

jan_returns = (prices_0201_0125(end, :) ./ prices_2024(end, :)) - 1;
feb_returns = (prices_0301_0225(end, :) ./ prices_0201_0125(end, :)) - 1;
mar_returns = (prices_0401_0325(end, :) ./ prices_0301_0225(end, :)) - 1;
apr_returns = (prices_0501_0425(end, :) ./ prices_0401_0325(end, :)) - 1;
may_returns = (prices_0603_0530(end, :) ./ prices_0501_0425(end, :)) - 1;
jun_returns = (prices_0701_0630(end, :) ./ prices_0603_0530(end, :)) - 1;
jul_returns = (prices_0801_0731(end, :) ./ prices_0701_0630(end, :)) - 1;
aug_returns = (prices_0903_0829(end, :) ./ prices_0801_0731(end, :)) - 1;
sep_returns = (prices_1001_0930(end, :) ./ prices_0903_0829(end, :)) - 1;
oct_returns = (prices_1101_1031(end, :) ./ prices_1001_0930(end, :)) - 1;
nov_returns = (prices_1202_1128(end, :) ./ prices_1101_1031(end, :)) - 1;
dec_returns = (prices_2025(end, :) ./ prices_1202_1128(end, :)) - 1;

% now we need to calculate the weights iteratively for each year window
% defined above

returns = price2ret(prices_2024);
[numDays, numStocks] = size(prices_2024);

Omega = cov(returns);

Omega = Omega * numDays;

mu = numDays * mean(returns);

% target portfolio return
mu_p = 0.34;

fun = @(x) x'*Omega*x;

weights0 = ones(numStocks, 1) * (1/numStocks);

A = [];
b = [];

Aeq = [ones(1, numStocks); mu];
beq = [1; mu_p];

% inequality constraints for bounds on weights
ub = ones(1, numStocks)*0.25; % lower number forces more diversification
lb = ones(1, numStocks)*-0.1; % setting this to zero gets rid of shorting

[weights, varP] = fmincon(fun, weights0, A, b, Aeq, beq, lb, ub)

% 
% % Plotting efficient frontier
% v = 0:0.01:0.40;                 % target portfolio returns
% varP_vec   = nan(size(v));       % store optimal variances
% W          = nan(numStocks, numel(v)); % store weights (optional)
% exitflags  = nan(size(v));       % store solver status (optional)
% 
% fun = @(x) x' * Omega * x;
% 
% A = [];
% b = [];
% 
% opts = optimoptions('fmincon', ...
%     'Algorithm','sqp', ...
%     'Display','none', ...
%     'MaxIterations', 2000, ...
%     'OptimalityTolerance', 1e-9, ...
%     'StepTolerance', 1e-12);
% 
% for k = 1:numel(v)
%     mu_p = v(k);
% 
%     Aeq = [ones(1, numStocks); mu];   % sum(w)=1 and mu*w = mu_p
%     beq = [1; mu_p];
% 
%     [w_k, varP_k, exitflag] = fmincon(fun, weights0, A, b, Aeq, beq, lb, ub, [], opts);
% 
%     exitflags(k) = exitflag;
%     if exitflag > 0
%         W(:,k) = w_k;
%         varP_vec(k) = varP_k;
%     end
% end
% 
% rf = 0.04;   % intercept at (0, 0.04)
% 
% % keep only feasible frontier points
% valid = ~isnan(varP_vec) & (varP_vec > 0) & (v > rf);
% 
% % slope of line from (0, rf) to each frontier point in (variance, return) space
% slopes = (v(valid) - rf) ./ varP_vec(valid);
% 
% % choose the (positive) tangent line as the max slope
% [~, j] = max(slopes);
% idxAll = find(valid);
% idx = idxAll(j);
% 
% m = (v(idx) - rf) / varP_vec(idx);     % positive slope
% 
% % build the tangent line
% xMax  = 1.05 * max(varP_vec(valid));
% xLine = linspace(0, xMax, 300);
% yLine = rf + m * xLine;
% 
% % Plot frontier + tangent line
% figure;
% plot(varP_vec, v, 'o-'); hold on;
% plot(xLine, yLine, 'LineWidth', 2);
% plot(varP_vec(idx), v(idx), 'ks', 'MarkerFaceColor', 'k'); % tangency point
% plot(0, rf, 'kd', 'MarkerFaceColor', 'k');                 % (0, rf)
% grid on;
% xlabel('Minimum portfolio variance (varP)');
% ylabel('Target expected return (\mu_p)');
% title('Efficient Frontier with Tangent Line through (0, r_f)');
% legend('Efficient frontier', 'Tangent line', 'Tangency portfolio', '(0, r_f)', ...
%        'Location', 'best');
% 
% % Plot: target return vs optimal variance
% figure;
% plot(varP_vec, v, 'o-');
% grid on;
% xlabel('Minimum portfolio variance (varP)');
% ylabel('Target expected return (\mu_p)');
% title('Efficient Frontier (Return vs Variance)');
