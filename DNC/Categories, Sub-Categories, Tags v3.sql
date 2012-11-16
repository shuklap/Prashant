select (extract(month from buys.period_start_date)) as month, 
buyers.party, issues_categories.name as category, 
issues_sub_categories.name as sub_category, 
media_ads.name,
round(sum(buys.scaled_dollars)) as scaled_dollars, 
null as ad_tag
from media_buys_by_day as buys  
left join media_ads on buys.media_ad_id = media_ads.id
left join issues_media_ads on media_ads.id = issues_media_ads.media_ad_id
left join issues as issues_categories on issues_media_ads.issue_id = issues_categories.id 
AND issues_categories.parent_id is null
left join issues as issues_sub_categories on 
    issues_sub_categories.lft > issues_categories.lft 
    AND issues_sub_categories.rgt < issues_categories.rgt 
    AND issues_sub_categories.parent_id is not null
    AND issues_sub_categories.id in (select issue_id from issues_media_ads where media_ad_id = media_ads.id)
--left join media_ads_tags on buys.media_ad_id = media_ads_tags.media_ad_id
--left join tags on media_ads_tags.tag_id = tags.id
left join buyers on buys.buyer_id = buyers.id
left join media_markets as mmr on buys.media_market_id = mmr.id
left join states on buys.target_state_id = states.id
where buys.race_id = '50' AND states.id = 36 AND mmr.type != 'RadioMediaMarket'
AND buys.period_start_date between '20120801' AND '20120831' 
/*AND (NOW() - Interval '1 Month') AND NOW()*/ 
--AND mmr.type != 'CableMediaMarket'
group by month, buyers.party, category, sub_category, media_ads.name, ad_tag
order by month, category, sub_category, scaled_dollars; 