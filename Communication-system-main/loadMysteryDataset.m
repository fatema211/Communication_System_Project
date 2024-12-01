function [r, SRRCLength, SRRCrolloff, T_t, f_if, f_s] = loadMysteryDataset(choice)
    % Initialize variables
    r = [];
    SRRCLength = 0;
    SRRCrolloff = 0;
    T_t = 0;
    f_if = 0;
    f_s = 0;

    % Load dataset based on choice
    switch lower(choice)
        case {'a', 'mysterya'}
            MysteryA_Dataset;  % Run the script for Mystery A
        case {'b', 'mysteryb'}
            MysteryB_Dataset;  % Run the script for Mystery B
        case {'c', 'mysteryc'}
            MysteryC_Dataset;  % Run the script for Mystery C
        otherwise
            error('Invalid selection. Please choose a, b, or c.');
    end

end
