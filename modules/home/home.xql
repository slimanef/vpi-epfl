xquery version "1.0";
(: ------------------------------------------------------------------
   Alliance web site

   Author: Stéphane Sire <s.sire@opppidoc.fr>

   February 2012 - (c) Copyright 2012 Oppidoc SARL. All Rights Reserved.  
   ------------------------------------------------------------------ :)

import module namespace request="http://exist-db.org/xquery/request";
import module namespace oppidum = "http://oppidoc.com/oppidum/util" at "../../../oppidum/lib/util.xqm";
(:import module namespace search = "http://kp.ch/kp/search" at "../resources1/search.xqm";
import module namespace searchtopics = "http://kp.ch/kp/searchtopics" at "../topics1/searchtopics.xqm";
import module namespace searchlogos = "http://kp.ch/kp/searchlogos" at "../hosts/searchlogos.xqm";:)


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
          <TopResources>
         <Resource>
        <Id>1</Id>
        <Title>Business Innovation Ideas - demo</Title>
        <Keywords>
            <Keyword>Identify ideas</Keyword>
            <Keyword>strategic partnering</Keyword>
            <Keyword>business innovation roadmap</Keyword>
            <Keyword>future innovation activities</Keyword>
        </Keywords>
        <Languages>
            <Language>
                <Ref>en</Ref>
            </Language>
            <Language>
                <Ref>fr</Ref>
            </Language>
            <Language>
                <Ref>de</Ref>
            </Language>
        </Languages>
        <Authors>
            <Author>
                <Key>1</Key>
            </Author>
            <Author>
                <Key>9</Key>
            </Author>
            <Author>
                <Key>10</Key>
            </Author>
        </Authors>
        <Description>
            <Text>This tool supports the process of identifying ideas for business innovation and
                strategic partnering in SMEs. It is recommended to use this tool as the next step
                after defining a general business innovation roadmap which indicates the priority
                vectors for future innovation activities.</Text>
        </Description>
        <Label>
            <GivenBy>
                <Key>1</Key>
            </GivenBy>
        </Label>
        <Phases>
            <Phase>
                <Ref>3</Ref>
                <DateTime>2006-01-01</DateTime>
            </Phase>
        </Phases>
        <Type>
            <Ref>4</Ref>
        </Type>
        <Form>
            <Ref>2</Ref>
        </Form>
        <RelatedTopics>
            <Topic>
                <Key>3</Key>
            </Topic>
            <Topic>
                <Key>2</Key>
            </Topic>
        </RelatedTopics>
        <RelatedMarkets>
            <Market>
                <Ref>501010</Ref>
            </Market>
            <Market>
                <Ref>501020</Ref>
            </Market>
            <Market>
                <Ref>501030</Ref>
            </Market>
            <Market>
                <Ref>502010</Ref>
            </Market>
        </RelatedMarkets>
        <RelatedNaces>
            <Nace>
                <Ref>A1</Ref>
            </Nace>
            <Nace>
                <Ref>A2</Ref>
            </Nace>
            <Nace>
                <Ref>A3</Ref>
            </Nace>
            <Nace>
                <Ref>B5</Ref>
            </Nace>
            <Nace>
                <Ref>B6</Ref>
            </Nace>
        </RelatedNaces>
        <File>BI-Ideas-Tool_DEMO-3.xlsx</File>
        <Appendices>
            <Appendix>
                <File>serie5.pdf</File>
            </Appendix>
        </Appendices>
        <Downloads>
            <Download>
                <Date>2017-01-09T01:06:59</Date>
                <By>
                    <Key/>
                </By>
            </Download>
            <Download>
                <Date>2017-01-09T09:00:17</Date>
                <By>
                    <Key>5</Key>
                </By>
            </Download>
            <Download>
                <Date>2017-01-09T09:14:24</Date>
                <By>
                    <Key>1</Key>
                </By>
            </Download>
            <Download>
                <Date>2017-01-09T09:42:11</Date>
                <By>
                    <Key>5</Key>
                </By>
            </Download>
        </Downloads>
    </Resource>
          </TopResources>,
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

