function [PacketReceive] = NumberPacket(LOG)
    PacketReceive = 0;
    for r=2:length(LOG)
        [m,n] = size(LOG(r).DATA.lmsgReceive);
        for i=1:n
            PacketReceive = PacketReceive + LOG(r).DATA.lmsgReceive(2,i);
        end
    end