function filteredSignal = processSignalWithDDEqualizer(syncedFrames, equalizerLength, mu, f)

 % Direct Decision Feedback (DD) Equalizer using 'syncedFrames'
    for i = equalizerLength + 1 : length(syncedFrames)
        rr = syncedFrames(i:-1:i-equalizerLength+1)';
        error = quantalph(f' * rr, [-3, -1, 1, 3]) - f' * rr;
        f = f + mu * error * rr;
    end

    % Applying the filter to the signal 
    filteredSignal = filter(f, 1, syncedFrames);

    % Trimming the first three elements
    % to align with the desired starting point of the filtered signal
    filteredSignal(1:3) = [];
end