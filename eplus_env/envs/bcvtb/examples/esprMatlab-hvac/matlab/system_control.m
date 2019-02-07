%% Control variables
nSen = 2;                              % number of sensors
nAct = 2;                              % number of actuator
Tset = 22;                             % temperature setpoint

delTim = 300;                          % time step in seconds, make sure this is the same as in BCVTB and ESP-r
startup = 1;                           % startup days in ESP-r

%% Initialize parameters
nDblRea = nSen;                        % number of doubles to read
bcvtb_y=zeros(1,nSen);                 % sensor values to be received from ESP-r
bcvtb_u =zeros(1,nAct);                % actuator initial values
flaWri = 0;                            % write flag
simTimWri = 0;                         % intial time


%% Add path to BCVTB matlab libraries
addpath( strcat(getenv('BCVTB_HOME'), '/lib/matlab'));


%% Establish BCVTB socket
sockfd = establishClientSocket('socket.cfg');

if sockfd < 0
    display(['Error: Failed to obtain socket file descriptor. sockfd = ' num2str(sockfd)]);
  exit;
end

display('*** BCVTB - Establish client socket')
display(['socketFD: ' num2str(sockfd)]);

% Initialize values
TS = simTimWri/delTim;                  % timestep
[bcvtb_y,flaRea]=fun_exchange_data(sockfd,flaWri,nDblRea,simTimWri,bcvtb_u,TS);


%% Loop for simulation time steps
while (flaRea == 0 )
    simTimWri = simTimWri + delTim;
    TS = TS + 1;
    
    % Proportional controller
    for i = (1:nAct)
        
        Terr(TS,i) = (Tset-bcvtb_y(i))/Tset;                       % relative error
        
        if(bcvtb_y(i)<Tset)
             bcvtb_u(i)=Terr(TS,i)*5;                              % Proportional term
             
             if(TS > 3)
             bcvtb_u(i)=bcvtb_u(i) + sum(Terr(TS-3:TS,i))*0.7;     % Integral term
             end
             
            if (bcvtb_u(i)>1); bcvtb_u(i) = 1; end
            if (bcvtb_u(i)<0); bcvtb_u(i) = 0; end
        else
            bcvtb_u(i) = 0;
        end
    end
 
    bcvtb_u(1)=bcvtb_u(1)*800;                             % control signal * system capacity (W)
    bcvtb_u(2)=bcvtb_u(2)*2000;

    % Exchange data
    bcvtb_u=fix(bcvtb_u);           % fix numbers, otherwise error with exchange (?!)
    bcvtb_u_his(TS,:)=bcvtb_u;      % store control signal
    [bcvtb_y,flaRea]=fun_exchange_data(sockfd,flaWri,nDblRea,simTimWri,bcvtb_u,TS);
end


%% close BCVTB socket
display('*** BCVTB - Close client socket')
display(['close socketFD: ' num2str(sockfd)]);
display(' ')

closeIPC(sockfd);


%% Results analysis
% Energy demand per actuator
for i=(1:nAct)
    display(['Total energy use, actuator ' num2str(i) ': ' num2str(sum(bcvtb_u_his((3600/delTim*24*startup+1):TS,i)*(delTim/3600/1000))) ' kWh']); % kWhrs
end
display(' ')


%% exit program
exit

