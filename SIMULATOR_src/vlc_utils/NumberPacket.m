function [packetSend] = NumberPacket(LOG)
    packetSend = 0;
    for r=2:length(LOG)
        packetSend = packetSend + LOG(r).DATA.seqNumber;
    end