function [dates, discounts] = bootstrap(datesSet, ratesSet)
% Computing the discount rates from market data

% INPUT
% datesSet:          ends dates of depos future and swaps
% ratesSet:          rates (bid and ask) of depos future and swaps

% OUTPUT
% dates:             dates of the discounts 
% discounts:            

%% Deposits

mid_depos= mean(ratesSet.depos,2); % mean value between bid and ask for depos
% we need to use the deposdates up to the first future
Idep = find(datesSet.depos < datesSet.futures(1,1),1,'last'); 
Idep=Idep+1; %got the indeces and in the next passage we find the dates we need
dates = [datesSet.settlement datesSet.depos(1:Idep)']; 
B = 1./( 1 + yearfrac(datesSet.settlement,datesSet.depos(1:Idep),2).*mid_depos(1:Idep)); %found the discount
B=[1 B']; %the first discount is at 19 febb 08 and so it is 1
Idep=length(B);
%% Futures

mid_fut= mean(ratesSet.futures,2); % mean value between bid and ask for futures
%we need to use just the first seven that are the most liquid
mid_fut=mid_fut(1:7,1); %forward rates
dates=[dates datesSet.futures(1:7,2)']; %we need to add the expity of the futures
discounts=[B zeros(1,7)]; %inizializzo vettore discount

fwd_B=1./( 1 +yearfrac(datesSet.futures(1:7,1),datesSet.futures(1:7,2),2) .*mid_fut(1:7));

%interpolation
for i=1:7
    dates_interp=zeros(1,2);
    discounts_interp=zeros(1,2);
    if datesSet.futures(i,1)<dates(Idep+i-1)
        discounts_interp=discounts((Idep+i-2):(Idep+i-1));
        dates_interp=dates((Idep+i-2):(Idep+i-1));
        r=-log(discounts_interp)./yearfrac(dates(1),dates_interp,3);
        r_int=interp1(dates_interp,r,datesSet.futures(i,1));
        B0=exp(-r_int*yearfrac(dates(1),datesSet.futures(i,1),3));
 
    elseif datesSet.futures(i,1)>dates(Idep+i-1)
        discounts_interp=discounts((Idep+i-2):(Idep+i-1));
        dates_interp=dates((Idep+i-2):(Idep+i-1));
        r=-log(discounts_interp)./yearfrac(dates(1),dates_interp,3);
        r_int=interp1(dates_interp,r,datesSet.futures(i,1),"linear","extrap");
        B0 = exp(-r_int*yearfrac(dates(1),datesSet.futures(i,1),3));

    elseif  datesSet.futures(i,1)==dates(Idep+i-1)
        B0=discounts(Idep+i-1);
    end
    discounts(Idep+i)=fwd_B(i)*B0;
    B0=0;
    end

%% Swap

mid_swap= mean(ratesSet.swaps,2);

I = find(dates < datesSet.swaps(1),1,'last');
dates_interp=[dates(I) dates(I+1)];
discounts_interp=[discounts(I) discounts(I+1) ];
%we need to interpolate the first swap (1 year) using futures prices
r=-log(discounts_interp)./yearfrac(dates(1),dates_interp,3);
r_int=interp1(dates_interp,r,datesSet.swaps(1));
B0=exp(-r_int*yearfrac(dates(1),datesSet.swaps(1),3)); %discount first swap


discounts=[discounts(1:I) B0 discounts(I+1:end)];
dates=[dates(1:I) datesSet.swaps(1) dates(I+1:end)];
%add the swap date
dates=[dates datesSet.swaps(2:end)'];
N=length(datesSet.swaps);
date.swaps=[dates(1) datesSet.swaps(1:end)'];
B_swaps=zeros(1,N);

B_swaps(1)=B0;
for j=2:N
    A=zeros(j-1,j-1);
    b=B_swaps(1:j-1);
    y=yearfrac(date.swaps(1:j-1),datesSet.swaps(1:j-1)',6);
    A=y'*b;
    B_swaps(j)=(1-mid_swap(j)*trace(A))/(1+yearfrac(datesSet.swaps(j-1),datesSet.swaps(j),6)*mid_swap(j));
end

discounts=[discounts B_swaps(2:end)];

% Deleting the date and the discounts at 1 year (19 feb 2009) as requested
% during the lesson
dates = [dates(1:7), dates(9:end)];
discounts = [discounts(1:7) discounts(9:end)];

end













       








