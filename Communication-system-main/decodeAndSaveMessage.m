function reconstructedMessage = decodeAndSaveMessage(filteredSignal, selectedMystery)
    % Soft Decision
    quantized_data = quantalph(filteredSignal, [-3, -1, 1, 3])';

    % Convert PAM signals to letters
    reconstructedMessage = pam2letters(quantized_data);
    textToDisplay = sprintf('Decoded Message of Mystery %s', upper(selectedMystery));

    % Prepare the bordered message
    border = repmat('-', 1, length(textToDisplay) + 4);
    borderedMessage = sprintf('%s\n| %s |\n%s\n%s', border, textToDisplay, border, reconstructedMessage);

    % Save the bordered and decoded message to a text file
    fileName = sprintf('Reconstructed_Message_%s.txt', upper(selectedMystery));
    fileID = fopen(fileName, 'w');
    fprintf(fileID, '%s', borderedMessage);
    fclose(fileID);
end