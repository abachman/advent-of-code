import { load } from "std/dotenv/mod.ts";

async function env(key: string): Promise<string> {
  const env = await load();
  return env[key]
}

async function part(): Promise<string> {
  const p = await env('PART');
  console.log('loading part', p)
  return p
}

export { part, env }