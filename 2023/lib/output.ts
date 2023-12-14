type Loggable = Parameters<typeof console.log>

export function log(...args: Loggable): void {
  if (Deno.env.get('DEBUG')) {
    console.log(...args)
  }
}

export function c(s: string): string {
  return `\x1b[33;1m${s}\x1b[0m`
}

