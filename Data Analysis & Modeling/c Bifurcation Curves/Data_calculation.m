
% orthogonal:
% alpha1_scaled = 0.6158; % descending
% alpha2_scaled = 0.6630; % ascending

% oblique:
alpha1_scaled = 0.4828; % descending
alpha2_scaled = 0.5383; % ascending


tmp_Gamma = (alpha1_scaled*alpha2_scaled)/((1-alpha1_scaled)*(1-alpha2_scaled));
tmp_G     = (alpha1_scaled/alpha2_scaled)*((1-alpha1_scaled)/(1-alpha2_scaled));

Gamma = sqrt(tmp_Gamma)     % preference parameter
G     = sqrt(tmp_G)         % the degree of mutual inhibition