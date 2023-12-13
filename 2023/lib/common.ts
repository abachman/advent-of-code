export function* pairs(s: string[]): Generator<string[]> {
  for (let i = 0; i < s.length; i += 2) {
    yield [s[i], s[i + 1]]
  }
}

// '1 2 3' => [ '1', '2', '3' ]
export function ns(s: string): string[] { 
  return s.split(' ').filter((v) => /-?\d+/.test(v)) 
}

export function nns(s: string): number[] {
  return ns(s).map((v) => Number(v))
}

export function noblank(lines: string[]): string[] {
  return lines.filter((v) => v.trim().length > 0)
}


