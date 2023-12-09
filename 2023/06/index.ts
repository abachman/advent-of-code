// https://adventofcode.com/2023/day/5
// 05/index.ts

import { log, setup } from '../lib/setup.ts'
import { ns, nns, pairs } from '../lib/common.ts'

const { PART, INPUT } = await setup('06')


function winners(t: number, d: number): number {
  let beat = false
  let start = 0
  let stop = t
  const window = PART == 'one' ? 1 : 100
  for (let i = 0; i < t; i += window) {
    // holding for i ms gives velocity i
    // traveling for t - i ms
    const travel = i * (t - i)
    if (travel > d) {
      if (!beat) {
        log('started beating at', i)
        // we started beating sometime in the last window, 
        // count back and yield to the last time we didn't beat and 
        let _i = i
        for (; (_i-1) * (t - _i - 1) > d; _i--) {
          // no-op
        }
        start = _i
        log('  but actually started at', _i)
        beat = true
      }
    } else if (beat) {
      log('stopped beating at', i)
      // we were beating, but now we're not, starting from the last 
      // counted 'beat' time, count forward and yield until we didn't beat
      let _i = i - window
      for (; (_i - 1) * (t - _i - 1) > d; _i++) {
        // no-op
      }
      stop = _i
      log('  but actually stopped at', _i)
      beat = false
    }
  }
  return stop - start + 1 // inclusive
}

/* 
 * Time:      7  15   30
 * Distance:  9  40  200
 */
if (PART === 'one') {
  const time = nns(INPUT[0].split(':')[1])
  const distance = nns(INPUT[1].split(':')[1])
  log( { time, distance } )
  let mult = 1
  for (let r = 0; r < time.length; r++) {
    const t = time[r]
    const d = distance[r]
    const w = winners(t, d)
    mult *= w
    log({ t, d, w }) 
  }
  log('one:', mult)
} else {
  const t = Number(ns(INPUT[0].split(':')[1]).join(''))
  const d = Number(ns(INPUT[1].split(':')[1]).join(''))
  log( { t, d } )
  const w = winners(t, d)
  log( { t, d, w } )
}
