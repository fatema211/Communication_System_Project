
function [Ts, M, t ] = calculateReceivedParams(f_s, r, T_t)

Ts = 1 / f_s;                   % Calculates the sampling period based on the sampling frequency.
M = T_t * f_s;                  % Calculates the oversampling factor by multiplying symbol time and sampling frequency.
    
t= 0:Ts:Ts*(length(r)-Ts); % Generates a time vector from 0 to the duration of the signal, 
                            % using the sampling period Ts. The length(r) 
                            % represents the number of samples in the signal
end

