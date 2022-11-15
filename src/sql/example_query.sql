``` This script assumes user extracting posts from the Stack Exchange Query Builder with following format:```

SELECT 
P.Id, P.Title, P.Body, P.ViewCount, P.Score, P.Tags, P.CreationDate

FROM
Posts as P

WHERE 
[[Add filter criteria.]]

ORDER BY 
P.Id DESC