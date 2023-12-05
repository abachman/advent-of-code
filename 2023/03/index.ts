// https://adventofcode.com/2023/day/3
// 03/index.ts

import { log, setup } from '../lib/setup.ts'

const { PART, INPUT } = await setup('03')

// convert INPUT to 2d array
const row = (i: string) => i.split('')
for (let i = 0; i < INPUT.length; i++) {
  INPUT[i] = row(INPUT[i])
}

const isNumber = (c: string) => /\d/.test(c)

// yield numbers and their (row, cols) coordinates
type Value = {
  val: number
  row: number
  cols: number[]
}

const numbers = function* (grid: Array<Array<string>>): Generator<Value> {
  for (let r = 0; r < grid.length; r++) {
    let c = 0
    let isn = false
    let cols = []

    if (grid[r].length === 0) continue

    while (c < grid[r].length) {
      if (isNumber(grid[r][c])) {
        isn = true
        cols.push(c)
      } else {
        if (isn) {
          const slice = cols.map((i) => grid[r][i]).join('')
          yield {
            val: parseInt(slice),
            row: r,
            cols,
          }
          cols = []
        }
        isn = false
      }
      c += 1
    }
    // last n characters in row were a number
    if (isn) {
      const slice = cols.map((i) => grid[r][i]).join('')
      yield {
        val: parseInt(slice),
        row: r,
        cols,
      }
      cols = []
    }
  }
}

// produce list of neighbors bordering number in (row, col[])
const neighbors = (r: number, cols: number[], grid: string[][], gears={}): number[] => {
  const ns = []
  // log('neighbors of', { r, cols })
  for (let y = r - 1; y <= r + 1; y++) {
    const a = cols[0] - 1
    const z = cols[cols.length - 1] + 1
    for (let x = a; x <= z; x++) {
      if (y === r && cols.indexOf(x) > -1) continue
      if (grid[y] && grid[y][x] && grid[y][x] !== '.' && !isNumber(grid[y][x])) {
        ns.push(grid[y][x])
        if (grid[y][x] === '*') {
          const key = `${x},${y}`
          const val = grid[r].slice(a + 1, z).join('')
          if (!gears[key]) {
            gears[key] = [ val ]
          } else {
            gears[key].push(val)
          }
        }
      }
    }
  }
  return ns
}

type Gears = {
  [key: string]: number[]
}

const possibles: Gears = { } 
const vals = []
for (const { val, row, cols } of numbers(INPUT)) {
  const n = neighbors(row, cols, INPUT, possibles)

  if (PART === 'one') {
    if (n.length > 0) {
      log('good', { val, n: n.join('') })
      vals.push(val)
    } else {
      log('bad', { val, n: n.join('') })
    }
  }
}

if (PART === 'two') {
  for (const [key, nums] of Object.entries(possibles)) {
    if (nums.length == 2) {
      log('gear', key, nums)
      vals.push(nums[0] * nums[1])
    }
  }
}

log('sum:', vals.reduce((a, b) => a + b, 0))

// for (const line of INPUT) {
//   log(line.join(''))
// }

// if (PART === 'one') {
//   log('one', INPUT)
// } else {
//   log('two', INPUT)
// }
