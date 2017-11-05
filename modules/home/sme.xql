xquery version "1.0";
(: ------------------------------------------------------------------
   RAS - Reporters Association Switzerland
   
   About association model

   Contributor(s): Christine Vanoirbeek 

   October 2015 
   ------------------------------------------------------------------ :)

import module namespace request="http://exist-db.org/xquery/request";
import module namespace validation="http://exist-db.org/xquery/validation";
import module namespace util="http://exist-db.org/xquery/util";

import module namespace oppidum = "http://oppidoc.com/oppidum/util" at "../../../oppidum/lib/util.xqm";

import module namespace globals="http://oppidoc.com/oppidum/globals" at "../../lib/globals.xqm";
import module namespace access="http://oppidoc.com/oppidum/access" at "../../lib/access.xqm";


declare option exist:serialize "method=xml media-type=text/xml";

let $cmd := oppidum:get-command()

let $target := fn:doc(oppidum:path-to-ref())//WebPage

return
  <Root>
    <Actions>
    {
    if (access:page-edit-allowed('sme')) then
    (
        <Action Name="edit">{concat($cmd/@base-url,$cmd/@trail,'/edit')}</Action>
(:        <Action Name="upload-photo">{concat($cmd/@base-url,$cmd/@trail,'/upload-photo')}</Action>:)
   )
   else ()
    }
    </Actions>
    {$target}
  </Root>
  

