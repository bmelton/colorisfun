import Foundation
import AppKit

public struct TailwindColor {
  let name: String
  let r: CGFloat
  let g: CGFloat
  let b: CGFloat

  public init(name: String, r: CGFloat, g: CGFloat, b: CGFloat) {
    self.name = name
    self.r = r
    self.g = g
    self.b = b
  }
}

public struct TailwindColors {
  public static let allColors: [TailwindColor] = [
    // Slate
    TailwindColor(name: "slate-50", r: 248/255, g: 250/255, b: 252/255),
    TailwindColor(name: "slate-100", r: 241/255, g: 245/255, b: 249/255),
    TailwindColor(name: "slate-200", r: 226/255, g: 232/255, b: 240/255),
    TailwindColor(name: "slate-300", r: 203/255, g: 213/255, b: 225/255),
    TailwindColor(name: "slate-400", r: 148/255, g: 163/255, b: 184/255),
    TailwindColor(name: "slate-500", r: 100/255, g: 116/255, b: 139/255),
    TailwindColor(name: "slate-600", r: 71/255, g: 85/255, b: 105/255),
    TailwindColor(name: "slate-700", r: 51/255, g: 65/255, b: 85/255),
    TailwindColor(name: "slate-800", r: 30/255, g: 41/255, b: 59/255),
    TailwindColor(name: "slate-900", r: 15/255, g: 23/255, b: 42/255),
    TailwindColor(name: "slate-950", r: 2/255, g: 6/255, b: 23/255),

    // Gray
    TailwindColor(name: "gray-50", r: 249/255, g: 250/255, b: 251/255),
    TailwindColor(name: "gray-100", r: 243/255, g: 244/255, b: 246/255),
    TailwindColor(name: "gray-200", r: 229/255, g: 231/255, b: 235/255),
    TailwindColor(name: "gray-300", r: 209/255, g: 213/255, b: 219/255),
    TailwindColor(name: "gray-400", r: 156/255, g: 163/255, b: 175/255),
    TailwindColor(name: "gray-500", r: 107/255, g: 114/255, b: 128/255),
    TailwindColor(name: "gray-600", r: 75/255, g: 85/255, b: 99/255),
    TailwindColor(name: "gray-700", r: 55/255, g: 65/255, b: 81/255),
    TailwindColor(name: "gray-800", r: 31/255, g: 41/255, b: 55/255),
    TailwindColor(name: "gray-900", r: 17/255, g: 24/255, b: 39/255),
    TailwindColor(name: "gray-950", r: 3/255, g: 7/255, b: 18/255),


    // Zinc
    TailwindColor(name: "zinc-50", r: 250/255, g: 250/255, b: 250/255),
    TailwindColor(name: "zinc-100", r: 244/255, g: 244/255, b: 245/255),
    TailwindColor(name: "zinc-200", r: 228/255, g: 228/255, b: 231/255),
    TailwindColor(name: "zinc-300", r: 212/255, g: 212/255, b: 216/255),
    TailwindColor(name: "zinc-400", r: 161/255, g: 161/255, b: 170/255),
    TailwindColor(name: "zinc-500", r: 113/255, g: 113/255, b: 122/255),
    TailwindColor(name: "zinc-600", r: 82/255, g: 82/255, b: 91/255),
    TailwindColor(name: "zinc-700", r: 63/255, g: 63/255, b: 70/255),
    TailwindColor(name: "zinc-800", r: 39/255, g: 39/255, b: 42/255),
    TailwindColor(name: "zinc-900", r: 24/255, g: 24/255, b: 27/255),
    TailwindColor(name: "zinc-950", r: 9/255, g: 9/255, b: 11/255),

    // Neutral
    TailwindColor(name: "neutral-50", r: 250/255, g: 250/255, b: 250/255),
    TailwindColor(name: "neutral-100", r: 245/255, g: 245/255, b: 245/255),
    TailwindColor(name: "neutral-200", r: 229/255, g: 229/255, b: 229/255),
    TailwindColor(name: "neutral-300", r: 212/255, g: 212/255, b: 212/255),
    TailwindColor(name: "neutral-400", r: 163/255, g: 163/255, b: 163/255),
    TailwindColor(name: "neutral-500", r: 115/255, g: 115/255, b: 115/255),
    TailwindColor(name: "neutral-600", r: 82/255, g: 82/255, b: 82/255),
    TailwindColor(name: "neutral-700", r: 64/255, g: 64/255, b: 64/255),
    TailwindColor(name: "neutral-800", r: 38/255, g: 38/255, b: 38/255),
    TailwindColor(name: "neutral-900", r: 23/255, g: 23/255, b: 23/255),
    TailwindColor(name: "neutral-950", r: 10/255, g: 10/255, b: 10/255),

    // Stone
    TailwindColor(name: "stone-50", r: 250/255, g: 250/255, b: 249/255),
    TailwindColor(name: "stone-100", r: 245/255, g: 245/255, b: 244/255),
    TailwindColor(name: "stone-200", r: 231/255, g: 229/255, b: 228/255),
    TailwindColor(name: "stone-300", r: 214/255, g: 211/255, b: 209/255),
    TailwindColor(name: "stone-400", r: 168/255, g: 162/255, b: 158/255),
    TailwindColor(name: "stone-500", r: 120/255, g: 113/255, b: 108/255),
    TailwindColor(name: "stone-600", r: 87/255, g: 83/255, b: 78/255),
    TailwindColor(name: "stone-700", r: 68/255, g: 64/255, b: 60/255),
    TailwindColor(name: "stone-800", r: 41/255, g: 37/255, b: 36/255),
    TailwindColor(name: "stone-900", r: 28/255, g: 25/255, b: 23/255),
    TailwindColor(name: "stone-950", r: 12/255, g: 10/255, b: 9/255),

    // Red
    TailwindColor(name: "red-50", r: 254/255, g: 242/255, b: 242/255),
    TailwindColor(name: "red-100", r: 254/255, g: 226/255, b: 226/255),
    TailwindColor(name: "red-200", r: 254/255, g: 202/255, b: 202/255),
    TailwindColor(name: "red-300", r: 252/255, g: 165/255, b: 165/255),
    TailwindColor(name: "red-400", r: 248/255, g: 113/255, b: 113/255),
    TailwindColor(name: "red-500", r: 239/255, g: 68/255, b: 68/255),
    TailwindColor(name: "red-600", r: 220/255, g: 38/255, b: 38/255),
    TailwindColor(name: "red-700", r: 185/255, g: 28/255, b: 28/255),
    TailwindColor(name: "red-800", r: 153/255, g: 27/255, b: 27/255),
    TailwindColor(name: "red-900", r: 127/255, g: 29/255, b: 29/255),
    TailwindColor(name: "red-950", r: 69/255, g: 10/255, b: 10/255),


    // Orange
    TailwindColor(name: "orange-50", r: 255/255, g: 247/255, b: 237/255),
    TailwindColor(name: "orange-100", r: 255/255, g: 237/255, b: 213/255),
    TailwindColor(name: "orange-200", r: 254/255, g: 215/255, b: 170/255),
    TailwindColor(name: "orange-300", r: 253/255, g: 186/255, b: 116/255),
    TailwindColor(name: "orange-400", r: 251/255, g: 146/255, b: 60/255),
    TailwindColor(name: "orange-500", r: 249/255, g: 115/255, b: 22/255),
    TailwindColor(name: "orange-600", r: 234/255, g: 88/255, b: 12/255),
    TailwindColor(name: "orange-700", r: 194/255, g: 65/255, b: 12/255),
    TailwindColor(name: "orange-800", r: 154/255, g: 52/255, b: 18/255),
    TailwindColor(name: "orange-900", r: 124/255, g: 45/255, b: 18/255),
    TailwindColor(name: "orange-950", r: 67/255, g: 20/255, b: 7/255),

    // Amber
    TailwindColor(name: "amber-50", r: 255/255, g: 251/255, b: 235/255),
    TailwindColor(name: "amber-100", r: 254/255, g: 243/255, b: 199/255),
    TailwindColor(name: "amber-200", r: 253/255, g: 230/255, b: 138/255),
    TailwindColor(name: "amber-300", r: 252/255, g: 211/255, b: 77/255),
    TailwindColor(name: "amber-400", r: 251/255, g: 191/255, b: 36/255),
    TailwindColor(name: "amber-500", r: 245/255, g: 158/255, b: 11/255),
    TailwindColor(name: "amber-600", r: 217/255, g: 119/255, b: 6/255),
    TailwindColor(name: "amber-700", r: 180/255, g: 83/255, b: 9/255),
    TailwindColor(name: "amber-800", r: 146/255, g: 64/255, b: 14/255),
    TailwindColor(name: "amber-900", r: 120/255, g: 53/255, b: 15/255),
    TailwindColor(name: "amber-950", r: 69/255, g: 26/255, b: 3/255),

    // Yellow
    TailwindColor(name: "yellow-50", r: 254/255, g: 252/255, b: 232/255),
    TailwindColor(name: "yellow-100", r: 254/255, g: 249/255, b: 195/255),
    TailwindColor(name: "yellow-200", r: 254/255, g: 240/255, b: 138/255),
    TailwindColor(name: "yellow-300", r: 253/255, g: 224/255, b: 71/255),
    TailwindColor(name: "yellow-400", r: 250/255, g: 204/255, b: 21/255),
    TailwindColor(name: "yellow-500", r: 234/255, g: 179/255, b: 8/255),
    TailwindColor(name: "yellow-600", r: 202/255, g: 138/255, b: 4/255),
    TailwindColor(name: "yellow-700", r: 161/255, g: 98/255, b: 7/255),
    TailwindColor(name: "yellow-800", r: 133/255, g: 77/255, b: 14/255),
    TailwindColor(name: "yellow-900", r: 113/255, g: 63/255, b: 18/255),
    TailwindColor(name: "yellow-950", r: 66/255, g: 32/255, b: 6/255),


    // Lime
    TailwindColor(name: "lime-50", r: 247/255, g: 254/255, b: 231/255),
    TailwindColor(name: "lime-100", r: 236/255, g: 252/255, b: 203/255),
    TailwindColor(name: "lime-200", r: 217/255, g: 249/255, b: 157/255),
    TailwindColor(name: "lime-300", r: 190/255, g: 242/255, b: 100/255),
    TailwindColor(name: "lime-400", r: 163/255, g: 230/255, b: 53/255),
    TailwindColor(name: "lime-500", r: 132/255, g: 204/255, b: 22/255),
    TailwindColor(name: "lime-600", r: 101/255, g: 163/255, b: 13/255),
    TailwindColor(name: "lime-700", r: 77/255, g: 124/255, b: 15/255),
    TailwindColor(name: "lime-800", r: 63/255, g: 98/255, b: 18/255),
    TailwindColor(name: "lime-900", r: 54/255, g: 83/255, b: 20/255),
    TailwindColor(name: "lime-950", r: 26/255, g: 46/255, b: 5/255),

    // Green
    TailwindColor(name: "green-50", r: 240/255, g: 253/255, b: 244/255),
    TailwindColor(name: "green-100", r: 220/255, g: 252/255, b: 231/255),
    TailwindColor(name: "green-200", r: 187/255, g: 247/255, b: 208/255),
    TailwindColor(name: "green-300", r: 134/255, g: 239/255, b: 172/255),
    TailwindColor(name: "green-400", r: 74/255, g: 222/255, b: 128/255),
    TailwindColor(name: "green-500", r: 34/255, g: 197/255, b: 94/255),
    TailwindColor(name: "green-600", r: 22/255, g: 163/255, b: 74/255),
    TailwindColor(name: "green-700", r: 21/255, g: 128/255, b: 61/255),
    TailwindColor(name: "green-800", r: 22/255, g: 101/255, b: 52/255),
    TailwindColor(name: "green-900", r: 20/255, g: 83/255, b: 45/255),
    TailwindColor(name: "green-950", r: 5/255, g: 46/255, b: 22/255),

    // Emerald
    TailwindColor(name: "emerald-50", r: 236/255, g: 253/255, b: 245/255),
    TailwindColor(name: "emerald-100", r: 209/255, g: 250/255, b: 229/255),
    TailwindColor(name: "emerald-200", r: 167/255, g: 243/255, b: 208/255),
    TailwindColor(name: "emerald-300", r: 110/255, g: 231/255, b: 183/255),
    TailwindColor(name: "emerald-400", r: 52/255, g: 211/255, b: 153/255),
    TailwindColor(name: "emerald-500", r: 16/255, g: 185/255, b: 129/255),
    TailwindColor(name: "emerald-600", r: 5/255, g: 150/255, b: 105/255),
    TailwindColor(name: "emerald-700", r: 4/255, g: 120/255, b: 87/255),
    TailwindColor(name: "emerald-800", r: 6/255, g: 95/255, b: 70/255),
    TailwindColor(name: "emerald-900", r: 6/255, g: 78/255, b: 59/255),
    TailwindColor(name: "emerald-950", r: 2/255, g: 44/255, b: 34/255),

    // Teal
    TailwindColor(name: "teal-50", r: 240/255, g: 253/255, b: 250/255),
    TailwindColor(name: "teal-100", r: 204/255, g: 251/255, b: 241/255),
    TailwindColor(name: "teal-200", r: 153/255, g: 246/255, b: 228/255),
    TailwindColor(name: "teal-300", r: 94/255, g: 234/255, b: 212/255),
    TailwindColor(name: "teal-400", r: 45/255, g: 212/255, b: 191/255),
    TailwindColor(name: "teal-500", r: 20/255, g: 184/255, b: 166/255),
    TailwindColor(name: "teal-600", r: 13/255, g: 148/255, b: 136/255),
    TailwindColor(name: "teal-700", r: 15/255, g: 118/255, b: 110/255),
    TailwindColor(name: "teal-800", r: 17/255, g: 94/255, b: 89/255),
    TailwindColor(name: "teal-900", r: 19/255, g: 78/255, b: 74/255),
    TailwindColor(name: "teal-950", r: 4/255, g: 47/255, b: 46/255),

    // Cyan
    TailwindColor(name: "cyan-50", r: 236/255, g: 254/255, b: 255/255),
    TailwindColor(name: "cyan-100", r: 207/255, g: 250/255, b: 254/255),
    TailwindColor(name: "cyan-200", r: 165/255, g: 243/255, b: 252/255),
    TailwindColor(name: "cyan-300", r: 103/255, g: 232/255, b: 249/255),
    TailwindColor(name: "cyan-400", r: 34/255, g: 211/255, b: 238/255),
    TailwindColor(name: "cyan-500", r: 6/255, g: 182/255, b: 212/255),
    TailwindColor(name: "cyan-600", r: 8/255, g: 145/255, b: 178/255),
    TailwindColor(name: "cyan-700", r: 14/255, g: 116/255, b: 144/255),
    TailwindColor(name: "cyan-800", r: 21/255, g: 94/255, b: 117/255),
    TailwindColor(name: "cyan-900", r: 22/255, g: 78/255, b: 99/255),
    TailwindColor(name: "cyan-950", r: 8/255, g: 51/255, b: 68/255),

    // Sky
    TailwindColor(name: "sky-50", r: 240/255, g: 249/255, b: 255/255),
    TailwindColor(name: "sky-100", r: 224/255, g: 242/255, b: 254/255),
    TailwindColor(name: "sky-200", r: 186/255, g: 230/255, b: 253/255),
    TailwindColor(name: "sky-300", r: 125/255, g: 211/255, b: 252/255),
    TailwindColor(name: "sky-400", r: 56/255, g: 189/255, b: 248/255),
    TailwindColor(name: "sky-500", r: 14/255, g: 165/255, b: 233/255),
    TailwindColor(name: "sky-600", r: 2/255, g: 132/255, b: 199/255),
    TailwindColor(name: "sky-700", r: 3/255, g: 105/255, b: 161/255),
    TailwindColor(name: "sky-800", r: 7/255, g: 89/255, b: 133/255),
    TailwindColor(name: "sky-900", r: 12/255, g: 74/255, b: 110/255),
    TailwindColor(name: "sky-950", r: 8/255, g: 47/255, b: 73/255),


    // Blue
    TailwindColor(name: "blue-50", r: 239/255, g: 246/255, b: 255/255),
    TailwindColor(name: "blue-100", r: 219/255, g: 234/255, b: 254/255),
    TailwindColor(name: "blue-200", r: 191/255, g: 219/255, b: 254/255),
    TailwindColor(name: "blue-300", r: 147/255, g: 197/255, b: 253/255),
    TailwindColor(name: "blue-400", r: 96/255, g: 165/255, b: 250/255),
    TailwindColor(name: "blue-500", r: 59/255, g: 130/255, b: 246/255),
    TailwindColor(name: "blue-600", r: 37/255, g: 99/255, b: 235/255),
    TailwindColor(name: "blue-700", r: 29/255, g: 78/255, b: 216/255),
    TailwindColor(name: "blue-800", r: 30/255, g: 64/255, b: 175/255),
    TailwindColor(name: "blue-900", r: 30/255, g: 58/255, b: 138/255),
    TailwindColor(name: "blue-950", r: 23/255, g: 37/255, b: 84/255),

    // Indigo
    TailwindColor(name: "indigo-50", r: 238/255, g: 242/255, b: 255/255),
    TailwindColor(name: "indigo-100", r: 224/255, g: 231/255, b: 255/255),
    TailwindColor(name: "indigo-200", r: 199/255, g: 210/255, b: 254/255),
    TailwindColor(name: "indigo-300", r: 165/255, g: 180/255, b: 252/255),
    TailwindColor(name: "indigo-400", r: 129/255, g: 140/255, b: 248/255),
    TailwindColor(name: "indigo-500", r: 99/255, g: 102/255, b: 241/255),
    TailwindColor(name: "indigo-600", r: 79/255, g: 70/255, b: 229/255),
    TailwindColor(name: "indigo-700", r: 67/255, g: 56/255, b: 202/255),
    TailwindColor(name: "indigo-800", r: 55/255, g: 48/255, b: 163/255),
    TailwindColor(name: "indigo-900", r: 49/255, g: 46/255, b: 129/255),
    TailwindColor(name: "indigo-950", r: 30/255, g: 27/255, b: 75/255),

    // Violet
    TailwindColor(name: "violet-50", r: 245/255, g: 243/255, b: 255/255),
    TailwindColor(name: "violet-100", r: 237/255, g: 233/255, b: 254/255),
    TailwindColor(name: "violet-200", r: 221/255, g: 214/255, b: 254/255),
    TailwindColor(name: "violet-300", r: 196/255, g: 181/255, b: 253/255),
    TailwindColor(name: "violet-400", r: 167/255, g: 139/255, b: 250/255),
    TailwindColor(name: "violet-500", r: 139/255, g: 92/255, b: 246/255),
    TailwindColor(name: "violet-600", r: 124/255, g: 58/255, b: 237/255),
    TailwindColor(name: "violet-700", r: 109/255, g: 40/255, b: 217/255),
    TailwindColor(name: "violet-800", r: 91/255, g: 33/255, b: 182/255),
    TailwindColor(name: "violet-900", r: 76/255, g: 29/255, b: 149/255),
    TailwindColor(name: "violet-950", r: 46/255, g: 16/255, b: 101/255),


    // Purple
    TailwindColor(name: "purple-50", r: 250/255, g: 245/255, b: 255/255),
    TailwindColor(name: "purple-100", r: 243/255, g: 232/255, b: 255/255),
    TailwindColor(name: "purple-200", r: 233/255, g: 213/255, b: 255/255),
    TailwindColor(name: "purple-300", r: 216/255, g: 180/255, b: 254/255),
    TailwindColor(name: "purple-400", r: 192/255, g: 132/255, b: 252/255),
    TailwindColor(name: "purple-500", r: 168/255, g: 85/255, b: 247/255),
    TailwindColor(name: "purple-600", r: 147/255, g: 51/255, b: 234/255),
    TailwindColor(name: "purple-700", r: 126/255, g: 34/255, b: 206/255),
    TailwindColor(name: "purple-800", r: 107/255, g: 33/255, b: 168/255),
    TailwindColor(name: "purple-900", r: 88/255, g: 28/255, b: 135/255),
    TailwindColor(name: "purple-950", r: 59/255, g: 7/255, b: 100/255),

    // Fuchsia
    TailwindColor(name: "fuchsia-50", r: 253/255, g: 244/255, b: 255/255),
    TailwindColor(name: "fuchsia-100", r: 250/255, g: 232/255, b: 255/255),
    TailwindColor(name: "fuchsia-200", r: 245/255, g: 208/255, b: 254/255),
    TailwindColor(name: "fuchsia-300", r: 240/255, g: 171/255, b: 252/255),
    TailwindColor(name: "fuchsia-400", r: 232/255, g: 121/255, b: 249/255),
    TailwindColor(name: "fuchsia-500", r: 217/255, g: 70/255, b: 239/255),
    TailwindColor(name: "fuchsia-600", r: 192/255, g: 38/255, b: 211/255),
    TailwindColor(name: "fuchsia-700", r: 162/255, g: 28/255, b: 175/255),
    TailwindColor(name: "fuchsia-800", r: 134/255, g: 25/255, b: 143/255),
    TailwindColor(name: "fuchsia-900", r: 112/255, g: 26/255, b: 117/255),
    TailwindColor(name: "fuchsia-950", r: 74/255, g: 4/255, b: 78/255),


    // Pink
    TailwindColor(name: "pink-50", r: 253/255, g: 242/255, b: 248/255),
    TailwindColor(name: "pink-100", r: 252/255, g: 231/255, b: 243/255),
    TailwindColor(name: "pink-200", r: 251/255, g: 207/255, b: 232/255),
    TailwindColor(name: "pink-300", r: 249/255, g: 168/255, b: 212/255),
    TailwindColor(name: "pink-400", r: 244/255, g: 114/255, b: 182/255),
    TailwindColor(name: "pink-500", r: 236/255, g: 72/255, b: 153/255),
    TailwindColor(name: "pink-600", r: 219/255, g: 39/255, b: 119/255),
    TailwindColor(name: "pink-700", r: 190/255, g: 24/255, b: 93/255),
    TailwindColor(name: "pink-800", r: 157/255, g: 23/255, b: 77/255),
    TailwindColor(name: "pink-900", r: 131/255, g: 24/255, b: 67/255),
    TailwindColor(name: "pink-950", r: 80/255, g: 7/255, b: 36/255),

    // Rose
    TailwindColor(name: "rose-50", r: 255/255, g: 241/255, b: 242/255),
    TailwindColor(name: "rose-100", r: 255/255, g: 228/255, b: 230/255),
    TailwindColor(name: "rose-200", r: 254/255, g: 205/255, b: 211/255),
    TailwindColor(name: "rose-300", r: 253/255, g: 164/255, b: 175/255),
    TailwindColor(name: "rose-400", r: 251/255, g: 113/255, b: 133/255),
    TailwindColor(name: "rose-500", r: 244/255, g: 63/255, b: 94/255),
    TailwindColor(name: "rose-600", r: 225/255, g: 29/255, b: 72/255),
    TailwindColor(name: "rose-700", r: 190/255, g: 18/255, b: 60/255),
    TailwindColor(name: "rose-800", r: 159/255, g: 18/255, b: 57/255),
    TailwindColor(name: "rose-900", r: 136/255, g: 19/255, b: 55/255),
    TailwindColor(name: "rose-950", r: 76/255, g: 5/255, b: 25/255),
  ]
}