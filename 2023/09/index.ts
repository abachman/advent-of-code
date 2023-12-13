// https://adventofcode.com/2023/day/9
// 09/index.ts

import { setup, log } from '../lib/setup.ts'
import { nns, noblank } from '../lib/common.ts'

const { PART, INPUT } = await setup('09')

const input = noblank(INPUT).map(nns)

const tower = (line: number[]): [number, number] => {
  const levels: number[][] = [ line, [] ]
  let c = 0, n = 1
  let ct = 0
  while (true) {
    for (let i = 1; i < levels[c].length; i++) {
      const [a, b] = [levels[c][i - 1], levels[c][i]]
      levels[n].push(b - a)
    }

    if (levels[n].some(v => v !== 0)) {
      levels.push([])
      c += 1
      n += 1
    } else { 
      break
    }
    ct++ 
  }

  levels[levels.length - 1].push(0)

  // consider the levels in reverse order
  // PART_ONE
  for (let i = levels.length - 1; i >= 1; i--) {
    // PART_ONE
    const c = levels[i],
          n = levels[i - 1],
          lc = c[c.length - 1],
          ln =  n[n.length - 1]

    levels[i - 1].push(ln + lc) 

    // PART_TWO
    const fc = c[0], fn = n[0]
    levels[i - 1].unshift(fn - fc)
  }

  return [ 
    levels[0][levels[0].length - 1], // one
    levels[0][0]     // two
  ]
}

let sumOne = 0
let sumTwo = 0
input.map(l => tower(l)).forEach(([one, two]) => {
  sumOne += one
  sumTwo += two
})

log('one', sumOne)
log('two', sumTwo)
