export function calcMean(arr: number[]): number {
  return arr.reduce((prev, curr) => prev + curr, 0) / arr.length;
}
