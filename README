# Sparse Fast Fourier Transform Is All You Need

This repository contains the official implementation and research paper for the **ECE Analysis** course project at **Sichuan University-Pittsburgh Institute (SCUPI)**. Under the guidance of **Prof. Hao Qin**, this project investigates the mechanics, history, and efficiency of the Sparse Fast Fourier Transform (SFFT) compared to traditional FFT methods.

## Abstract

The Sparse Fast Fourier Transform (SFFT) is an advanced numerical algorithm designed to analyze signals with frequency-domain sparsity more efficiently than the traditional $O(N \log N)$ Fast Fourier Transform (FFT). This study involves a detailed mathematical analysis of SFFT mechanisms—including hashing, filtering, and frequency recovery. Our research demonstrates that SFFT offers a significant decline in computational complexity for large, sparse datasets without compromising accuracy, making it ideal for applications in medical imaging and wireless communication.

## Key Research Contributions

- **Mathematical Decomposition**: In-depth analysis of randomized sub-linear time algorithms and their evolution from MIT and Michigan groups.
- **Deterministic SFT Analysis**: Evaluation of deterministic methods that guarantee correctness, moving beyond the inherent failure probabilities of randomized methods.
- **Structured Sparsity Optimization**: Exploration of **Block/Cluster Sparsity** (contiguous blocks) and **Polynomially Generated Sparsity** (algebraic structures).
- **Complexity Comparison**:
  - **Unstructured Deterministic**: $O(n^2 \log^{O(1)} N)$
  - **Prony-based Methods**: $O(n^3)$ for $n$-sparse signals.
  - **Proposed Structured SFT**: Achieves faster recovery by exploiting the algebraic structure of the frequency support.

## Performance Insights

Our findings indicate that for structured frequency supports, leveraging the structural prior dramatically reduces sampling and computational burdens.

| Feature         | Randomized SFFT        | Deterministic SFFT              |
| :-------------- | :--------------------- | :------------------------------ |
| **Runtime**     | $O(n \log^{c} N)$      | $O(n^2 \log^{O(1)} N)$          |
| **Reliability** | Probability of failure | Absolute reliability            |
| **Best Case**   | General sparse signals | Structured (Block/Poly) signals |

## Project Structure

- `/docs`: Contains the full research paper: _Sparse Fast Fourier Transform Is All You Need_.
- `/SFFT_MATLAB`: Implementation of SFFT algorithms (Hashing, Bucket Sorting, and Frequency Estimation).
- `/experiments`: Reproducibility scripts for robustness testing and hashing collision analysis.
