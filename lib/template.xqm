xquery version "1.0";
(: --------------------------------------
   Case tracker pilote application

   Creator: Stéphane Sire <s.sire@oppidoc.fr>

   Data template functions to use templates in templates.xml

   When you do not need to call custom functions in your data 
   templates you can call functions from XCM crud module.

   Otherwise copy paste the CRUD function you need from the
   crud module here so that you can import custom modules 
   (e.g. custom:gen-case-title)

   Customize this file for your application

   November 2016 - (c) Copyright 2016 Oppidoc SARL. All Rights Reserved.
   ----------------------------------------------- :)

module namespace template = "http://oppidoc.com/ns/ctracker/template";

import module namespace request="http://exist-db.org/xquery/request";
import module namespace oppidum = "http://oppidoc.com/oppidum/util" at "../../oppidum/lib/util.xqm";
import module namespace globals = "http://oppidoc.com/ns/xcm/globals" at "globals.xqm";
import module namespace misc = "http://oppidoc.com/ns/xcm/misc" at "../../xcm/lib/util.xqm";
import module namespace xal = "http://oppidoc.com/ns/xcm/xal" at "../../xcm/lib/xal.xqm";
import module namespace user = "http://oppidoc.com/ns/xcm/user" at "../../xcm/lib/user.xqm";
import module namespace database = "http://oppidoc.com/ns/xcm/database" at "../../xcm/lib/database.xqm";
import module namespace crud = "http://oppidoc.com/ns/xcm/crud" at "../../xcm/lib/crud.xqm";
import module namespace display = "http://oppidoc.com/ns/xcm/display" at "../../xcm/lib/display.xqm";
import module namespace enterprise = "http://oppidoc.com/ns/xcm/enterprise" at "../../xcm/modules/enterprises/enterprise.xqm";
import module namespace custom = "http://oppidoc.com/ns/application/custom" at "../app/custom.xqm";
import module namespace feedback = "http://oppidoc.com/ns/feedback" at "../lib/feedback.xqm";

declare function template:get-document( $name as xs:string, $case as element(), $lang as xs:string ) as element() {
  template:get-document($name, $case, (), $lang)
};

declare function template:get-document( $name as xs:string, $case as element(), $activity as element()?, $lang as xs:string ) as element() {
  let $src := globals:collection('templates-uri')//Template[@Mode eq 'read'][@Name eq $name]
  return
    if ($src) then
      custom:unreference(util:eval(string-join($src/text(), ''))) (: FIXME: $lang :)
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for read mode'))
};

declare function template:save-document( $name as xs:string, $case as element(), $form as element() ) as element() {
  crud:save-document($name, $case, (), $form)
};

declare function template:get-vanilla( $document as xs:string, $case as element(), $activity as element()?, $lang as xs:string ) as element() {
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'read'][@Name eq 'vanilla']
  return
    if ($src) then
      custom:unreference(util:eval(string-join($src/text(), ''))) (: FIXME: $lang :)
    else
      oppidum:throw-error('CUSTOM', concat('Missing vanilla template for read mode'))
};

declare function template:save-document(
  $name as xs:string, 
  $case as element(), 
  $activity as element(), 
  $form as element() 
  ) as element()
{
  crud:save-document($name, $case, $activity, $form)
};

(: ======================================================================
   TODO: check xal:apply-updates results
   ====================================================================== 
:)
declare function template:save-vanilla(
  $document as xs:string, 
  $case as element(), 
  $activity as element(), 
  $form as element() 
  ) as element()
{
  let $date := current-dateTime()
  let $uid := user:get-current-person-id() 
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'update'][@Name eq 'vanilla']
  return
    if ($src) then
      let $delta := misc:prune(util:eval(string-join($src/text(), '')))
      return (
        xal:apply-updates(if ($activity) then $activity else $case, $delta),
        oppidum:throw-message('ACTION-UPDATE-SUCCESS', ())
        )[last()]
    else
      oppidum:throw-error('CUSTOM', concat('Missing vanilla template for update mode'))
};

(:=== DEPRECATED FROM ABOVE =======:)

(: ======================================================================
   Generates a document from a named template in a given mode 
   from submitted form data
   TODO: add extra parameters to persists legacy data if necessary
   ====================================================================== 
:)
declare function template:gen-document( $name as xs:string, $mode as xs:string, $form as element()? ) as element()
{
  let $date := current-dateTime()
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq $mode][@Name eq $name]
  return
    if ($src) then
      misc:prune(util:eval(string-join($src/text(), '')))
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for "',$mode ,'" mode'))
};

(: ======================================================================
   Generates a model from $name data template and $subject data for transclusion
   ====================================================================== 
:)
declare function template:gen-transclusion( $name as xs:string, $id as xs:string?, $subject as element()? ) as element() {
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'transclusion'][@Name eq $name]
  let $date := current-dateTime()
  return
    if ($src) then
      custom:unreference(util:eval(string-join($src/text(), '')))
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for transclusion mode'))
};

(: ======================================================================
   Generates a model from $name data template (read mode) and $subject data
   ====================================================================== 
:)
declare function template:gen-read-model( $name as xs:string, $subject as element(), $lang as xs:string ) as element()* {
  template:gen-read-model($name, $subject, (), $lang)
};

(: ======================================================================
   Generates a model from $name data template (read mode) and $subject data 
   and optional $object data
   QURSTION: should we prune ?
   ====================================================================== 
:)
declare function template:gen-read-model( $name as xs:string, $subject as element(), $object as element()?, $lang as xs:string ) as element()* {
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'read'][@Name eq $name]
  let $date := current-dateTime()
  return
    if ($src) then
      if (empty($src/@Assert) or util:eval($src/@Assert)) then 
        misc:prune(custom:unreference(util:eval(string-join($src/text(), '')))) (: FIXME: $lang :)
      else
        let $src := fn:collection($globals:templates-uri)//Template[@Mode eq $src/@Fallback][@Name eq $name]
        return
          if ($src) then
            misc:prune(custom:unreference(util:eval(string-join($src/text(), '')))) (: FIXME: $lang :)
          else
            oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for read mode'))
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for read mode'))
};

(: ======================================================================
   Generates a model from $name data template (read mode) with $id identifier 
   and $subject data. The $id is useful to extract data from a container.
   ====================================================================== 
:)
declare function template:gen-read-model-id( $name as xs:string, $id as xs:string, $subject as element(), $lang as xs:string ) as element()* {
  template:gen-read-model-id($name, $id, $subject, (), $lang)
};

(: ======================================================================
   Generates a model from $name data template (read mode) with $id identifier 
   and $subject data and optional $object data. The $id is useful to extract data from a container.
   ====================================================================== 
:)
declare function template:gen-read-model-id( $name as xs:string, $id as xs:string, $subject as element(), $object as element()?, $lang as xs:string ) as element()* {
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'read'][@Name eq $name]
  return
    if ($src) then
      custom:unreference(util:eval(string-join($src/text(), ''))) (: FIXME: $lang :)
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for read mode'))
};

(: ======================================================================
   Generates a data model from the $name data template (create mode) 
   and the $form submitted data, using an $id identifier.
   The optional $creator-ref may be used to override the $uid variable which 
   is set to the current person id otherwise.
   Does not save into database (use create-resource for that purpose).
   ====================================================================== 
:)
declare function template:gen-create-model-id(
  $name as xs:string, 
  $id as xs:string?,
  $form as element(), 
  $creator-ref as xs:string? 
  ) as element()
{
  let $date := current-dateTime()
  let $uid := if ($creator-ref) then $creator-ref else user:get-current-person-id()
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'create'][@Name eq $name]
  return
    if ($src) then
      misc:prune(util:eval(string-join($src/text(), '')))
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for create mode'))
};

(: ======================================================================
   Generates and applies a XAL sequence from the $name data template (update mode)
   combining data from the submitted $form data and the database $subject.
   Usually the XAL sequence replaces the $subject.
   ====================================================================== 
:)
declare function template:update-resource( $name as xs:string, $subject as element(), $form as element() ) as element() {
  template:update-resource-id($name, (), $subject, (), $form)
};

(: ======================================================================
   Generates and applies a XAL sequence from the $name data template (update mode)
   combining data from the submitted $form data and the database $subject.
   The identifier $id can be used to extract/persists data from the $subject 
   when it contains several resources.
   Usually the XAL sequence replaces the resource matching the identifier $id
   of the the $subject.
   ====================================================================== 
:)
declare function template:update-resource-id( $name as xs:string, $subject as element(), $id as xs:string, $form as element() ) as element() {
  template:update-resource-id($name, $id, $subject, (), $form)
};

(: ======================================================================
   Generates and applies a XAL sequence from the $name data templates (update mode)
   combining data from the submitted $form data and the database $subject
   and an optional database $object.
   Usually the XAL sequence replaces the $subject and maintains some form 
   of relation in the $object (or vice versa).
   ====================================================================== 
:)
declare function template:update-resource(
  $name as xs:string, 
  $subject as element(), 
  $object as element()?, 
  $form as element() 
  ) as element()
{
  template:update-resource-id($name, (), $subject, $object, $form)
};


(: ======================================================================
   Facade that throws an oppidum ACTION-UPDATE-SUCCESS message on success
   ====================================================================== 
:)
declare function template:update-resource-id(
  $name as xs:string, 
  $id as xs:string?,
  $subject as element(), 
  $object as element()?, 
  $form as element() 
  ) as element()
{
  let $res := template:do-update-resource($name, $id, $subject, $object, $form)
  return  
    if (local-name($res) ne 'error') then
      oppidum:throw-message('ACTION-UPDATE-SUCCESS', ())
    else
      $res
};

declare function local:get-dependencies( $name as xs:string, $subject as item()*, $object as item()* ) as element()*
{
  for $d in fn:collection($globals:templates-uri)//Template[@Mode eq 'dependency'][@Name eq $name]
  where empty($d/@Assert) or util:eval($d/@Assert)
  return $d
};

(: ======================================================================
   Generates and applies a XAL sequence from the $name data template (update mode)
   combining data from the submitted $form data and the database $subject
   and an optional database $object.
   Usually the XAL sequence replaces the resource matching the identifier $id
   of the the $subject and/or of the $object and maintains some form of relation
   between both.
   FIXME: errors on dependencies ?
   ====================================================================== 
:)
declare function template:do-update-resource(
  $name as xs:string, 
  $id as xs:string?,
  $subject as item()*, 
  $object as item()*, 
  $form as element() 
  ) as element()
{
  let $date := current-dateTime()
  let $uid := user:get-current-person-id() 
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'update'][@Name eq $name]
  let $lang := 'en' (: FIXME: parameter :)
  return
    if (exists($src)) then
      if (empty($src/@Assert) or util:eval($src/@Assert)) then 
        let $delta := misc:prune(util:eval(string-join($src/text(), '')))
        let $res := xal:apply-updates($subject, $object, $delta)
        return
          if (local-name($res) ne 'error') then (: chains with dependencies :)
            (
            let $dependencies := local:get-dependencies($name, $subject, $object)
            return
              for $d in $dependencies
              let $delta := misc:prune(util:eval(string-join($d/text(), '')))
              return xal:apply-updates($subject, $object, $delta),
            $res
            )[last()]
          else
            $res
      else (: fallback mechanism - TODO: factorize :)
        let $src := fn:collection($globals:templates-uri)//Template[@Mode eq $src/@Fallback][@Name eq $name]
        return
          if ($src) then
            let $delta := misc:prune(util:eval(string-join($src/text(), '')))
            let $res := xal:apply-updates($subject, $object, $delta)
            return
              if (local-name($res) ne 'error') then (: chains with dependencies :)
                (
                let $dependencies := local:get-dependencies($name, $subject, $object)
                return
                  for $d in $dependencies
                  let $delta := misc:prune(util:eval(string-join($d/text(), '')))
                  return xal:apply-updates($subject, $object, $delta),
                $res
                )[last()]
              else
                $res
          else
            oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for ', $src/@Fallback, ' mode'))
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for update mode'))
};

(: ======================================================================
   Generic version of template:do-create-resource that throws an oppidum
   success message in case of success (useful to respond to Ajax protocol)
   ====================================================================== 
:)
declare function template:create-resource(
  $name as xs:string, 
  $subject as element()?, 
  $object as element()?, 
  $form as element(), 
  $creator-ref as xs:string? 
  ) as element()?
{
  let $res := template:do-create-resource($name, $subject, $object, $form, $creator-ref)
  return  
    if (local-name($res) ne 'error') then
      oppidum:throw-message('ACTION-CREATE-SUCCESS', ())
    else
      $res
};

(: ======================================================================
   Generates and applies a XAL sequence from the $name data template (create mode)
   combining data from the submitted $form data and the database $subject
   and an optional database $object. 
   The optional $creator-ref may be used to override the $uid variable which 
   is set to the current person id otherwise.
   Logically the XAL sequence should create a new document or at least insert 
   the new resource inside the $subject and/or $object.
   By convention sets a $mode to 'batch' when $creator-ref is '-1'. Use this 
   to disconnect invalidate XAL action when doing a batch.
   FIXME: current API limited to 1 create XAL action per sequence !!!
   ====================================================================== 
:)
declare function template:do-create-resource(
  $name as xs:string, 
  $subject as item()*, 
  $object as item()*, 
  $form as element(), 
  $creator-ref as xs:string? 
  ) as element()?
{
  let $date := current-dateTime()
  let $uid := if ($creator-ref) then $creator-ref else user:get-current-person-id()
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'create'][@Name eq $name]
  let $mode := if ($creator-ref eq '-1') then 'batch' else 'interactive'
  return
    if ($src) then
      let $id := (: generates new keys for XAL create action if any :)
        if (contains($src,'Type="create"')) then 
          let $db-uri := string(oppidum:get-command()/@db)
          let $entity := substring-before(substring-after($src, 'Entity="'), '"')
          return database:make-new-key-for($db-uri, $entity)
        else
          ()
      return
        let $delta := misc:prune(util:eval(string-join($src/text(), '')))
        return 
          xal:apply-updates($subject, $object, $delta)
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for create mode'))
};

(: ======================================================================
   ====================================================================== 
:)
declare function template:do-create-archive(
  $name as xs:string, 
  $subject as item()*, 
  $object as item()*, 
  $form as element()
  ) as element()?
{
  let $date := current-dateTime()
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'archive'][@Name eq $name]
  return
    if ($src) then
      let $delta := misc:prune(util:eval(string-join($src/text(), '')))
      return 
        xal:apply-updates($subject, $object, $delta)
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for archive mode'))
};

(: ======================================================================
   Returns the archived dead copy if it exists or generates a live copy
   from a source transclusion block (entity key and optional Archive)
   The source MUST contain the reference to then entity to take as source 
   as the text content of its first child element
   FIXME: subject setting could be moved to custom module ?
   ====================================================================== 
:)
declare function template:transclude( $name as xs:string, $source as element()? ) as element()* {
  let $ref := $source/*[1]
  return
    if (exists($source/Archive)) then
      template:gen-transclusion($name, $ref, $source/Archive)
    else if ($ref and ($name = ('enterprise', 'partner'))) then 
      template:gen-transclusion($name, $ref, globals:doc('enterprises-uri')//Enterprise[Id eq $ref]/Information)
    else if ($ref and ($name eq 'person')) then 
      template:gen-transclusion($name, $ref, globals:collection('persons-uri')//Person[Id eq $ref]/Information)
    else
      ()
};

(: ======================================================================
   Makes an archive for dead copy persistent storage from the form data
   If there is already an existing archive then updates it only if 
   the form data is different.
   TODO: implement with "archive" data template
   ====================================================================== 
:)
declare function template:archive( $name as xs:string, $archive as element()?, $form as element()? ) as element()? {
  if (exists($archive)) then
    (: FIXME: to be implemented using template:gen-archive-model and deep-equal :)
    ()
  else 
    ()
};

(: ======================================================================
   Applies an "evaluation" data template. The template must contain some 
   XAL actions that returns either success or an error.
   WARNING: does not prune the template
   ====================================================================== 
:)
declare function template:do-validate-resource(
  $name as xs:string, 
  $subject as item()*, 
  $object as item()*, 
  $form as element()
  ) as element()?
{
  let $date := current-dateTime()
  let $uid := user:get-current-person-id()
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq 'validate'][@Name eq $name]
  return
  if ($src) then
    let $delta := util:eval(string-join($src/text(), ''))
    let $res := xal:apply-updates($subject, $object, $delta)
    return
      if (local-name($res) ne 'error') then
        <valid/>
      else
        $res
  else
    oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for validate mode'))
};

(: ======================================================================
   Generates a model for inclusion within another template
   See also: template:gen-read-model
   ====================================================================== 
:)
declare function local:gen-inclusion( $name as xs:string, $mode as xs:string, $subject as element(), $object as element()?, $form as element()?, $lang as xs:string ) as element()* {
  let $src := fn:collection($globals:templates-uri)//Template[@Mode eq $mode][@Name eq $name]
  let $date := current-dateTime()
  return
    if ($src) then
      if (empty($src/@Assert) or util:eval($src/@Assert)) then 
        util:eval(string-join($src/text(), '')) (: FIXME: $lang :)
      else
        let $src := fn:collection($globals:templates-uri)//Template[@Mode eq $src/@Fallback][@Name eq $name]
        return
          if ($src) then
            util:eval(string-join($src/text(), '')) (: FIXME: $lang :)
          else
            oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for read mode'))
    else
      oppidum:throw-error('CUSTOM', concat('Missing "', $name, '" template for read mode'))
};

(: ======================================================================
   Primitive to include a template (read mode) inside another template
   ====================================================================== 
:)
declare function template:include( $name as xs:string, $subject as element()?, $object as element()?, $lang as xs:string ) as element()* {
  local:gen-inclusion($name, 'read', $subject, $object, (), $lang)
};

(: ======================================================================
   Primitive to include a template (update mode) inside another template
   ====================================================================== 
:)
declare function template:include( $name as xs:string, $subject as element()?, $object as element()?, $form as element(), $lang as xs:string ) as element()* {
  local:gen-inclusion($name, 'update', $subject, $object, $form, $lang)
};
