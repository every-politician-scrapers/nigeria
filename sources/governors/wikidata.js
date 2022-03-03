module.exports = function () {
  return `SELECT ?state ?stateLabel ?governor ?governorLabel ?position ?positionLabel (YEAR(?startDate) as ?year) ?end
  WHERE {
    ?position wdt:P279 wd:Q56284759.
    ?governor p:P39 ?ps .
    ?ps ps:P39 ?position ; pq:P580 ?startDate .
    OPTIONAL { ?ps pq:P582 ?end }
    OPTIONAL { ?position wdt:P1001 ?state }
    FILTER (!BOUND(?end) || (?end >= NOW()))
    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
  }
  # ${new Date().toISOString()}
  ORDER BY ?stateLabel ?startDate`
}
