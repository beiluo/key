select t3."SiteId",
                               t3."QuantityId",
                               t2."CreateDate",
                               t2."Total"      as "TwoTotal",
                               t3."Total"      as "ThirdTotal"
                          from (select *
                                  from (select t1."QuantityId",
                                               t1."SiteId",
                                               t1."CreateDate",
                                               sum(t2."Total") as "Total"
                                          from (select p."SiteId",
                                                       p."QuantityId",
                                                       p."CreateDate",
                                                       sum(nvl(p."QuantitiesContract", 0)) as "Total"
                                                  from "ProjectQuantities" q, "ProjectProgressDays" p
                                                 where q."Id" = p."QuantityId"
                                                   and q."IsDeleted" = 0
                                                   and p."IsDeleted" = 0
                                                   and q."ProjectId" = 63
                                                   and p."CreateDate" <= to_date('2013/3/28', 'yyyy-MM-dd')
                                                 group by p."CreateDate", p."SiteId", p."QuantityId") t1,
                                               (select p."SiteId",
                                                       p."QuantityId",
                                                       p."CreateDate",
                                                       sum(nvl(p."QuantitiesContract", 0)) as "Total"
                                                  from "ProjectQuantities" q, "ProjectProgressDays" p
                                                 where q."Id" = p."QuantityId"
                                                   and q."IsDeleted" = 0
                                                   and p."IsDeleted" = 0
                                                   and q."ProjectId" = 63
                                                   and p."CreateDate" <= to_date('2013/3/28', 'yyyy-MM-dd')
                                                 group by p."CreateDate", p."SiteId", p."QuantityId") t2
                                         where t1."SiteId" = t2."SiteId"
                                           and t1."QuantityId" = t2."QuantityId"
                                           and t2."CreateDate" <= t1."CreateDate"
                                         group by t1."QuantityId", t1."SiteId", t1."CreateDate")
                                 order by "QuantityId", "SiteId", "CreateDate") t2,
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
                           and t2."SiteId"(+) = t3."SiteId"
