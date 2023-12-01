import { input } from './input.ts'
import { part } from './env.ts'

async function setup(day: string) {
  return {
    PART: await part(),
    INPUT: await input(day)
  }
}

export { setup }