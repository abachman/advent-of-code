
// https://adventofcode.com/2023/day/21
// 21/index.ts

import { setup, log } from '../lib/setup.ts'

const { PART, INPUT } = await setup('21')

if (PART === 'one') {
  log('one', INPUT)
} else {
  log('two', INPUT)
}

