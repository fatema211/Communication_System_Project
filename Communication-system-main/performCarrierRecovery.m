function [theta1, theta2,f_0] = performCarrierRecovery(r, t, carrierFreq, params)
 
    f_0 = carrierFreq; 
    % Unpack parameters from the struct for readability
    [fl, ff, fa, mu1, mu2] = deal(params.fl, params.ff, params.fa, params.mu1, params.mu2);

    % Initialize variables for the Costas loops
    theta1 = zeros(1, length(t));
    theta2 = zeros(1, length(t));
    % Initialize delay registers for the Costas loop
    zs1 = zeros(1, fl+1);
    zc1 = zeros(1, fl+1);
    zs2 = zeros(1, fl+1);
    zc2 = zeros(1, fl+1);

    % Design a FIR filter based on the specified parameters
    h = firpm(fl, ff, fa);

    % Main loop for carrier recovery using double Costas loops
    for k = 1:length(t) - 1
        % First Costas loop
        zs1 = [zs1(2:fl+1), 2 * r(k) * sin(2 * pi * f_0 * t(k) + theta1(k))];
        zc1 = [zc1(2:fl+1), 2 * r(k) * cos(2 * pi * f_0 * t(k) + theta1(k))];
        lpfs1 = fliplr(h) * zs1';
        lpfc1 = fliplr(h) * zc1';
        theta1(k+1) = theta1(k) - mu1 * lpfs1 * lpfc1;
    
        % Second Costas loop
        zs2 = [zs2(2:fl+1), 2 * r(k) * sin(2 * pi * f_0 * t(k) + theta1(k) + theta2(k))];
        zc2 = [zc2(2:fl+1), 2 * r(k) * cos(2 * pi * f_0 * t(k) + theta1(k) + theta2(k))];
        lpfs2 = fliplr(h) * zs2';
        lpfc2 = fliplr(h) * zc2';
        theta2(k+1) = theta2(k) - mu2 * lpfs2 * lpfc2;
    end
end
