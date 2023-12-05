import { env } from './env.ts'

function readlines(filename: string): Promise<Array<string>> {
  return Deno.readTextFile(filename).then((value) => value.split('\n'))
}

async function input(day: string) {
  const useExample = (await env('EXAMPLE')) === 'true'
  const infile = `./${day}/${useExample ? 'example' : 'input'}.txt`
  console.log('reading from', infile)
  return readlines(infile)
}

export { input }
