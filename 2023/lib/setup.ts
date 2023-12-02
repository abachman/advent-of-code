import { input } from './input.ts'
import { part } from './env.ts'

async function setup(day: string) {
  return {
    PART: await part(),
    INPUT: await input(day)
  }
}

function log(...args: any[]) {
  if (Deno.env.get('DEBUG')) {
    console.log(...args)
  }
}

export { setup, log }
