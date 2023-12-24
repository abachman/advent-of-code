// https://adventofcode.com/2023/day/11
// 11/index.ts

import { setup, log, c } from '../lib/setup.ts'

const { PART, INPUT } = await setup('11')

const grid = INPUT.
  filter(l => l.trim() !== '').
  map(l => l.split(''))

function pp(grid: string[][]): string {
  return grid.
    map(row => row.join('').replace(/#/g, c('#'))).
    join('\n')
}

function empties(grid: string[][]): { xs: number[], ys: number[] } {
  const cols: Record<string, number> = {}
  const rows: Record<string, number> = {}

  grid.forEach((row, y) => {
    rows[y] = 0
    row.forEach((cell, x) => {
      cols[x] = cols[x] || 0
      if (cell === '#') {
        rows[y] += 1
        cols[x] += 1
      }
    })
  })

  return { 
    xs: Object.keys(cols).filter(k => cols[k] === 0).map(v => Number(v)),
    ys: Object.keys(rows).filter(k => rows[k] === 0).map(v => Number(v))
  }
}

function expand(grid: string[][]) {
  const { xs, ys } = empties(grid)

  for (const x of xs.reverse()) {
    grid.forEach(row => row.splice(x, 0, '.'))
  }

  for (const y of ys.reverse()) {
    grid.splice(y, 0, grid[0].map(() => '.'))
  }
}

function expanded(grid: string[][], by: number): Location[] {
  const { xs, ys } = empties(grid)
  const locs: [Location, Location][] = locate(grid).
    map(loc => [ loc, loc.slice() as Location ])

  for (const x of xs) {
    // every location to the right of x is now x + 1000000
    locs.forEach(([loc, nloc]) => {
      if (loc[0] > x) {
        nloc[0] += by
      }
    })
  }

  for (const y of ys) {
    locs.forEach(([loc, nloc]) => {
      if (loc[1] > y) {
        nloc[1] += by
      }
    })
  }

  return locs.map(([_, nloc]) => nloc)
}


type Location = [number, number]
type Pair = [Location, Location]

function locate(grid: string[][]): Location[] {
  return grid.
    map((row, y) => row.
        map((cell, x) => cell === '#' ? [x, y] : null)).
    flat().
    filter(v => v !== null) as Location[]
}

function pairwise(locations: Location[]): Pair[] {
  return locations.
    map((v, i) => locations.slice(i + 1).map(w => [v, w])).
    flat() as Pair[]
}

function dist (a: Location, b: Location): number {
  const [ax, ay] = a, [bx, by] = b
  return Math.abs(ax - bx) + Math.abs(ay - by)
}

const locations = PART === 'one' ? 
  expanded(grid, 1) :
  expanded(grid, 999999)
log(locations)
const pairs = pairwise(locations)
const sum = pairs.reduce((acc, [a, b]) => {
  return acc + dist(a, b)
}, 0)


if (PART === 'one') {
  log('one', sum)
} else {
  log('two', sum)
}
