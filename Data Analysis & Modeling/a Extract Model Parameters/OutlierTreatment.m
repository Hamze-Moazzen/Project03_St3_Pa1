function y = OutlierTreatment(x)
% find the extreme outliers in a vector and treat them

Q1 = quantile(x,0.25); % first quartile
Q3 = quantile(x,0.75); % third quartile

IQR = Q3-Q1; % Inter-quartile range

lb = Q1-1.5*IQR; % lower bound
ub = Q3+1.5*IQR; % upper bound

y = x;

% outliers less than lb:
y(x<lb) = lb;

% outliers greater than up:
y(x>ub) = ub;

end