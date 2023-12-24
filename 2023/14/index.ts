// https://adventofcode.com/2023/day/14
// 14/index.ts

import { setup, log } from '../lib/setup.ts'

const { PART, INPUT } = await setup('14')

if (PART === 'one') {
  log('one', INPUT)
} else {
  log('two', INPUT)
}

