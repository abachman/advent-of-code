// https://adventofcode.com/2023/day/1

import { setup } from '../lib/setup.ts'

const { PART, INPUT } = await setup('01')

const wn = (s: string): string => {
  // if s is not a digit, make it a digit
  if (/\d/.test(s)) return s
  const out = [
    null,
    'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'
  ].indexOf(s).toString()
  return out
}

const lineNum = (inline: string, words = false): ReturnType<typeof parseInt> => {
  // On each line, the calibration value can be found by combining the first
  // digit and the last digit (in that order) to form a single two-digit number.
  let first: string | null = null
  let last: string | null = null

  if (words) {
    const numpat = /(\d|one|two|three|four|five|six|seven|eight|nine)/
    // consume string until match is reached
    let nl = inline.slice(0, inline.length)
    let m
    do {
      m = numpat.exec(nl)
      if (m) {
        if (first === null) first = m[1]
        last = m[1]
        nl = nl.slice(m.index + 1, nl.length)
      }
    } while (m)

    if (first) first = wn(first)
    if (last) last = wn(last)
  } else {
    for (let i = 0; i < inline.length; i++) {
      const c = inline.charAt(i)
      if (/\d/.test(c)) {
        if (first === null) first = c
        last = c
      }
    }
  }

  if (first && last) {
    return parseInt(first + last)
  } else {
    console.error('line had no numbers:', inline)
    return 0
  }
}

let sum
if (PART === 'one') {
  sum = INPUT.reduce((prev, line) => prev + lineNum(line), 0)
} else {
  sum = INPUT.reduce((prev, line) => prev + lineNum(line, true), 0)
}

console.log('got sum:', sum)
