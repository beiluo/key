select *
  from (select k."SiteId",
               sum(round(k."waji_percentage", 4)) as "waji_percentage",
               sum(round(k."zhuangji_percentage", 4)) as "zhuangji_percentage",
               sum(round(k."chengtai_Percentage", 4)) as "chengtai_Percentage",
               sum(round(k."height_percentage", 4)) as "height_percentage",
               sum(round(k."dingmao_percentage", 4)) as "dingmao_percentage",
               sum(round(k."dianshi_percentage", 4)) as "dianshi_percentage"
          from (select tt3."SiteId",
                       (decode(t1."Name",'挖基',sum(tt3."TwoTotal") / sum(tt3."ThirdTotal"),0)) as "waji_percentage",
                       (decode(t1."Name",'桩基',sum(tt3."TwoTotal") / sum(tt3."ThirdTotal"),0)) as "zhuangji_percentage",
                       (decode(t1."Name",'承台',sum(tt3."TwoTotal") / sum(tt3."ThirdTotal"),0)) as "chengtai_Percentage",
                       (decode(t1."Name",'墩台身',sum(tt3."TwoTotal") / sum(tt3."ThirdTotal"),0)) as "height_percentage",
                       (decode(t1."Name",'顶帽',sum(tt3."TwoTotal") / sum(tt3."ThirdTotal"),0)) as "dingmao_percentage",
                       (decode(t1."Name",'垫石',sum(tt3."TwoTotal") / sum(tt3."ThirdTotal"),0)) as "dianshi_percentage"
                  from (select c."Id", c."Name", q."Id" as "QuantityId"
                          from "ProjectCategory"    c,
                               "ProjectMappingSite" m,
                               "ProjectDictionary"  d,
                               "ProjectQuantities"  q
                         where c."ProjectId" = 63
                           and q."ProjectId" = 63
                           and c."IsDeleted" = 0
                           and c."Id" = m."PCId"
                           and m."IsDeleted" = 0
                           and m."PSId" = d."Id"
                           and q."DictionaryId" = d."Id") t1,
                       (select t3."SiteId",
                               t3."QuantityId",
                               t2."Total"      as "TwoTotal",
                               t3."Total"      as "ThirdTotal"
                          from (select p."SiteId",
                                       p."QuantityId",
                                       sum(nvl(p."QuantitiesContract", 0)) as "Total"
                                  from "ProjectQuantities"   q,
                                       "ProjectProgressDays" p
                                 where q."Id" = p."QuantityId"
                                   and q."IsDeleted" = 0
                                   and p."IsDeleted" = 0
                                   and q."ProjectId" = 63
                                   and p."CreateDate" <=to_date('2013/3/28', 'yyyy-MM-dd')
                                 group by p."SiteId", p."QuantityId") t2,
                               (select d."SiteId",
                                       d."QuantityId",
                                       nvl(d."QuantitiesContract", 0) +
                                       nvl(d."QuantitiesAlter", 0) as "Total"
                                  from "ProjectQuantities" q,
                                       "ProjectDesigns"    d
                                 where q."IsDeleted" = 0
                                   and d."IsDeleted" = 0
                                   and q."Id" = d."QuantityId"
                                   and q."ProjectId" = 63) t3
                         where t2."QuantityId"(+) = t3."QuantityId"
                           and t2."SiteId"(+) = t3."SiteId") tt3
                 where t1."QuantityId" = tt3."QuantityId"
                 group by tt3."SiteId", t1."Name") k
         group by k."SiteId") tt1,
       (select *
          from "ProjectSite"
         where "IsDeleted" = 0
           and "ProjectId" = 63  and "IsDuntai" = 1 and "IsTotal"!=1) tt2
 where tt1."SiteId" = tt2."Id"
 order by tt2."Sort"
