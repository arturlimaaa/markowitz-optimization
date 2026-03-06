% Import stock price data
prices = xlsread("stock_price_data.xlsx");

% Matrix for each monthly window
windows = [1, 252;  % jan 2024 - dec 2024
          22, 272;  % feb 2024 - jan 2025
          42, 291;  % mar 2024 - feb 2025
          62, 312;  % apr 2024 - mar 2025
          84, 333;  % may 2024 - apr 2025
         106, 354;  % jun 2024 - may 2025
         125, 374;  % jul 2024 - jun 2025
         147, 396;  % aug 2024 - jul 2025
         169, 417;  % sep 2024 - aug 2025
         189, 438;  % oct 2024 - sep 2025
         212, 461;  % nov 2024 - oct 2025
         232, 480;  % dec 2024 - nov 2025
         253, 502]; % jan 2025 - dec 2025

% Weight constraints
max_weight = 0.3;
min_weight = -0.1;

% Initializing returns
returns = zeros(12,1);
overall_return = 1;

% Figure plotting
figure;
sgtitle('Efficient Frontiers (Return vs Variance) and Tangent Profiles');

for i = 1:1:12

    % Assign current prices given the iteration's window of days
    sample_prices = prices(windows(i,1):windows(i,2),:);
    
    %% Risk vs. Return and Tangent Profile
    % Create a plot of the month's risk vs. return
    [vars, mus] = risk_return(sample_prices, max_weight, min_weight, 0.1, 0.25);

    % Approximate the risk vs. return with a quadratic function using least squares
    approx = quad_approx(mus, vars);
    approx_mus = 0:0.01:0.5;
    approx_vars = zeros(size(approx_mus));
    for j = 1:length(approx_mus)
        approx_vars(j) = approx(1) + approx(2)*approx_mus(j) + approx(3)*approx_mus(j)^2;
    end

    % Create the tangent profile
    profile_x = tangent_profile(0.04, approx_2024);
    profile_y = approx(1) + approx(2)*profile_x + approx(3)*profile_x^2;
    [weights, var] = find_profile(sample_prices, profile_x, max_weight, min_weight);
    
    % Plot the risk vs. return, approximated risk vs. return, and tangent profile
    subplot(3,4,i);
    plot(vars, mus, 'o');
    hold on;
    plot(approx_vars, approx_mus, '-');
    plot(profile_y, profile_x, 'o');
    hold off;

    %% Monthly Returns with Tangent Profile
    % Project the next month's returns
    current_prices = prices(windows(i,2),:);
    future_prices = prices(windows(i+1,2),:);
    asset_returns = zeros(10,1);
    for j = 1:1:10
        asset_returns(j) = future_prices(j)/current_prices(j) - 1;

        % Multiply weights for each asset by their returns
        returns(i) = returns(i) + asset_returns(j)*weights(j);
    end
    overall_return = overall_return*(1+returns(i));
end

subplot(3,4,1)
title("January")
subplot(3,4,2)
title("February")
subplot(3,4,3)
title("March")
subplot(3,4,4)
title("April")
subplot(3,4,5)
title("May")
subplot(3,4,6)
title("June")
subplot(3,4,7)
title("July")
subplot(3,4,8)
title("August")
subplot(3,4,9)
title("September")
subplot(3,4,10)
title("October")
subplot(3,4,11)
title("November")
subplot(3,4,12)
title("December")

disp("Monthly Returns:")
disp(returns)
disp("Overall 2025 Return: " + overall_return)

%% Functions
function [variances, mu_p] = risk_return(price_window, max_weight, min_weight, min_risk, max_risk)
% Creates a set of portfolio variances within a range of expected returns

    % Assign known variables
    returns = price2ret(price_window); % Returns for each asset each day
    [days, stocks] = size(price_window); % Number of days and stocks
    Omega = days*cov(returns); % Returns covariance throughout year
    Mu = days*mean(returns); % Average returns from each asset

    % Quadratic relationship between weights and covariance
    fun = @(x) x'*Omega*x;

    % Constraints
    Aeq = [ones(1, stocks); Mu]; % Weights sum to 1
    ub = ones(1, stocks)*max_weight; % Min weights
    lb = ones(1, stocks)*min_weight; % Max weights

    % Initialize variables to iterate through
    mu_p = min_risk:0.01:max_risk; % Expected returns
    Vars = zeros(length(mu_p),1); % Variances

    w0 = ones(stocks, 1) * (1/stocks); % Initial weights for fmincon()
    for i = 1:length(mu_p)

        % Ensure the sum of weights*variances is the expected return mu_p(i)
        beq = [1; mu_p(i)];
    
        % Save weights and variance
        [weights, Vars(i)] = fmincon(fun, w0, [], [], Aeq, beq, lb, ub);
    end

    % Assign variances
    variances = Vars;
end

function x_star = quad_approx(t, s)
% Approximate a quadratic function given vectors t and s

    syms x [3 1]
    A = [ones(length(t),1), transpose(t), transpose(t).^2];
    ATA = transpose(A)*A;
    ATb = transpose(A)*s;
    sol = solve(x == ATA\ATb);
    x_star = [sol.x1; sol.x2; sol.x3];
end

function profile = tangent_profile(mu_f, cs)
% Determines the tangent profile to a quadratic risk vs. return
% relationship

    syms x
    sol = solve(cs(1) + cs(2)*x + cs(3)*x^2 == (cs(2) + 2*cs(3)*x)*(x-mu_f));
    if sol(2) > sol(1)
        profile = sol(2);
    else
        profile = sol(1);
    end
end

function [weights, vars] = find_profile(price_window, mu_p, max_weight, min_weight)

    % Assign known variables
    returns = price2ret(price_window); % Returns for each asset each day
    [days, stocks] = size(price_window); % Number of days and stocks
    Omega = days*cov(returns); % Returns covariance throughout year
    Mu = days*mean(returns); % Average returns from each asset

    % Quadratic relationship between weights and covariance
    fun = @(x) x'*Omega*x;

    % Constraints
    Aeq = [ones(1, stocks); Mu]; % Weights sum to 1
    beq = [1; double(mu_p)];
    ub = ones(1, stocks)*max_weight; % Min weights
    lb = ones(1, stocks)*min_weight; % Max weights

    w0 = ones(stocks, 1) * (1/stocks); % Initial weights for fmincon()
    [weights, vars] = fmincon(fun, w0, [], [], Aeq, beq, lb, ub);
end