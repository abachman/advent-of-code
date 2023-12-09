function* pairs(s: string[]): Generator<string[]> {
  for (let i = 0; i < s.length; i += 2) {
    yield [s[i], s[i + 1]]
  }
}

// '1 2 3' => [ '1', '2', '3' ]
function ns(s: string): string[] { 
  return s.split(' ').filter((v) => /\d+/.test(v)) 
}

function nns(s: string): number[] {
  return ns(s).map((v) => Number(v))
}

export { pairs, ns, nns } 


