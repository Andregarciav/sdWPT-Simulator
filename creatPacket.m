function payload = creatPacket(obj,msgType,data,GlobalTime,dst)

    if msgType == 0 %significa hello
        msg_len = '0';
        if isempty(obj.One_hope)
            payload = ['0',msg_len,string(obj.ID)];
        end
    elseif msgType == 1 %significa resposta ao hellow
        msg_len = length(obj.One_hope);
        payload = ['1',msg_len,string(obj.ID),string(obj.One_hope)];
    else
        payload = 0;
    end


end

