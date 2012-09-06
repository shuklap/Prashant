select (extract(month from buys.period_start_date)) as month, buyers.party, issues.name as category, (case when issues.parent_id isnull then null
else (select issue_parent.name from issues as issue_parent where issues.parent_id = issue_parent.parent_id) end) as sub_category, 
round(sum(buys.scaled_dollars)) as scaled_dollars, null as ad_tag
from media_buys_by_day as buys
left join media_ads on buys.media_ad_id = media_ads.id
left join issues_media_ads on media_ads.id = issues_media_ads.media_ad_id
left join issues on issues_media_ads.issue_id = issues.id
--left join media_ads_tags on buys.media_ad_id = media_ads_tags.media_ad_id
--left join tags on media_ads_tags.tag_id = tags.id
left join buyers on buys.buyer_id = buyers.id
where buys.race_id = '50' AND buys.period_start_date between (NOW() - Interval '1 Year') AND NOW()
group by month, buyers.party, category, issues.name, sub_category, ad_tag
order by month, issues.name, scaled_dollars;