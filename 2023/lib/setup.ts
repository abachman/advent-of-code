import { input } from './input.ts'
import { part } from './env.ts'
import { log } from './output.ts'
import './array.ts'

async function setup(day: string) {
  return {
    PART: await part(),
    INPUT: await input(day),
  }
}

export { log, setup }
