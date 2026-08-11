function ChannelInVec = TX(config,infobits)
    infobits = infobits(:)'; % turn infobits to row vector
    if config.pulsetype == 0 % pulse shape
        txpulse = config.tpulserect; 
    else
        txpulse = config.tpulsesinc;
    end

    BPSKbits = 1 - 2.*infobits; % between -1:1
    PulseTrain = upsample(BPSKbits,config.Ts); % upsampling
    TXFiltout = conv(txpulse,PulseTrain);% creating "continuous time" signal
    ChannelInVec = [zeros(1, config.Fs), TXFiltout, zeros(1, 4*config.Fs)]; % padding

    % only for Q6
    ChannelInVec = ChannelInVec.*cos(2*pi*(config.Fc/config.Fs)*(0:length(ChannelInVec)-1));
    
end 