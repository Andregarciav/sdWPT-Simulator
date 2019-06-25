function [hdr] = header(obj,MsgType,src,dst,ttl,dataLen)
    hdr = [string(MsgType) string(obj.seqNumber) string(dataLen) ...
           string(obj.ID) string(src) string(dst) string(ttl)];
end