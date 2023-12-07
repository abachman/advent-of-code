// https://adventofcode.com/2023/day/5
// 05/index.ts

import { setup, log } from '../lib/setup.ts'
const { PART, INPUT } = await setup('05')

// linear mapping
const map = (n: number, fromx: number, fromy: number, tox: number, toy: number): number => {
  return n * (toy - tox) / (fromy - fromx) + (tox - fromx)
}

// '1 2 3' => [ '1', '2', '3' ]
const ns = (s: string): string[] => s.split(' ').filter(v => /\d+/.test(v))

// ranges for map
const inRange = (n: number, fromx: number, fromy: number): boolean => {
  return n >= fromx && n <= fromy
}

/*
seed-to-soil map:
50 98 2
52 50 48

Each line within a map contains three numbers:
1. the destination range start,
2. the source range start
3. the range length.

Any source numbers that aren't mapped correspond to the same destination number.

seed-to-soil map:
  destination range start: 50
  source range start: 98
  range length: 2

  destination range start: 52
  source range start: 50
  range length: 48

FACTS
- seed number 98 corresponds to soil number 50
- seed number 99 corresponds to soil number 51
- seed number 53 corresponds to soil number 55
- seed number 10 corresponds to soil number 10
*/

type SeedMapping = {
  location: number
  [key: string]: number
}

type MappingRange = {
  dest: number
  source: number
  length: number
}

type Mapping = {
  from: string,
  to: string,
  ranges: MappingRange[]
}

type Mappings = {
  [key: string]: Mapping
}

const maps = {}
const seeds: { [key: string]: SeedMapping } = {}
let inmap: null | string = null
for (const line of INPUT) {
  if (/seeds:/.test(line)) {
    // initial seed values: "seeds: 79 14 55 13"
    const ss = ns(line.split(':')[1])
    for (const seed of ss) {
      seeds[seed] = { location: 0 }
    }
    continue
  }

  if (inmap) {

  }
}


if (PART === 'one') {
  log('one', seeds)
} else {
  log('two', INPUT)
}
