import { env } from './env.ts'

function readlines(filename: string): Promise<Array<string>> {
  return Deno.readTextFile(filename).then((value) => value.split('\n'))
}

async function input(day: string) {
  const useExample = (await env('EXAMPLE')) === 'true'
  const infile = `./${day}/${useExample ? 'example' : 'input'}.txt`
  console.log('reading from\x1b[33;1m', infile, '\x1b[0m')
  return readlines(infile)
}

export { input }
