// https://adventofcode.com/2023/day/15
// 15/index.ts

import { setup, log } from '../lib/setup.ts'

const { PART, INPUT } = await setup('15')

if (PART === 'one') {
  log('one', INPUT)
} else {
  log('two', INPUT)
}

