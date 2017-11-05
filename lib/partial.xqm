xquery version "1.0";
(: ------------------------------------------------------------------
   ALIEN application

   Creation: Stéphane Sire <s.sire@opppidoc.fr>
    Modification: Fouad Slimane <fouad.slimane@gmail.com>
    
   Returns diverse blocks to be inserted in the page mesh in the epilogue
   Functions defined in this module can use XPath expressions in no namespace
   which is not possible in the epilogue which sets its default namespace to XHTML

   August 2016 - (c) Copyright 2013 Oppidoc SARL. All Rights Reserved.
   ------------------------------------------------------------------ :)

module namespace partial = "http://oppidoc.com/oppidum/partial";

declare namespace xdb = "http://exist-db.org/xquery/xmldb";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
import module namespace oppidum = "http://oppidoc.com/oppidum/util" at "../../oppidum/lib/util.xqm";

import module namespace epilogue = "http://oppidoc.com/oppidum/epilogue" at "../oppidum/lib/epilogue.xqm";

declare function partial:photo ( $cmd as element() ) as element()*
{
  let $user := oppidum:get-current-user()
  let $person := fn:doc(concat($cmd/@db, '/persons/persons.xml'))/Users/User[UserProfile/Username = $user]
  return
    if (empty($person) or not($person/Photo/text())) then
      <img src="{concat(epilogue:make-static-base-url-for('vpi-epfl'), 'images/identity.png')}" alt="PHOTO {$user}"/>
    else
      <img src="{concat($cmd/@base-url,'persons/', $person/Photo)}" alt="Photo {$person/Name/LastName/text()}"/>

};

declare function partial:logo ( $cmd as element() ) as element()*
{
  
      <img src="{concat(epilogue:make-static-base-url-for('vpi-epfl'), 'images/Logo_EPFL.svg.png')}"  alt="PHOTO"/>
      
    
};
