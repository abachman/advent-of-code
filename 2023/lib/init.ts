import { ensureDir, ensureFile } from 'std/fs/mod.ts'
import { join } from 'std/path/join.ts'

const day = Deno.args[0]

const t = (s: string, d: Record<string, string | number>) => {
  Object.keys(d).forEach((k) => {
    const v = d[k]
    s = s.replace(new RegExp(`{{${k}}}`, 'g'), String(v))
  })
  return s
}

const template = `
// https://adventofcode.com/2023/day/{{nday}}
// {{day}}/index.ts

import { setup, log } from '../lib/setup.ts'

const { PART, INPUT } = await setup('{{day}}')

if (PART === 'one') {
  log('one', INPUT)
} else {
  log('two', INPUT)
}
`

if (/^[0-9][0-9]$/.test(day)) {
  const dir = `./${day}`
  await ensureDir(dir)
  ;['input.txt', 'example.txt', 'index.ts', 'description.md'].forEach(async (file: string) => {
    await ensureFile(join(day, file))
  })

  const nday = Number(day)
  const index = t(template, { day, nday })
  Deno.writeTextFileSync(join(day, 'index.ts'), index)
  console.log('\n--------\n', index, '\n--------\n');
}

console.log('done')
