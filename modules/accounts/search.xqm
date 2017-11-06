xquery version "1.0";
(: --------------------------------------
   Case tracker pilote

   Authors: Stéphane Sire <s.sire@opppidoc.fr>

   Shared database requests for enterprise search

   NOTES
   - most of the request time (maybe 90%) is spent in constructing the list of Persons attached to an Enterprise

   December 2014 - (c) Copyright 2014 Oppidoc SARL. All Rights Reserved.
   ------------------------------------------------------------------ :)

module namespace search = "http://vpi-epfl.ch/vpi-epfl/search";
import module namespace xdb = "http://exist-db.org/xquery/xmldb";
import module namespace globals = "http://oppidoc.com/ns/xcm/globals" at "../../lib/globals.xqm";
import module namespace access = "http://oppidoc.com/ns/xcm/access" at "../../../xcm/lib/access.xqm";
import module namespace display = "http://oppidoc.com/ns/xcm/display" at "../../../xcm/lib/display.xqm";

(: ======================================================================
   Generates Account information fields to display in result table
   ======================================================================
:)
declare function local:gen-account-sample($e as element(), $lang as xs:string) as element() {
    let $info := $e
    return
        if ($e/Account//text()) then
            <Account>
                {($e/Id, $info/Name, $info/WebSite)}
            <Afiliates>
            {
            for $a in $e/Account
            order by $a/Name
            return
            <Afiliate>
            {$a/Name}
            
            </Afiliate>
            
            
            }
            </Afiliates>    
            </Account>
        else
            <Account>
                {($e/Id, $info/Name, $info/WebSite)}
            
            </Account>
};

(: ======================================================================
   Returns Enterprise(s) matching request with request timing
   ======================================================================
:)
declare function search:fetch-enterprises($request as element()) as element() {
    (: FIXME: pass Enterprise for finner grain access control :)
    let $omni := access:check-entity-permissions('update', 'Enterprise')
    return
        <Results>
            <Enterprises>
                {
                    if ($omni) then
                        attribute {'Update'} {'y'}
                    else
                        (),
                    if (count($request/*/*) = 0) then (: empty request :)
                        local:fetch-all-enterprises()
                    else
                        local:fetch-some-enterprises($request)
                }
            </Enterprises>
        </Results>
};

(: ======================================================================
   Dumps all enterprises in database
   ======================================================================
:)
declare function local:fetch-all-enterprises() as element()*
{
    for $e in globals:doc('enterprises-uri')/Enterprises/Enterprise
    order by $e/Name
    return
        local:gen-account-sample($e, 'en')
};

(: ======================================================================
   Dumps a subset of enterprise filtered by criterias
   ======================================================================
:)
declare function local:fetch-some-enterprises($filter as element()) as element()*
{
    let $enterprise := $filter//EnterpriseKey/text()
    let $town := $filter//Town/text()
    let $country := $filter//Country/text()
    let $size := $filter//SizeRef/text()
    let $domain := $filter//DomainActivityRef/text()
    let $market := $filter//TargetedMarketRef/text()
    let $person := $filter//Person/text()
    return
        for $e in globals:doc('enterprises-uri')//Enterprise
        where (empty($enterprise) or $e/Id = $enterprise)
        and (empty($town) or $e//Town/text() = $town)
        and (empty($country) or $e//Country/text() = $country)
        and (empty($size) or $e//SizeRef = $size)
        and (empty($domain) or $e//DomainActivityRef = $domain)
        and (empty($market) or $e//TargetedMarketRef = $market)
        and (empty($person) or globals:collection('persons-uri')//Person[(Id = $person) and (Information/EnterpriseKey eq $e/Id)])
        order by $e/Name
        return
            local:gen-account-sample($e, 'en')
};


declare function search:fetch-all-accounts-sort-date($lang as xs:string) as element()*
{
    
    for $e in fn:doc($globals:accounts-uri)/Accounts/Account | fn:doc($globals:accounts-uri)/Accounts/GlobalAccount
    order by $e/Name
    return
        
        local:gen-account-sample($e, $lang)




};
