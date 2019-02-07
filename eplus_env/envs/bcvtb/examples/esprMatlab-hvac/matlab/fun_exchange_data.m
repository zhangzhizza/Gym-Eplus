function [bcvtb_y,flaRea] = fun_exchange_data(sockfd,flaWri,nDblRea,simTimWri,bcvtb_u,TS)

% Exchange data
try

% display(['TS: ' num2str(TS)]);    % [DEBUG]
    
[retVal,flaRea,simTimRea,bcvtb_y] = exchangeDoublesWithSocket(sockfd,flaWri,nDblRea,simTimWri,bcvtb_u);

catch ME1
        % exchangeDoublesWithSocket had an error. Terminate the connection
        processError(ME1, sockfd, -1);
        exit;
end

% Check return flags
if (flaRea == 1) % End of simulation
    disp('Matlab received end of simulation flag from BCVTB. Exit simulation.');
%     closeIPC(sockfd);
    return;
end

if (retVal < 0) % Error during data exchange
    exception = MException('BCVTB:RuntimeError','exchangeDoublesWithSocket returned value %d',retVal);
    processError(exception, sockfd, -1);
    exit;
end

  if (flaRea > 1) % BCVTB requests termination due to an error.
    exception = MException('BCVTB:RuntimeError',['BCVTB requested MATLAB to terminate by sending %d\n','Exit simulation.\n'], retVal);
    processError(exception, sockfd, -1);
    exit;
  end

% display([' sockfd: ' num2str(sockfd) ' flaWri: ' num2str(flaWri) ' nDblRea: ' num2str(nDblRea)  ' simTimWri: ' num2str(simTimWri) ' act: ' num2str(bcvtb_u)]);
% display([' retVal: ' num2str(retVal) ' flaRea: ' num2str(flaRea) ' simTimRea: ' num2str(simTimRea) ' sen: ' num2str(bcvtb_y)]);
% display([' ']);

end

