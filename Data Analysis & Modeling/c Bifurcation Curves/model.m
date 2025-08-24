function dstate = model(t, state, A, B, g, alpha_func)
    % This function defines the system of ordinary differential equations.
    % It takes time t, state vector, and parameters as input.
    
    A1 = state(1);
    A2 = state(2);
    
    % The time-dependent parameter 'alpha':
    alpha = alpha_func(t);
    
    % Differential equations:
    dA1dt = A * (1 - alpha) * A1 - A1^3 - g * A2^2 * A1;
    dA2dt = B * alpha * A2 - A2^3 - g * A1^2 * A2;
    
    dstate = [dA1dt; dA2dt];
end