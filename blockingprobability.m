clc;
close all;

u = (1/120);
lambda = 1;
T = 1000;                            %system running time

j = 1;
for N = 80: 10: 140
  n = round(80*rand(1));                             %initially n channels were busy
  serviceTime = [exprnd(1/u,1,n) zeros(1,N-n)];           %servicetime of n channels
  dt = exprnd(1/lambda);              %dt is the small time interval between two consecutive calls

  Pb(j) = 0;                           
  arrival = 1;                              %we assume single call is arrive
  t = 0;
  while(t < T)
    for i = 1 : N
      if(dt > serviceTime(i))               %here we check if the channel is free or not
        serviceTime(i) = 0;                 %here we set the serviceTime of left callers to zero
      else
        serviceTime(i) = serviceTime(i) - dt;     %here we reset the ongoing channels serviceTimes at new call arrival instant
      end
    end
      if(~any(serviceTime(:) == 0))         %here we check if none of the channel is available for caller
        Pb(j) = Pb(j) + 1;                      %here we keep increasing the count of blocked callers
      else
        serviceTime(find(serviceTime==0, 1, 'first')) = exprnd(1/u);     %here we set the servicetime for unblocked caller
      end
    dt = exprnd(1/lambda);           %here we set the value of dt
    t = t + dt;
    arrival = arrival + 1;                        
  end  
  Pb(j) = Pb(j)/arrival;                    %here we calculate the blocked callers probability


  ro = (lambda/u);
  den = 0;
  for i = 1 : N
    den = den + ((ro^i)/factorial(i));
  end
  Erl_B(j) = ((ro^N)/factorial(N))/den;   %here we calculate the erlang probability
  j = j + 1;
end
clear N;
N = 80:10:140;
plot(N,Pb);hold on;plot(N,Erl_B,'m');legend('Simulated P_B','Erlang B P_B');
xlabel('Number of Channels(N)');ylabel('Blocking Probability(P_B)');