select (extract(month from buys.period_start_date)) as month, buyers.party, case when issues_categories.parent_id is null then issues_categories.name end as category, 
case when issues_categories.parent_id is null then null else issues_sub_categories.name end as sub_category, round(sum(buys.scaled_dollars)) as scaled_dollars, null as ad_tag
from media_buys_by_day as buys
left join media_ads on buys.media_ad_id = media_ads.id
left join issues_media_ads on media_ads.id = issues_media_ads.media_ad_id
left join issues as issues_categories on issues_media_ads.issue_id = issues_categories.id
left join issues as issues_sub_categories on issues_categories.id = issues_sub_categories.parent_id
--left join media_ads_tags on buys.media_ad_id = media_ads_tags.media_ad_id
--left join tags on media_ads_tags.tag_id = tags.id
left join buyers on buys.buyer_id = buyers.id
left join media_markets as mmr on buys.media_market_id = mmr.id
where buys.race_id = '50' AND buys.period_start_date between (NOW() - Interval '1 Month') AND NOW() AND mmr.type != 'CableMediaMarket'
group by month, buyers.party, category, sub_category, ad_tag
order by month, category, sub_category, scaled_dollars;