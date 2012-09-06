(select 'NO TAGS' as with_tags, (extract(month from buys.period_start_date)) as month, states.abbreviation,
buyers.party, issues_relations.category as category, 
issues_relations.sub_category as sub_category, null as tag, mmr.type,
--buys.id as buy_id,
round(sum(buys.scaled_dollars)) as scaled_dollars
from media_buys_by_day as buys  
left join media_ads on buys.media_ad_id = media_ads.id
left join (select 
  media_ad_id
  ,issue_id
  ,case when category_id is null then issue_name || '- GENERAL' else issue_name end sub_category
  --,case when category_id is null then issue_id else category_id end category_id
  ,case when category_id is null then issue_name else category_name end category
from (
  select 
    IMA.media_ad_id
    ,IMA.issue_id
    ,I.name as issue_name
    ,I.parent_id as category_id
    ,C.name as category_name
  from issues_media_ads IMA
  join issues I on IMA.issue_id = I.id
  left join issues C on I.parent_id = C.id
  order by 5,3
  ) as Y) as issues_relations
                on buys.media_ad_id = issues_relations.media_ad_id
left join media_ads_tags on buys.media_ad_id = media_ads_tags.media_ad_id
left join tags on media_ads_tags.tag_id = tags.id
left join buyers on buys.buyer_id = buyers.id
left join media_markets as mmr on buys.media_market_id = mmr.id
left join states on buys.target_state_id = states.id
where buys.race_id = '50' AND mmr.type != 'RadioMediaMarket'--AND category is null
AND buys.period_start_date between '20120301' AND now() 
/*AND (NOW() - Interval '1 Month') AND NOW()*/ 
--AND mmr.type != 'CableMediaMarket'
group by 1,2,3,4,5,6,7,8
order by 1,2,3,4,5,6,7,8,9 DESC)

UNION

--This is the select statement of scaled_dollars including tags, totals will not match first select

(select 'WITH TAGS' as with_tags, (extract(month from buys.period_start_date)) as month, states.abbreviation,
buyers.party, issues_relations.category as category, 
issues_relations.sub_category as sub_category, tags.tag as tag, mmr.type,
--buys.id as buy_id,
round(sum(buys.scaled_dollars)) as scaled_dollars
from media_buys_by_day as buys  
left join media_ads on buys.media_ad_id = media_ads.id
left join (select 
  media_ad_id
  ,issue_id
  ,case when category_id is null then issue_name || '- GENERAL' else issue_name end sub_category
  --,case when category_id is null then issue_id else category_id end category_id
  ,case when category_id is null then issue_name else category_name end category
from (
  select 
    IMA.media_ad_id
    ,IMA.issue_id
    ,I.name as issue_name
    ,I.parent_id as category_id
    ,C.name as category_name
  from issues_media_ads IMA
  join issues I on IMA.issue_id = I.id
  left join issues C on I.parent_id = C.id
  order by 5,3
  ) as Y) as issues_relations
                on buys.media_ad_id = issues_relations.media_ad_id
left join media_ads_tags on buys.media_ad_id = media_ads_tags.media_ad_id
left join tags on media_ads_tags.tag_id = tags.id
left join buyers on buys.buyer_id = buyers.id
left join media_markets as mmr on buys.media_market_id = mmr.id
left join states on buys.target_state_id = states.id
where buys.race_id = '50' AND mmr.type != 'RadioMediaMarket'--AND category is null
AND buys.period_start_date between '20120301' AND now() 
/*AND (NOW() - Interval '1 Month') AND NOW()*/ 
--AND mmr.type != 'CableMediaMarket'
group by 1,2,3,4,5,6,7,8
order by 1,2,3,4,5,6,7,8,9 DESC)