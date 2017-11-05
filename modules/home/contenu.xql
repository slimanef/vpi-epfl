xquery version "1.0";
(: ------------------------------------------------------------------
   Alliance web site

   Author: Stéphane Sire <s.sire@opppidoc.fr>

   Facet editor for "contenu" (based on an XTiger template)

   February 2012 - (c) Copyright 2012 Oppidoc SARL. All Rights Reserved.  
   ------------------------------------------------------------------ :)

import module namespace request="http://exist-db.org/xquery/request";
import module namespace oppidum = "http://oppidoc.com/oppidum/util" at "../../../oppidum/lib/util.xqm";

declare option exist:serialize "method=xml media-type=text/xml";

declare function local:read() as element() {
  let $doc-uri := oppidum:path-to-ref()
  let $data := fn:doc($doc-uri)
  return
    <WebPage>
      { $data/WebPage/Boxes }
        { $data/WebPage/PageContent/* }
    </WebPage>
};

(: ======================================================================
   Updates part of the reference resource with submitted content.
   Returns a Location header for redirection (SHOULD be called from Ajax).
   ======================================================================
:)
declare function local:update() as element() {
  let $cmd := request:get-attribute('oppidum.command')
  let $doc-uri := oppidum:path-to-ref()
  return           
    if (doc-available($doc-uri)) then (: sanity check :)
      let $data := request:get-data()
      return
        (
        update replace doc($doc-uri)/WebPage/Boxes with $data/Boxes,
        response:set-status-code(201),
        (: FIXME: use oppidum:set-location-header() :)
        let $loc := concat($cmd/@base-url, string-join((tokenize($cmd/@trail, '/')[. ne ''])[position() < last()], '/'))
        return
          response:set-header('Location', $loc), (: redirect to parent of the resource :)
        oppidum:add-message('ACTION-UPDATE-SUCCESS', '', true())
        )[last()]
    else
      oppidum:throw-error('DB-WRITE-INTERNAL-FAILURE-COLLECTION', ())
};

(:::::::::::::  BODY  ::::::::::::::)
if (request:get-method() = 'GET') then
  local:read()
else
  local:update()
