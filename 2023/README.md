_2023_

going to try with [deno](https://docs.deno.com/runtime/manual/getting_started/installation) / typescript this year.

### running examples

every day's problem is in a folder numbered according to day and should have a corresponding task:

```json
{
  "tasks": {
    "day": "DEBUG=true deno run --allow-net=deno.land --allow-read --allow-env --watch lib/day.ts",
  }
}
```

so that they can be run with:

```console
$ deno task day 1
```

folders should contain at least three files:

- `index.ts` the main script for the day
- `input.txt` your unique problem input
- `example.txt` the given example input (or any example input you'd like)

#### toggling part one / part two, example input, etc.

`.env` is a [dotenv file](https://docs.deno.com/runtime/manual/basics/env_variables) and has a variables which may affect any day's script.

the common variables are `PART` and `EXAMPLE`:

```shell
PART=one
EXAMPLE=true
```
the `lib/setup.ts` boilerplate file provides the PART value as set in the file, and the appropriate input text based on the value of `EXAMPLE`. when `EXAMPLE` is `'true'`, `example.txt` is loaded, when it is any other value, `input.txt` is loaded.

```typescript
import { setup } from '../lib/setup.ts'

// setup(day), where day is the folder
// name that the script is contained in
const { PART, INPUT } = await setup('03') 
```

### init a day

```console
$ deno task init 02
```
