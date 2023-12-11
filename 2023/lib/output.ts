type Loggable = Parameters<typeof console.log>
export function log(...args: Loggable): void {
  if (Deno.env.get('DEBUG')) {
    console.log(...args)
  }
}
