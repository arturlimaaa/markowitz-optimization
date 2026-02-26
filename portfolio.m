prices = xlsread("stock_price_data.xlsx");
prices = prices(1:252, :);

returns = price2ret(prices);
[numDays, numStocks] = size(prices);

Omega = cov(returns);

Omega = Omega * numDays;

mu = numDays * mean(returns);

% we can change this
% this represents the target portfolio return
mu_p = 0.20;

fun = @(x) x'*Omega*x;

weights0 = ones(numStocks, 1) * (1/numStocks);

A = [];
b = [];

Aeq = [ones(1, numStocks); mu];
beq = [1; mu_p];

% inequality constraints for bounds on weights
ub = ones(1, numStocks)*0.4; % lower number forces more diversification
lb = ones(1, numStocks)*0; % setting this to zero gets rid of shorting

[weights, varP] = fmincon(fun, weights0, A, b, Aeq, beq, lb, ub)
