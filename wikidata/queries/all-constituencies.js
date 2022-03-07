module.exports = function () {
  return `SELECT DISTINCT ?item ?itemLabel ?state ?stateLabel
  WHERE {
    ?item wdt:P31 wd:Q59680832 .
    OPTIONAL { ?item wdt:P131 ?state }

    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
  }
  # ${new Date().toISOString()}
  ORDER BY ?stateLabel ?itemLabel`
}
