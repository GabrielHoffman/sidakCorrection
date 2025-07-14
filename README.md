<br>

## Compute Sidak corrected p-values to account for multiple testing

<div align="justify"> The Sidak method is used when the minimum p-value across multiple tests must be corrected for the number of tests performed. Letting p be the smallest of k p-values, the Sidak corrected p-values is 1 - (1-p)^k. This formula is simple, but can suffer from numerical underflow when p is small. Here, we use a Taylor series to compute the corrected p-value even in the case of small p.
</div> 


