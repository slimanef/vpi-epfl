xquery version "1.0";
(: --------------------------------------
   Alliance web site

   Author: Stéphane Sire <s.sire@free.fr>

   Facet editor for "manifestations" (simple HTML form)

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
   Returns a site:view to select a projects subset
   ======================================================================
:)
declare function local:read( $lang as xs:string ) as element() {
  let $doc-uri := oppidum:path-to-ref()
  let $col-uri := replace(oppidum:path-to-ref-col(), 'pages', 'manifestations')
  let $sel-keys := doc($doc-uri)/WebPage/Events/Event/string(@Key)
  return
    <site:view>
      <site:content>
        <xhtml:h1>Sélection de manifestations pour la page “accueil”</xhtml:h1>
        <xhtml:form action="." method="post">
          <xhtml:ul>
          {
          for $model in collection($col-uri)/Event
          let $title := local:gen-page-title($model, $lang)
          let $date := concat($model/Date/Day, '/', $model/Date/Month, '/', $model/Date/Year)
          order by number($model/Date/Year) descending, number($model/Date/Month) descending, number($model/Date/Day) descending
          return 
            if (string($model/@status) != 'archive') then
              <li xmlns="http://www.w3.org/1999/xhtml">
                <input id="{$model/@Key}" type="checkbox" value="{$model/@Key}" name="eref">
                  { if ($model/@Key = $sel-keys) then attribute checked { 'true'} else () }
                </input>
                <label for="{$model/@Key}">{$title} ({$date})</label>
              </li>
            else
              <li xmlns="http://www.w3.org/1999/xhtml"><span style="color:red; background: yellow;"> ARCHIVE </span><span>{$title} ({$date})</span></li>
          }
          </xhtml:ul>
          <xhtml:input type="submit"/>
          <xhtml:p>NOTE: n'oubliez pas de revalider la liste si vous avec modifié le titre ou la date d'une manifestation</xhtml:p>
        </xhtml:form>
      </site:content>
    </site:view>
};

(: ======================================================================
   Expands the project references submitted in the 'prefs' POST parameter
   and updates the reference resource. SHOULD be redirected per the mapping
   (classical form submissiion).
   ======================================================================
:)
declare function local:update( $lang as xs:string ) {
  let $doc-uri := oppidum:path-to-ref()
  let $proj-col-uri := replace(oppidum:path-to-ref-col(), 'pages', 'manifestations')
  let $erefs := request:get-parameter('eref', ())
  let $events := 
    <Events>
    {
    for $e in collection($proj-col-uri)/Event
    where $e/@Key = $erefs
    order by number($e/Date/Year) ascending, number($e/Date/Month) ascending, number($e/Date/Day) ascending
    return
      <Event>
        {
        $e/@Key,
        $e/Illustration,
        <PageTitle>{local:gen-page-title($e, $lang)}</PageTitle>,
        $e/Date,
        $e/Place
        }
      </Event>
    }
    </Events>
  return
    if (doc-available($doc-uri)) then (: sanity check :)
      let $data := request:get-data()
      return
        (
        update replace doc($doc-uri)/WebPage/Events with $events,
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
  