// https://adventofcode.com/2023/day/12
// 12/index.ts

import { setup, log } from '../lib/setup.ts'
import { nns, noblank } from '../lib/common.ts'
const { PART, INPUT } = await setup('12')

type Mapping = string
type Rules = number[]
type Row = {
  i: number
  m: Mapping
  r: Rules 
}

const input: Row[] = noblank(INPUT).map(l => l.split(' ')).map(([left, right], i) => { 
  // log({ left, right }) 
  return {
    i,
    m: left,
    r: nns(right, ',')
  }
})

function count(s: string, c: string): number {
  return s.split('').
    reduce((s, _c) => c === _c ? s + 1 : s, 0)
}

function comb(m: Mapping, i: number): Mapping {
  // every ? is a bit, i is a binary number
  const bits = count(m, '?')
  const flag = Math.pow(2, bits) - 1
  const set = flag & i
  log(m, set.toString(2))

  return ''
  // log(m, bits)
  // log(m, parseInt('1'.repeat(bits), 2))
  // log(m, )
}

function *arrangements(row: Row): Generator<Mapping> {
  const n = Math.pow(2, count(row.m, '?'))

  
  for (let i=0; i < n; i++) {
    // 
    yield `${row.i}:${i}`
  }
}

comb('?###????????', 8)

for (const row of input) {
  for (const alt of arrangements(row)) {
    // log(alt)
  }
}

if (PART === 'one') {
  log('one', input)
} else {
  log('two', INPUT)
}
