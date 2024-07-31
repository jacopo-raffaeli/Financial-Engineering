function [dates, discounts]=bootstrap(datesSet, ratesSet)
% Compute the discount factors using bootstrap with market data
%
% INPUT:
% datesSet:  struct of the dates of market Data
% ratesSet:  struct of the rates of market Data
%
% OUTPUT:
% dates:     dates of the discount factors
% discounts: discounts B(0,dates) 

% we want to use the most liquid contracts we have
n_depos=sum(datesSet.depos<=datesSet.futures(1,1))+1;
n_futures=sum(datesSet.futures(:,2)<=datesSet.swaps(2));
n_swaps=length(datesSet.swaps(2:end));

%initialize dates for every type of contract
dates_deposit=datesSet.depos(1:n_depos,:);
dates_future=datesSet.futures(2:end,:);
dates_swap= datesSet.swaps(2:end,:);

% computation of mean price between ask and bid
% REMEMBER: not in percentage
rates_deposit = mean(ratesSet.depos(1:n_depos,:),2);
rates_futures = mean(ratesSet.futures(1:n_futures,:),2);
rates_swaps = ratesSet.swaps(2:end,:);

% initialize discounts vector and dates vector
N = n_depos + n_futures + n_swaps;

discounts = zeros (N, 1);
dates = zeros(N,1);
zRates=zeros(N,1);
%rates = zeros(N,1);

%Bootstrap with depos (liquid products with shortest expiry)
% Dates convertion  act/360  for futures and deposit
delta_depos=yearfrac(datesSet.settlement,dates_deposit, 2);
discounts(1:n_depos) = 1./(1 + delta_depos.*rates_deposit);
dates(1:n_depos) = datesSet.depos(1:n_depos,:);

% Date convertion for zRates act/365
date_zrates_depo=yearfrac(datesSet.settlement,dates_deposit, 3);
zRates(1:n_depos)= -1./date_zrates_depo.*log(discounts(1:n_depos));

% Bootstrap with futures (liquid products with shortest expiry)
dates(n_depos+1:n_depos+n_futures) = datesSet.futures(2:end,2);

% Dates convertion  act/360  for futures and deposit
delta_futures= yearfrac(dates_future(:,1),dates_future(:,2),2);

% Date convertion for zRates act/365
date_zrates_futures=yearfrac(datesSet.settlement,dates_future,3);

for i=1:n_futures
    % interp to find the zrate of the start of the future
    y_interp = interp1([date_zrates_depo;date_zrates_futures(1:i-1,2)],zRates(1:n_depos+i-1),...
        date_zrates_futures(i,1),'linear',zRates(n_depos+i-1));

    % find the  of start future
    disc=exp(-date_zrates_futures(i,1).*y_interp);

    % find discount of future exp.
    discounts(n_depos+i)=disc/(1+delta_futures(i)*rates_futures(i));
    % find zrate  at exp. of the future

    zRates(n_depos+i)=-log(discounts(n_depos+i))/date_zrates_futures(i,2);
end

% Bootstrap with swaps
dates(n_depos+n_futures+1:end)=dates_swap;

% we need to interpolate the first swap to find its BPV so use conv act/365
date_first_swap= yearfrac(datesSet.settlement, datesSet.swaps(1), 3);
rate_first_swap=interp1([date_zrates_depo;date_zrates_futures(:,2)],zRates(1:n_depos+n_futures),date_first_swap,'linear','extrap');
disc_first_swap=exp(-rate_first_swap*date_first_swap);
BPV = disc_first_swap*yearfrac(datesSet.settlement, datesSet.swaps(1), 6);

for i=1:n_swaps
    % Dates convertion  30/360 EU for swaps
    delta_swap=yearfrac(datesSet.swaps(i),datesSet.swaps(i+1),6);

    % use closed formula for B_ti of the exp. of the swap
    B_ti=(1-rates_swaps(i)*BPV)/(1+delta_swap*rates_swaps(i));
    
    % update the BPV for the next swap
    BPV=BPV+delta_swap*B_ti;
    discounts(n_depos+n_futures+i)=B_ti;
   
end

%add today in dates and discounts
dates=[datesSet.settlement;dates];
discounts=[1;discounts];

end