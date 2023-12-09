// https://adventofcode.com/2023/day/5
// 05/index.ts

import { log, setup } from '../lib/setup.ts'
const { PART, INPUT } = await setup('05')

function* pairs(s: string[]): Generator<string[]> {
  for (let i = 0; i < s.length; i += 2) {
    yield [s[i], s[i + 1]]
  }
}

// '1 2 3' => [ '1', '2', '3' ]
const ns = (s: string): string[] => s.split(' ').filter((v) => /\d+/.test(v))

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

type Range = { start: number; end: number }
type SeedMapping<T> = {
  [key: string]: T
  // seed: T
  // soil?: T
  // fertilizer?: T
  // water?: T
  // light?: T
  // temperature?: T
  // humidity?: T
  // location?: T
}
type MappingRange = {
  dest: Range
  source: Range
}

// ranges for map
const inRange = (n: number, range: MappingRange): boolean => {
  return n >= range.source.start && n <= range.source.end
}

const toDestination = (n: number, range: MappingRange): number => {
  return n + (range.dest.start - range.source.start)
}

// any part of a overlaps b
const overlaps = (range: Range, mapping: MappingRange): boolean => {
  return (
    inRange(range.start, mapping) ||
    inRange(range.end, mapping) ||
    (range.start < mapping.source.start && range.end > mapping.source.end)
  )
}

type SplitRange = {
  mapped?: Range
  remaining: Range[]
}

// given an input range and a mapping range,
// split the input according to the mapping range
// return an object containing:
// - 0 or 1 remapped seeds
// - 0, 1, or 2 unremapped seeds
const splitRange = (range: Range, mapping: MappingRange): SplitRange => {
  if (!overlaps(range, mapping)) {
    // easiest case, no overlapping
    return { remaining: [range] }
  } else if (range.start < mapping.source.start) {
    // range starts before mapping
    // left split
    const remaining = [{
      start: range.start,
      end: mapping.source.start - 1,
    }]

    // right splits
    const result = splitRange(
      {
        start: mapping.source.start,
        end: range.end,
      },
      mapping,
    )

    return { mapped: result.mapped, remaining: [...remaining, ...result.remaining] }
  } else {
    // range starts at or after mapping.source.start and
    // range is covered by mapping.source
    if (range.end <= mapping.source.end) {
      // range is contained within mapping.source
      return {
        mapped: {
          start: toDestination(range.start, mapping),
          end: toDestination(range.end, mapping),
        },
        remaining: [],
      }
    } else {
      // range ends after mapping.source.end
      return {
        mapped: {
          start: toDestination(range.start, mapping),
          end: toDestination(mapping.source.end, mapping),
        },
        remaining: [{
          start: mapping.source.end + 1,
          end: range.end,
        }],
      }
    }
  }
}

const lineToRange = (line: string): MappingRange => {
  const [dest, source, length] = ns(line).map((n) => Number(n))
  return {
    dest: { start: dest, end: dest + length - 1 },
    source: { start: source, end: source + length - 1 },
  }
}

type Mapping = {
  from: string
  to: string
  ranges: MappingRange[]
}

type Mappings = {
  [key: string]: Mapping
}

// do part one and two at the same time
const seeds: { [key: string]: SeedMapping<number> } = {}
const twoSeeds: { [key: string]: SeedMapping<Range[]> } = {}

let inmap = false
let mapping: Mapping = { from: '', to: '', ranges: [] }
const mappings: Mappings = {}
// parse + build data structures
for (const line of INPUT) {
  if (/seeds:/.test(line)) {
    // initial seed values: "seeds: 79 14 55 13"
    const ss = ns(line.split(':')[1])

    // part one
    for (const seed of ss) {
      seeds[seed] = { seed: Number(seed), location: 0 }
    }

    // part two
    for (const [seed, length] of pairs(ss)) {
      const start = Number(seed)
      const end = start + Number(length) - 1
      twoSeeds[seed] = {
        seed: [{ start, end }],
      }
    }

    continue
  }

  if (inmap) {
    if (line === '') {
      inmap = false
      continue
    } else {
      const range = lineToRange(line)
      mapping.ranges.push(range)
    }
  } else if (/^[a-z]+/.test(line)) {
    // line is a mapping start like "seed-to-soil map:"
    const [from, _, to] = line.split(/-| /)
    mapping = { from, to, ranges: [] }
    inmap = true
    mappings[from] = mapping
  }
}

Object.entries(mappings).forEach(([from, mapping]) => {
  const to = mapping.to
  log('--------------- mapping', { from, to: mapping.to })
  for (const range of mapping.ranges) {
    for (const sk in seeds) {
      // part one
      const seed = seeds[sk]
      const loc = seed[from]
      if (inRange(loc, range)) {
        const toDest = toDestination(loc, range)
        seed[to] = toDest
      }
    }
  }

  // make sure every seed has an entry for the mapping.to
  for (const sk in seeds) {
    const seed = seeds[sk]
    if (!seed[mapping.to]) {
      seed[to] = seed[from]
    }
  }

  // part two goes seeds first, then ranges
  for (const sk in twoSeeds) {
    const seed = twoSeeds[sk]
    const seedRanges = seed[from]
    seed[to] = []

    let remaining = seedRanges
    for (const range of mapping.ranges) {
      let nextRemaining: Range[] = []
      for (const remain of remaining) {
        const split = splitRange(remain, range)
        nextRemaining = [...nextRemaining, ...split.remaining]
        if (split.mapped) {
          seed[to] = [...seed[to], split.mapped]
        }
      }
      remaining = nextRemaining
    }
    seed[to] = [...seed[to], ...remaining]
  }
})

const leastStart = (ranges: Range[]): number => {
  return ranges.reduce((acc, r) => Math.min(acc, r.start), Infinity)
}

const locations = Object.values(seeds).map((s) => s.location)

// one 389056265
// two 137516820

log('one', locations.sort((a: number, b: number) => a - b)[0])
log(
  'two',
  Object
    .values(twoSeeds)
    .map((s) => leastStart(s.location))
    .sort((a, b) => a - b)[0],
)

for (const sk in twoSeeds) {
  const seed = twoSeeds[sk]
  log(sk, seed)
}
