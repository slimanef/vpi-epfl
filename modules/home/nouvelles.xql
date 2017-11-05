xquery version "1.0";
(: --------------------------------------
   Alliance web site

   Author: Stéphane Sire <s.sire@free.fr>

   Facet editor for "projets" (simple HTML form)

   December-January 2011-2012 (c) Oppidoc
   -------------------------------------- :)
   
declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace site="http://oppidoc.com/oppidum/site";

import module namespace request="http://exist-db.org/xquery/request";
import module namespace xdb = "http://exist-db.org/xquery/xmldb";
import module namespace oppidum = "http://oppidoc.com/oppidum/util" at "../../../oppidum/lib/util.xqm";

(: ======================================================================
   Returns a localized PageTitle string value
   ======================================================================
:)
declare function local:gen-page-title( $model as element(), $lang as xs:string ) as xs:string {
  let $datum := if (($lang eq 'en') and ($model/PageTitle-EN)) then $model/PageTitle-EN else $model/PageTitle
  return string($datum)
};

(: ======================================================================
   Returns a localized Summary string value
   ======================================================================
:)
declare function local:gen-summary( $model as element(), $lang as xs:string ) as xs:string {
  let $datum := if (($lang eq 'en') and ($model/Summary-EN)) then $model/Summary-EN else $model/Summary
  return string($datum)
};

(: ======================================================================
   Returns a site:view to select a projects subset
   ======================================================================
:)
declare function local:read( $lang as xs:string ) as element() {
  let $doc-uri := oppidum:path-to-ref()
  let $col-uri := replace(oppidum:path-to-ref-col(), 'pages', 'nouvelles')
  let $sel-keys := doc($doc-uri)/WebPage/News/NewsItem/string(@Key)
  let $handout := (doc($doc-uri)/WebPage/News/NewsItem[Photo]/@Key)[1] (: Deprecated :)
  let $very-old := xs:date("1901-01-01")
  let $keys := distinct-values(collection($col-uri)/Project/@Key)
  return
    <site:view>
      <site:content>
        <xhtml:h1>Sélection de nouvelles pour la page “accueil”</xhtml:h1>
        <xhtml:form action="." method="post">
          <xhtml:ul>
          {
          for $model in collection($col-uri)/Project[@Key = $keys]
          let $title := local:gen-page-title($model, $lang)
          let $date := if ($model/Edition/Date castable as xs:date) then xs:date($model/Edition/Date) else $very-old
          let $sdate := if ($model/Edition/Date) then 
                        let $d := $model/Edition/Date/text()
                        return
                          concat(' (', substring($d, 9, 2), '/', substring($d, 6, 2), '/', substring($d, 1, 4),')') 
                       else ''
          where $model[@Lang eq $lang](: or not(collection($col-uri)/Project[@Key = $model/@Key][@Lang eq $lang]):)
          order by $date descending
          return 
            if (string($model/@status) != 'archive') then
              <li xmlns="http://www.w3.org/1999/xhtml">
                <input type="radio" value="{$model/@Key}" name="phandout">
                  { if ($model/@Key eq $handout) then attribute checked { 'true'} else () }
                </input>
                <input id="{$model/@Key}" type="checkbox" value="{$model/@Key}" name="pref">
                  { if ($model/@Key = $sel-keys) then attribute checked { 'true'} else () }
                </input>
                <label for="{$model/@Key}">{$title}{$sdate}</label>
              </li>
            else
              <li xmlns="http://www.w3.org/1999/xhtml">
                <span style="color:red; background: yellow;">ARCHIVE</span><span> {$title}{$sdate}</span>
              </li>
          }
          </xhtml:ul>
          <xhtml:input type="submit"/>
          <xhtml:p>NOTE: n'oubliez pas de réenregistrer la liste si vous avec modifié le titre ou le résumé d'une nouvelle</xhtml:p>
        </xhtml:form>
      </site:content>
    </site:view>
};

(: ======================================================================
   Expands the news references submitted in the 'prefs' POST parameter
   and updates the reference resource. SHOULD be redirected per the mapping
   (classical form submissiion).
   ======================================================================
:)
declare function local:update( $lang as xs:string ) {
  let $doc-uri := oppidum:path-to-ref()
  let $proj-col-uri := replace(oppidum:path-to-ref-col(), 'pages', 'nouvelles')
  let $prefs := request:get-parameter('pref', ())
  let $handout := request:get-parameter('phandout', ())
  let $very-old := xs:date("1901-01-01")
  let $projects := 
    <News>
    {
    for $p in collection($proj-col-uri)/Project[@Key = $prefs]
    let $date := if ($p/Edition/Date castable as xs:date) then xs:date($p/Edition/Date) else $very-old
    where $p[@Lang eq $lang](: or not(collection($proj-col-uri)/Project[@Key = $p/@Key][@Lang eq $lang]):)
    order by $date descending
    return
      <NewsItem>
        {
        $p/@Key,
        <PageTitle>{local:gen-page-title($p, $lang)}</PageTitle>,
        <Summary>{local:gen-summary($p, $lang)}</Summary>,
        $p/Photo
        (:if ($handout = $p/@Key) then $p/Photo else ():)
        }
      </NewsItem>
    }
    </News>
  return
    if (doc-available($doc-uri)) then (: sanity check :)
      let $data := request:get-data()
      return
        (
        update replace doc($doc-uri)/WebPage/News with $projects,
        oppidum:add-message('ACTION-UPDATE-SUCCESS', '', true())
        )
    else
      oppidum:throw-error('DB-WRITE-INTERNAL-FAILURE-COLLECTION', ())
};

let $cmd := request:get-attribute('oppidum.command')
let $lang := string($cmd/@lang)
return
  if (request:get-method() = 'GET') then
    local:read($lang)
  else
    local:update($lang)
  
  

  