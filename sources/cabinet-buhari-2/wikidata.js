const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = function () {
  return `SELECT DISTINCT (STRAFTER(STR(?item), STR(wd:)) AS ?wdid)
               ?name ?wdLabel ?source ?sourceDate
               (STRAFTER(STR(?positionItem), STR(wd:)) AS ?pid) ?position ?start ?end
               (STRAFTER(STR(?held), '/statement/') AS ?psid)
        WHERE {
          VALUES ?positionItem {
            wd:Q500282 wd:Q2625960
            wd:Q109661491 wd:Q54600190 wd:Q108036022 wd:Q54601276 wd:Q5251230 wd:Q75153172
            wd:Q109661479 wd:Q59514359 wd:Q5449550 wd:Q3354633 wd:Q75157896 wd:Q109661410
            wd:Q109661459 wd:Q108037314 wd:Q108035710 wd:Q108035668 wd:Q106406342 wd:Q108035716
            wd:Q108037311 wd:Q109661675 wd:Q108036501 wd:Q108035729 wd:Q109661921 wd:Q111077758
            wd:Q108036175 wd:Q108037321 wd:Q108037288 wd:Q108036024 wd:Q108037328

            wd:Q111079663 wd:Q108067484 wd:Q111079668 wd:Q108037339 wd:Q111079658 wd:Q109661385
            wd:Q111079672 wd:Q111079666 wd:Q111079660 wd:Q108037343 wd:Q111079659 wd:Q111079656
            wd:Q111079664 wd:Q111079667

            wd:Q96418112 wd:Q18085838
          }

          # Who currently holds those positions
          ?item wdt:P31 wd:Q5 ; p:P39 ?held .
          ?held ps:P39 ?positionItem ; pq:P580 ?start .
          FILTER NOT EXISTS { ?held wikibase:rank wikibase:DeprecatedRank }
          OPTIONAL { ?held pq:P582 ?end }

          FILTER (?start < NOW())
          FILTER (!BOUND(?end) || ?end > "${meta.cabinet.start}T00:00:00Z"^^xsd:dateTime)

          OPTIONAL {
            ?held prov:wasDerivedFrom ?ref .
            ?ref pr:P854 ?source FILTER CONTAINS(STR(?source), '${meta.source.url}') .
            OPTIONAL { ?ref pr:P1810 ?sourceName }
            OPTIONAL { ?ref pr:P1932 ?statedName }
            OPTIONAL { ?ref pr:P813  ?sourceDate }
          }

          OPTIONAL { ?item rdfs:label ?wdLabel FILTER(LANG(?wdLabel) = "${meta.source.lang.code}") }
          BIND(COALESCE(?sourceName, ?wdLabel) AS ?name)

          OPTIONAL { ?positionItem wdt:P1705  ?nativeLabel   FILTER(LANG(?nativeLabel)   = "${meta.source.lang.code}") }
          OPTIONAL { ?positionItem rdfs:label ?positionLabel FILTER(LANG(?positionLabel) = "${meta.source.lang.code}") }
          BIND(COALESCE(?statedName, ?nativeLabel, ?positionLabel) AS ?position)
        }
        # ${new Date().toISOString()}
        ORDER BY STR(?name) STR(?position) ?began ?wdid ?sourceDate`
}
