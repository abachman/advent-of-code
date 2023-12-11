// https://adventofcode.com/2023/day/7
// 07/index.ts

import { setup, log } from '../lib/setup.ts'

const { PART, INPUT } = await setup('07')

type CCount = Record<string, number>

type Hand = {
  cards: string[]
  orig: string[]
  origt: number
  count: CCount
  type: number
  bid: number
}

const cardCount = (hand: Hand): CCount => {
  const count: CCount = {}
  hand.cards.forEach((card: string) => {
    if (count[card]) count[card]++
    else count[card] = 1
  })
  return count
}

const handType = (hand: Hand): number => {
  const [a, b, c, d, e] = Object.values(hand.count)

  // five of a kind
  if (!b)      return 1 
  // four of a kind or full house
  else if (!c) return (a === 4 || a === 1) ? 2 : 3 
  // three of a kind or two pair
  else if (!d) return (a == 3 || b == 3 || c == 3) ? 4 : 5
  // two of a kind
  else if (!e) return 6 
  // high card
  return 7
}

const bestCards = (h: Hand): string[] => {
  const { cards, type, count } = h
  if (PART === "one" || cards.every(c => c !== "J")) return cards

  // find best card with n count in hand
  const bestWith = (n: number) => 
    Object.
      entries(count).
      filter(c => c[1] === n && nj(c[0])).
      map(c => c[0]).
      toSorted(byRank)[0]
  const nj = (c: string) => c !== "J"
  const bc = cards.filter(nj).toSorted(byRank)[0]
  // const ij = (c: string) => c === "J"
  let r: string
  switch(type) {
    case 1: 
      r = "A"
      break
    case 2: // 4 of a kind
    case 3: // full house, Js become other
      r = cards.filter(nj)[0] 
      break
    case 4: // 3 of a kind 
      // replace J with the otherwise best card
      r = (count["J"] === 3) ? bc : bestWith(3)
      break
    case 5: // two pairs, pick best pair, since it will not be J
      r = bestWith(2) 
      break
    case 6: // one pair, should end up as 3-of-a-kind 
      r = count["J"] == 2 ? bc : bestWith(2) 
      break;
    case 7: // all unique, pick best card
      r = bc
      break;  
    default: 
      r = "z"
      break
  }

  // J cards can pretend to be whatever card is best for the purpose of
  // determining hand type
  const out = cards.map(c => c === "J" ? r : c)
  return out
}

// line: "32T3K 765"
const toHand = (line: string): Hand | null => {
  if (line.trim() === "") return null 

  const [shand, bid] = line.split(' ')
  const hand: Hand = { 
    cards: shand.split(''),
    orig: shand.split(''),
    origt: 99,
    bid: Number(bid),
    count: {},
    type: 99,
  }
  hand.count = cardCount(hand)
  hand.type = handType(hand)
  hand.origt = hand.type
  if (PART == "two") {
    hand.cards = bestCards(hand)
    hand.count = cardCount(hand)
    hand.type = handType(hand)
  }

  return hand
}

const cardRank = (c: string): number => {
  if (PART === "one") {
    return "AKQJT98765432".indexOf(c)
  } else {
    // log('cr-two', c, "AKQT98765432J".indexOf(c))
    return "AKQT98765432J".indexOf(c)
  }
}

const byRank = (a: string, b: string) => {
  return cardRank(a) - cardRank(b)
}

// sort function, return -1 if a < b, 1 if a > b
// 1 for higher ranking, -1 for lower
type Comparable = Pick<Hand, "type" | "orig">
const handCompare = (a: Comparable, b: Comparable): number => {
  if (a.type !== b.type) { 
    return a.type < b.type ? 1 : -1
  }

  for (let i=0; i < a.orig.length; i++) {
    const ac = a.orig[i], bc = b.orig[i]
    if (ac !== bc) {
      return cardRank(ac) < cardRank(bc) ? 1 : -1
    } 
  }

  log('a is b', a.orig, b.orig)
  return 0
}

// rank hands by strength, weakest first
const input: Hand[] = INPUT.map(toHand).filter(h => h) as Hand[]

const ranked = input.toSorted(handCompare)

for (let i=0; i < ranked.length; i++) {
  const h = ranked[i] 
  const a = h.orig.join(''), b = h.cards.join('')
  if (a !== b) {
    log(`${a}(${h.origt}) -> ${b}(${h.type}) : ${h.bid} ${h.bid * (i+1)}`)
  }
}

let sum = 0
for (let i=0; i < ranked.length; i++) {
  sum += (i+1) * ranked[i].bid
}

if (PART === 'one') {
  // 250602641
  log('one', sum)
} else {
  // 251037509
  log('two', sum)
}

