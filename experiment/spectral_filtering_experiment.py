import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, fftshift

def run_spectral_filtering_experiment(N=1024, K=2):

    t = np.arange(N)

    freqs = [15.4, 40.0] 
    x = np.sum([np.exp(1j * 2 * np.pi * f * t / N) for f in freqs], axis=0)

    window_gaussian = np.exp(-0.5 * ((t - N/2) / (N/16))**2)
    

    x_rect = x 
    x_filtered = x * window_gaussian 

    X_rect = np.abs(fftshift(fft(x_rect))) / N
    X_filtered = np.abs(fftshift(fft(x_filtered))) / (N * np.mean(window_gaussian))
    
    freq_axis = np.linspace(-N/2, N/2, N)

    plt.figure(figsize=(12, 6))

    plt.subplot(2, 1, 1)
    plt.plot(freq_axis, 20 * np.log10(X_rect + 1e-6), color='gray', alpha=0.5, label='Rectangular (No Filter)')
    plt.title("Effect of Spectral Filtering: Rectangular vs Gaussian Window")
    plt.ylabel("Magnitude (dB)")
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.legend()
    plt.xlim(0, 60) 
    plt.ylim(-60, 5)

    plt.subplot(2, 1, 2)
    plt.plot(freq_axis, 20 * np.log10(X_filtered + 1e-6), color='blue', label='Gaussian Filter (G)')
    plt.fill_between(freq_axis, 20 * np.log10(X_filtered + 1e-6), -100, color='blue', alpha=0.1)
    plt.xlabel("Frequency Index (k)")
    plt.ylabel("Magnitude (dB)")
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.legend()
    plt.xlim(0, 60)
    plt.ylim(-60, 5)

    plt.tight_layout()
    plt.savefig('spectral_filtering_result.png', dpi=300)
    plt.show()

    snr_rect = 20 * np.log10(np.max(X_rect) / np.median(X_rect))
    snr_filt = 20 * np.log10(np.max(X_filtered) / np.median(X_filtered))
    print(f"Experimental Data for Section 4.1:")
    print(f"Rectangular SNR: {snr_rect:.2f} dB")
    print(f"Gaussian Filtered SNR: {snr_filt:.2f} dB")
    print(f"SNR Improvement: {snr_filt - snr_rect:.2f} dB")

if __name__ == "__main__":
    run_spectral_filtering_experiment()