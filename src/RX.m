function rxbits = RX(config,ChannelOutVec)
    ChannelOutVec = ChannelOutVec(:)'; % turn  to row vector
    if config.pulsetype == 0 %flag
        rxpulse = config.tpulserect;
    else
        rxpulse = config.tpulsesinc;
    end

    %%%%%%%%%%%%%%%%
    % Q4
    % optimal_sample_point = config.Fs + length(rxpulse);


    % % Q5
    % search_window = ChannelOutVec(1 : 4 * config.Fs);
    % syn_filter_out = conv(search_window, flip(config.synchsymbol));
    % [~, idx_sync] = max(abs(syn_filter_out));
    % optimal_sample_point = idx_sync - length(config.synchsymbol) + ...
    %      config.nsynchbits * config.Ts + length(rxpulse); 

    %Q6
    ChannelOutVec = ChannelOutVec.*cos(2*pi*(config.Fc/config.Fs)*(0:length(ChannelOutVec)-1));
    ChannelOutVec = conv(ChannelOutVec, config.RxLPFpulse);

    search_window = ChannelOutVec(1 : 4 * config.Fs); %like before
    syn_filter_out = conv(search_window, flip(config.synchsymbol));

    [~, idx_sync] = max(abs(syn_filter_out));
    optimal_sample_point = idx_sync - length(config.synchsymbol) + ...
         config.nsynchbits * config.Ts + length(rxpulse);

    Energy_synch = sum(config.synchsymbol.^2); % Energy of snyc symbol
    peak = syn_filter_out(idx_sync); % Maximum val
    beta_half = peak / Energy_synch; % Beta/2

    ChannelOutVec = ChannelOutVec / beta_half;
    %%%%%%%%%%%%%%%
    % only at 6b:
    % disp(['Estimated value of beta/2: ', num2str(beta_half)]);

    
    last_needed_sample = optimal_sample_point + (config.K * config.Ts) + length(rxpulse);
    actual_end = min(last_needed_sample, length(ChannelOutVec));
    ChannelOutVec_short = ChannelOutVec(1 : actual_end); 
    
    matched_filter = conv(ChannelOutVec_short, flip(rxpulse)); 
    
    sample_indices = optimal_sample_point : config.Ts : optimal_sample_point + (config.K - 1)*config.Ts; 
    sampled_symbols = matched_filter(sample_indices);
    
    reconstructed_bpsk = sign(sampled_symbols); 
    reconstructed_bpsk(reconstructed_bpsk == 0) = 1; 
    
    rxbits = (1 - reconstructed_bpsk) / 2;
end