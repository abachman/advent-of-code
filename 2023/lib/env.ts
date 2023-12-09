import { load } from 'std/dotenv/mod.ts'

async function env(key: string): Promise<string> {
  const env = await load()
  return env[key]
}

async function part(): Promise<string> {
  const p = await env('PART')
  console.log('Loading part\x1b[33;1m', p, '\x1b[0m')
  return p
}

export { env, part }
