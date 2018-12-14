function warningMsg(Msg,Complement)
    global lastMsg;
    
    if(strcmp(lastMsg,Msg)==0 && strcmp('Current is not enough to charge the battery.',Msg)==0 && strcmp('Dropped broadcast message',Msg)==0)
		if exist('Complement','var')
			disp(['!!! Warning: ',Msg,Complement]);
		else
			disp(['!!! Warning: ',Msg]);
		end
        lastMsg = Msg;
    end
end
