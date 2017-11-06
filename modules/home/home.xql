xquery version "1.0";
(: ------------------------------------------------------------------
   Alliance web site

   Author: Stéphane Sire <s.sire@opppidoc.fr>

   February 2012 - (c) Copyright 2012 Oppidoc SARL. All Rights Reserved.  
   ------------------------------------------------------------------ :)

import module namespace request="http://exist-db.org/xquery/request";
import module namespace oppidum = "http://oppidoc.com/oppidum/util" at "../../../oppidum/lib/util.xqm";
(:import module namespace search = "http://kp.ch/kp/search" at "../resources1/search.xqm";
import module namespace searchtopics = "http://kp.ch/kp/searchtopics" at "../topics1/searchtopics.xqm";:)
import module namespace search = "http://vpi-epfl.ch/vpi-epfl/search" at "../accounts/search.xqm";


declare option exist:serialize "method=xml media-type=text/xml";

(: ======================================================================
   Returns max random elements from input sequence w/o repetition
   ====================================================================== 
:)
declare function local:randomize( $in as element()*, $out as element()*, $max as xs:integer ) {
  if (count($in) <= 1) then
    ($out, $in)
  else if (count($out) >= $max) then
    $out
  else
    let $draw := util:random(count($in) - 1) + 1
    return
      local:randomize($in[position() ne $draw], ($out, $in[$draw]), $max)
};

(:::::::::::::  BODY  ::::::::::::::)

let $doc-uri := oppidum:path-to-ref()
let $cmd := request:get-attribute('oppidum.command')
let $lang := string($cmd/@lang)
return  
  let $data := fn:doc($doc-uri)
  return
      if ($data) then
        <WebPage>
          { 
          $data/WebPage/*,
          <TopAccounts>
         {search:fetch-all-accounts-sort-date($lang)[position() <=5]}
          
          </TopAccounts>,
          <TopTopics>
         <!-- {searchtopics:fetch-all-topics-sort-date($lang,<SearchTopics/>
          )[position() <=5]}-->
          </TopTopics>,
           <TopLogos>
          <!--{searchlogos:fetch-all-logos-hosts($lang)}-->
          </TopLogos>,
          fn:doc('/db/sites/vpi-epfl/pages/adresse.xml')//Address,
          fn:doc('/db/sites/vpi-epfl/global/global.xml')//Vocabulary[@Page eq 'accueil'][@Lang eq $cmd/@lang],
          <Carroussel>
           {
            let $photos := fn:doc('/db/sites/vpi-epfl/global/global.xml')//Carroussel//Photo
            let $count := number(fn:doc('/db/sites/vpi-epfl/global/global.xml')//Carroussel/Settings/Random[not(@Tag)][1]/text())
            return (
              attribute { 'Size' } { $count },
              if ($count <= count($photos)) then 
                local:randomize($photos, (), $count)
              else
                $photos
              ),
              fn:doc('/db/sites/vpi-epfl/global/global.xml')//Carroussel/Legend[@Lang eq $lang]
            }
          </Carroussel>
          }
        </WebPage>
      else
        <empty/>

