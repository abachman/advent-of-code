// https://adventofcode.com/2023/day/8
// 08/index.ts

import { setup, log } from '../lib/setup.ts'
import { lcm } from '../lib/math.ts'

const { PART, INPUT } = await setup('08')

function *cycle(arr: string[]): Generator<"L" | "R"> {
  let i = 0
  while (true) {
    yield arr[i] as 'L' | 'R'
    i = (i + 1) % arr.length
  }
}

const input0 = (INPUT.shift() as string).split('')
const instructions = cycle(input0)
INPUT.shift()

type Graph = Record<string, Node>

type Node = {
  key: string
  L?: Node
  R?: Node
}

const graph: Graph = {}

const lineToNode = (line: string) => {
  if (line.trim().length === 0) return

  // AAA = (BBB, CCC)
  const [key, left, right] = line.split('').
    filter(c => /[^\(\),=]/.test(c)).
    join('').
    replace(/ +/g, ' ').
    split(' ')

  // log({ key, left, right })

  // place neighbors in graph
  if (!graph[left])  graph[left] = { key: left }
  if (!graph[right]) graph[right] = { key: right }

  // place node in graph
  if (!graph[key]) {
    graph[key] = {
      key,
      L: graph[left],
      R: graph[right]
    }
  } else {
    graph[key].L = graph[left]
    graph[key].R = graph[right]
  }
}

INPUT.forEach(lineToNode)

const done = (ns: Node[]): boolean => ns.every(n => n.key[2] === 'Z')

if (PART === 'one') {
  let steps = 0
  let node = graph['AAA']
  for (const inst of instructions) {
    log({ at: node.key, go: inst, to: (node[inst] as Node).key })
    node = node[inst] as Node
    steps++

    if (node.key === 'ZZZ') {
      break
    }
  }

  log('one', steps)
} else {
  // build start list
  const nodes: Node[] = Object.
    keys(graph).
    filter(k => k[2] === 'A').
    map(k => graph[k])

  log({ starts: nodes.map(n => n.key) })

  // get cycle length from each start node
  const cycles = nodes.map(n => {
    let steps = 0
    let node = n
    const inst = cycle(input0)
    while (node.key[2] !== 'Z') {
      node = node[inst.next().value as 'L' | 'R'] as Node
      steps++
    }
    return { key: n.key, steps }
  })

  log(cycles)
  /*
   * [
   *   { key: "DVA", steps: 11309 },
   *   { key: "JQA", steps: 19199 },
   *   { key: "PTA", steps: 12361 },
   *   { key: "CRA", steps: 16043 },
   *   { key: "AAA", steps: 13939 },
   *   { key: "BGA", steps: 18673 }
   * ]
   */

  const steps = lcm(...cycles.map(({ steps }) => steps))

  log('two', steps)
}

