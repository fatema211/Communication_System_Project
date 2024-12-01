function [syncedFrames] = performFrameSynchronization(preamblePAM, peakThreshold, crossCorrelationResult, frame_input, userDataLength)
    
    userDataLength = userDataLength * 4;
    % Identifying frame synchronization points
    [Peaks, peakPositions] = findpeaks(abs(crossCorrelationResult), 'MinPeakHeight', peakThreshold);
    frameStartIndex = length(frame_input) - peakPositions(end) + 1;
    frameStartIndex = max(frameStartIndex, 1);  % Ensure the start index is at least 1

    % Estimate the size for preallocating syncedFrames
    estimatedNumFrames = ceil(length(frame_input) / (length(preamblePAM) + userDataLength));
    estimatedFrameSize = userDataLength; % Assuming each frame is of this length
    syncedFrames = zeros(1, estimatedNumFrames * estimatedFrameSize);

    % Frame extraction loop with preallocation
    j = frameStartIndex;
    frameCount = 0;
    while j <= length(frame_input) - length(preamblePAM)
        % Determine start and end indices for the header and message
        headerStart = j;
        headerEnd = j + length(preamblePAM) - 1;
        messageStart = headerEnd + 1;
        messageEnd = min(messageStart + userDataLength - 1, length(frame_input));

        % Extract the header and message from the signal
        signalHeader = frame_input(headerStart:headerEnd);
        message = frame_input(messageStart:messageEnd);

        % Invert message signal if the first header element is non-negative
        if signalHeader(1) >= 0
            message = -message;
        end

        % Increment frame count and store the current frame
        frameCount = frameCount + 1;
        startIndex = (frameCount - 1) * estimatedFrameSize + 1;
        endIndex = startIndex + length(message) - 1;
        syncedFrames(startIndex:endIndex) = message;

        % Update the index for the next frame
        j = messageEnd + 1;
    end

    % Truncate the excess preallocated space
    syncedFrames = syncedFrames(1:frameCount * estimatedFrameSize);
end
