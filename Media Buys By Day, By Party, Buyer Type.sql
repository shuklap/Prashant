select buys.period_start_date, buyers.party, buyers.buyer_type,
round(sum(buys.scaled_points*mmr.percent_of_sub_in_super*((sub_market_audience.count/super_market_audience.count)::double precision))) as DMA_points
from media_buys_by_month as buys
left join media_markets as mm on buys.media_market_id = mm.id
left join media_market_relations as mmr on buys.media_market_id = mmr.sub_market_id
left join buy_target_audiences as sub_market_audience on mmr.sub_market_id = sub_market_audience.media_market_id AND buys.target_group = sub_market_audience.name
left join buy_target_audiences as super_market_audience on mmr.super_market_id = super_market_audience.media_market_id AND buys.target_group = super_market_audience.name
left join buyers on buys.buyer_id = buyers.id
where buys.period_start_date between '20120801'and '20120831' AND buys.race_id = '50' AND buys.target_state_id = '6' AND mm.type != 'RadioMediaMarket'
group by buys.period_start_date, buyers.party, buyers.buyer_type
order by buys.period_start_date, buyers. party, buyers.buyer_type;
