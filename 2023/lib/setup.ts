import { input } from './input.ts'
import { part } from './env.ts'
import { log, c } from './output.ts'
import './array.ts'

async function setup(day: string) {
  return {
    PART: await part(),
    INPUT: await input(day),
  }
}

export { c, log, setup }
