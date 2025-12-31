import numpy as np
import time
import matplotlib.pyplot as plt

def run_hashing_bucketing_experiment():

    N = 2**16 
    K_list = [20, 50, 100]  
    B_ratios = np.linspace(1.5, 10, 20)  
    
    results = {}

    for K in K_list:
        collision_rates = []
        runtimes = []
        
        for ratio in B_ratios:
            B = int(K * ratio)

            start_time = time.perf_counter()
            
            iters = 1000
            collisions = 0
            for _ in range(iters):
                buckets = np.random.randint(0, B, size=K)
                unique_buckets = np.unique(buckets)
                collisions += (K - len(unique_buckets))
            
            avg_collision_rate = (collisions / (K * iters)) * 100
            end_time = time.perf_counter()
            
            collision_rates.append(avg_collision_rate)
            runtimes.append((end_time - start_time) / iters * 1000) # 单位: ms

        results[K] = {
            'ratios': B_ratios,
            'collision_rates': collision_rates,
            'runtimes': runtimes
        }

    plt.figure(figsize=(12, 5))

    plt.subplot(1, 2, 1)
    for K in K_list:
        plt.plot(B_ratios, results[K]['collision_rates'], label=f'K={K}', marker='o', markersize=4)
    plt.axhline(y=5, color='r', linestyle='--', label='5% Threshold')
    plt.xlabel("Bucket Ratio (B/K)")
    plt.ylabel("Collision Rate (%)")
    plt.title("Collision Rate vs. Bucket Size")
    plt.grid(True, alpha=0.3)
    plt.legend()

    plt.subplot(1, 2, 2)
    for K in K_list:

        B_vals = B_ratios * K
        simulated_runtime = B_vals * np.log2(B_vals) * 1e-5 
        plt.plot(B_ratios, simulated_runtime, label=f'K={K}', linestyle='--')
    
    plt.xlabel("Bucket Ratio (B/K)")
    plt.ylabel("Simulated Complexity (A.U.)")
    plt.title("Computational Overhead Estimate")
    plt.grid(True, alpha=0.3)
    plt.legend()

    plt.tight_layout()
    plt.savefig('hashing_experiment_result.png', dpi=300)
    plt.show()

    print(f"{'Ratio (B/K)':<12} | {'Collision % (K=50)':<18} | {'Complexity Factor'}")
    print("-" * 50)
    for i in [0, 5, 10, 19]:
        r = B_ratios[i]
        c = results[50]['collision_rates'][i]
        comp = r * 50 * np.log2(r * 50)
        print(f"{r:<12.2f} | {c:<18.2f} | {comp:.2f}")

if __name__ == "__main__":
    run_hashing_bucketing_experiment()