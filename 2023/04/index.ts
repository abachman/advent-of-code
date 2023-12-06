// https://adventofcode.com/2023/day/3
// 03/index.ts

import { log, setup } from '../lib/setup.ts'

const { PART, INPUT } = await setup('04')

const ns = (s: string): string[] => s.split(' ').filter(v => /\d+/.test(v))
const row = (i: string): [ string[], Set<string> ]=> {
  const r = i.split(/(:|\|)/)
  return [ ns(r[2]), new Set(ns(r[4])) ]
}

// convert INPUT to 2d array
const input: [ string[], Set<string> ][] = []
for (let i = 0; i < INPUT.length; i++) {
  input.push(row(INPUT[i]))
}

const _worth: { [key: number]: [ number, number ] } = {}
const worth = (idx: number, card: string[], winners: Set<string>) => {
  if (!_worth[idx]) {
    let points = 0
    let matches = 0
    card.forEach(n => {
      if (winners.has(n)) {
        matches += 1
        points = (points == 0) ? 1 : points * 2
      }
    })
    _worth[idx] = [ matches, points ]
  }

  return _worth[idx]
}

type Copies = {
  [key: number]: number[]
}

const addToCopies = (i: number, copies: Copies, matches: number) => {
  if (copies[i]) {
    copies[i].push(i)
  } else {
    copies[i] = [i]
  }

  // copies
  for (let x = i + 1; x <= i + matches; x++) {
    const [ card, winners ] = input[x]
    addToCopies(x, copies, worth(x, card, winners)[0])
  }
}

let sum = 0
const copies: Copies = {}
for (let i = 0; i < input.length; i++) {
  const [ card, winners ] = input[i]
  const [ matches, score ] = worth(i, card, winners)

  sum += score
  addToCopies(i, copies, matches)
}

log('part one:', sum)
log('part two:', Object.values(copies).reduce((a, b) => a + b.length, 0))


