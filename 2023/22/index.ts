
// https://adventofcode.com/2023/day/22
// 22/index.ts

import { setup, log } from '../lib/setup.ts'

const { PART, INPUT } = await setup('22')

if (PART === 'one') {
  log('one', INPUT)
} else {
  log('two', INPUT)
}

