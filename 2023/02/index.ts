import { log, setup } from '../lib/setup.ts'

const { PART, INPUT } = await setup('02')

const pickPattern = /^(\d+) (.+)$/

const inputs = INPUT.map((line) => {
  const [label, games] = line.split(': ')
  log({ label, games })

  if (!games) return

  const id = Number(label.split(' ')[1])
  const maxCounts = { id, blue: 0, red: 0, green: 0 }

  games.split(';').forEach((game) => {
    const picks = game.split(', ')
    picks.forEach((pick) => {
      pick = pick.trim()
      const match = pickPattern.exec(pick)
      if (match) {
        const [_, count, color] = match
        maxCounts[color] = Math.max(maxCounts[color], Number(count))
      }
    })
  })

  return maxCounts
})

type Counts = {
  id?: number
  red: number
  green: number
  blue: number
}

// determine how many games would have been possible given cube counts:
const given: Counts = {
  red: 12,
  green: 13,
  blue: 14,
}

const power = (counts: Counts) => {
  return counts.red * counts.green * counts.blue
}

const possible = inputs.reduce((sum, counts) => {
  if (!counts) return sum

  const red = counts.red <= given.red
  const green = counts.green <= given.green
  const blue = counts.blue <= given.blue
  const valid = red && green && blue

  log({ counts, valid })
  if (PART === 'two') {
    return sum + power(counts)
  }

  return sum + (valid ? counts.id : 0)
}, 0)

log({ possible })
