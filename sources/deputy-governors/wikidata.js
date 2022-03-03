module.exports = function () {
  return `SELECT ?state ?stateLabel ?deputy ?deputyLabel ?position ?positionLabel (YEAR(?startDate) as ?start) ?end
  WHERE {
    ?gov_posn wdt:P279 wd:Q56284759; wdt:P2098 ?position.
    ?deputy p:P39 ?ps .
    ?ps ps:P39 ?position ; pq:P580 ?startDate .
    OPTIONAL { ?ps pq:P582 ?end }
    OPTIONAL { ?gov_posn wdt:P1001 ?state }
    FILTER (!BOUND(?end) || (?end >= NOW()))
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
  }
  # ${new Date().toISOString()}
  ORDER BY ?stateLabel ?startDate`
}
