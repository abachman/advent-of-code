
// https://adventofcode.com/2023/day/23
// 23/index.ts

import { setup, log } from '../lib/setup.ts'

const { PART, INPUT } = await setup('23')

if (PART === 'one') {
  log('one', INPUT)
} else {
  log('two', INPUT)
}

