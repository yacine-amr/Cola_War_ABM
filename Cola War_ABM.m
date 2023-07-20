clear 
clc
L = 20;    %system size L x L
Time = []
Droplet = []
Ads = []
Price = []
for trial = 1:1:10
    D = [ 0, 6, 10, 14]
    P = [0.08, 0.09, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15]
    cm = 0
    for id= 1:1:size(D,2)
        for ip= 1:1:size(P,2)
            % Dock figures in the
            % main window
            set(0,'DefaultFigureWindowStyle','docked')
            % Initiale Parameters:
            p = P(ip);                        % Probability p (Advertising cost)
            d = D(id);                        % droplet size d x d
            T = 0;                            % initialize the Time
            S = zeros(L,L) - 1;               % opinion matrix, initially set to -1
            S((L-d)/2+1:((L-d)/2)+d ,(L-d)/2+1:(L-d)/2+d)= 1;     % droplet, initially set to +1
            % Time loop
            tresh = sum(S(:) == 1)
            while (tresh <=round(L*L*75/100))
                T = T + 1
                tresh = sum(S(:) == 1)
                if rand() <=p
                    % Apply Advertising 
                    i = floor(rand*L)+1;
                    j = floor(rand*L)+1;
                    S(i,j)=S(i,j).^2
                else
                    %Conformity
                    % Randomly select a cell (an agent), say S(i,j) with i,j in {1,…,N}
                    i = floor(rand*L)+1;
                    j = floor(rand*L)+1;
                    % Check if agents have the same opinion	
                    % Check on the Right
                    if S(i,j)*S(i,mod(j+1-1,L)+1)==1 
                        % Modify agents above the panel
                        S(mod(i-1-1,L)+1,j)=S(i,j); 		
                        S(mod(i-1-1,L)+1,mod(j+1-1,L)+1)=S(i,j);	
                        % Modify agent to the left of the panel
                        S(i,mod(j-1-1,L)+1)=S(i,j); 	
                        % Modify agent to the right of the panel	
                        S(i,mod(j+2-1,L)+1)=S(i,j);	 
                        % Modify agents below the panel
                        S(mod(i+1-1,L)+1,j)=S(i,j); 
                        S(mod(i+1-1,L)+1,mod(j+1-1,L)+1)=S(i,j);
                    end               
                    % Check Up
                    if  S(i,j)*S(mod(i-1-1,L)+1,j)==1
                        % Modify agents above the panel
                        S(mod(i-2-1,L)+1,j)=S(i,j); 		    
                        % Modify agent to the right of the panel
                        S(i,mod(j+1-1,L)+1)=S(i,j);	
                        S(mod(i-1-1,L)+1,mod(j+1-1,L)+1)=S(i,j); 	
                        % Modify agent to the left of the panel	
                        S(i,mod(j-1-1,L)+1)=S(i,j);	 
                        S(mod(i-1-1,L)+1,mod(j-1-1,L)+1)=S(i,j);
                        % Modify agents below the panel
                        S(mod(i+1-1,L)+1,j)=S(i,j);
                    end
                    % Check Down
                    if  S(i,j)*S(mod(i+1-1,L)+1,j)==1
                        % Modify agents above the panel
                        S(mod(i-1-1,L)+1,j)=S(i,j); 		
                        % Modify agent to the left of the panel
                        S(i,mod(j-1-1,L)+1)=S(i,j); 
        	            S(mod(i+1-1,L)+1,mod(j-1-1,L)+1)=S(i,j);
                        % Modify agent to the right of the panel	
                        S(i,mod(j+1-1,L)+1)=S(i,j);	
                        S(mod(i+1-1,L)+1,mod(j+1-1,L)+1)=S(i,j);
                        % Modify agents below the panel
                        S(mod(i+2-1,L)+1,j)=S(i,j); 
                    end
                    % Check on the Left
                    if   S(i,j)*S(i,mod(j-1-1,L)+1)==1
                        % Modify agents above the panel
                        S(mod(i-1-1,L)+1,j)=S(i,j); 		
                        S(mod(i-1-1,L)+1,mod(j-1-1,L)+1)=S(i,j);	
                        % Modify agent to the left of the panel
                        S(i,mod(j-2-1,L)+1)=S(i,j); 	
                        % Modify agent to the right of the panel	
                        S(i,mod(j+1-1,L)+1)=S(i,j);	 
                        % Modify agents below the panel
                        S(mod(i+1-1,L)+1,j)=S(i,j); 
                        S(mod(i+1-1,L)+1,mod(j-1-1,L)+1)=S(i,j);
                    end
                end
                figure(1)
                % Plot selected panel in gray
                S1_old = S(i,j); S2_old = S(i,mod(j+1-1,L)+1);  S3_old = S(mod(i-1-1,L)+1,j);
                S4_old = S(mod(i+1-1,L)+1,j) ; S5_old = S(i,mod(j-1-1,L)+1)
                S(i,j) = 0; S(i,mod(j+1-1,L)+1) = 0; S(mod(i-1-1,L)+1,j)= 0; S(mod(i+1-1,L)+1,j)= 0 
                S(i,mod(j-1-1,L)+1)= 0
                % Plot system state: 0 - black, 1 - white, (0,1) - gray
                imshow((S+1)/2,'InitialMagnification','fit')
                    title(['Time step: '  num2str(T) ...
                    ', selected agent: (' num2str(i) ',' num2str(j) ')'])
                %pause(1)
                % Set panel state to original values
                S(i,j) = S1_old; S(i,mod(j+1-1,L)+1) = S2_old;
                S(mod(i-1-1,L)+1,j) = S3_old;  S(mod(i+1-1,L)+1,j) = S4_old;
                S(i,mod(j-1-1,L)+1) = S5_old 
            end
            cm = cm + 1
            fp = 600*p.^6
            gd = d.^2
            X = fp*T + gd
            Time(trial,cm) = T
            Droplet(trial,cm)= d
            Ads(trial,cm)= p
            Price(trial,cm)  = X
        end
    end
end

