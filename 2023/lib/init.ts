import { ensureDir, ensureFile } from 'std/fs/mod.ts'
import { join } from 'std/path/join.ts'

const day = Deno.args[0]

if (/^[0-9][0-9]$/.test(day)) {
  const dir = `./${day}`
  await ensureDir(dir)

  ;['input.txt', 'example.txt', 'index.ts'].forEach(async (file: string) => {
    await ensureFile(join(day, file))
  });
}