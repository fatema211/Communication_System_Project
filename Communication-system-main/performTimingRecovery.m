function [time_recovered_signal, offsetSaves] = performTimingRecovery(out_put, SRRCLength, M)
    x_input = out_put;
    len = SRRCLength;
    m_ = M;
    tnow = len * m_ +1;
    n_ = round(length(out_put) / M);
    tau = 0; 
    sl = zeros(1, n_);
    tausave = zeros(1, n_); 
    tausave(1) = tau; 
    i = 0;
    mu = 0.1;
    delta = 0.1;

    while tnow < length(x_input) - 2 * len * m_
        i = i + 1;
        sl(i) = interpsinc(x_input, tnow + tau, len);
        x_deltap = interpsinc(x_input, tnow + tau + delta, len);
        x_deltam = interpsinc(x_input, tnow + tau - delta, len);
        dx = x_deltap - x_deltam;
        qx = quantalph(sl(i), [-3, -1, 1, 3]);
        tau = tau + mu * dx * (qx - sl(i));
        tnow = tnow + m_;
        tausave(i) = tau;
    end

    time_recovered_signal = sl(1:i-2);
    offsetSaves = tausave(1:i-2);
end