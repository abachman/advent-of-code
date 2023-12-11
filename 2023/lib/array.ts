import { log } from './output.ts'

function tap<T>(fn: (arg: T) => void) {
  return (arg: T) => {
    fn(arg)
    return arg
  }
}

function tlog<T>(label: string) {
  return tap<T>(arg => log(label, arg))
}

declare global {
  interface Array<T> {
    tap: (fn: (arg: T) => void) => T
    tlog: (label: string) => T
  }
}

Array.prototype.tap = function (fn: (arg: unknown) => void) {
  return tap(fn)(this)
}

Array.prototype.tlog = function (label: string) {
  return tlog(label)(this)
}
