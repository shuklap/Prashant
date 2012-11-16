select buyers.name,
period_start_date,
sum(scaled_dollars) as total,
sum(case when race_id in (4,50) then scaled_dollars else 0 end) as presidential_dollars,
sum(case when race_id not in (4,50) then scaled_dollars else 0 end) as non_presidential_dollars
from media_buys_by_month as buys
inner join buyers on buyers.id = buys.buyer_id
inner join media_markets on media_markets.id = buys.media_market_id
where buyers.name in ('Crossroads GPS','American Crossroads')
and media_markets.type != 'RadioMediaMarket'
group by buyers.name, period_start_date
order by period_start_date, name