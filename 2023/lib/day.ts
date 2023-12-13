import { exists } from "std/fs/exists.ts";

const day = Deno.args[0]
const zday = day.padStart(2, '0')

if (await exists(zday)) {
  import(`../${zday}/index.ts`)
}
