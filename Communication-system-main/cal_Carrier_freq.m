    function est_carrierFreq = cal_Carrier_freq(f_if, f_s)                       
                                                                       % intermediate frequency (f_if) and the sampling frequency (f_s)
    switch true
        case (f_if > f_s/2)                                           % If the intermediate frequency is greater than half the sampling frequency
            k = round(f_if / f_s);
           est_carrierFreq = abs(f_if - k * f_s); % Calculate the carrier frequency directly
        otherwise                                                     % If f_if is not greater than f_s/2, then the carrier frequency is simply the same as f_if.
           
            est_carrierFreq = f_if;                                        % Assign the carrier frequency as the intermediate frequency
    end
end
