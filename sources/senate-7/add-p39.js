const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (id, district) => {
  position = 'Q19822359'

  qualifier = { P2937: meta.term.id }
  if(district) qualifier['P768'] = district

  return {
    id,
    claims: {
      P39: {
        value: position,
        qualifiers: qualifier,
        references: { P4656: meta.source }
      }
    }
  }
}
