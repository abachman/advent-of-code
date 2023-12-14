// https://adventofcode.com/2023/day/10
// 10/index.ts

import { setup, log, c } from '../lib/setup.ts'

const { PART, INPUT } = await setup('10')

const input = INPUT.map(l => l.split(''))

for (const row of input) {
  log(row.map(v => v === 'S' ? c(v) : v).join(''))
}

function to(at: [number, number], from: [number, number]): [number, number, number, number] {
  const [x, y] = at, [fx, fy] = from
  const cell = input[y][x]
  const go = (nx: number, ny: number): [number, number, number, number]  => {
    return [...at, nx, ny]
  }

  switch (cell) {
    case 'J': //  W - N
      return (fy === y) ? go(x, y - 1) : go(x - 1, y)
    case 'L': //  N - E
      return (fx === x) ? go(x + 1, y) : go(x, y - 1)
    case 'F': //  E - S
      return (fy === y) ? go(x, y + 1) : go(x + 1, y)
    case '7': //  S - W
      return (fx === x) ? go(x - 1, y) : go(x, y + 1)
    case '-' : //  W - E
      return (fx === x - 1) ? go(x + 1, y) : go(x - 1, y)
    case '|' : //  N - S
      return (fy === y - 1) ? go(x, y + 1) : go(x, y - 1)
    case '.' : //  N - S
    default:
      log('error', [x, y], [fx, fy])
      return [-1, -1, -1, -1]
  }
}

// emits path coordinates, starting at S
function *step(grid: string[][], start: [number, number]): Generator<[number, number]> {
  // x,y: starting cell
  let [x, y] = start, sx = x, sy = y

  // pick the first direction which reaches S
  if ('7|F'.includes(grid[y-1][x])) {
    sy -= 1
  } else if ('J|L'.includes(grid[y+1][x])) {
    sy += 1
  } else if ('J-7'.includes(grid[y][x-1])) {
    sx -= 1
  } else if ('L-F'.includes(grid[y][x+1])) {
    sx += 1
  }

  let cell = grid[sy][sx]
  log('start', { from: [x, y], at: [sx, sy], cell })

  while (cell !== 'S') {
    yield [sx, sy]

    ;[x, y, sx, sy] = to([sx, sy], [x, y])
    cell = grid[sy][sx]
  }
}

const findStart = (grid: string[][]): [number, number] => {
  for (let y=0; y < grid.length; y++) {
    for (let x=0; x < grid[y].length; x++) {
      if (grid[y][x] === 'S') {
        return [x, y]
      }
    }
  }
  return [-1, -1]
}

//     N
//   J   L
// W   +   E
//   7   F
//     S

const at = findStart(input)

let steps = 1
for (const [_x, _y] of step(input, at)) {
  steps += 1
}

if (PART === 'one') {
  log('one', steps / 2)
} else {
  log('two', INPUT)
}

// --------

