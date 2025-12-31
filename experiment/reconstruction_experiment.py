import numpy as np
import matplotlib.pyplot as plt

def run_reconstruction_experiment():
 
    N = 4096      
    K = 50       
    B = 200      
    L_list = np.arange(1, 11) 

    true_amplitudes = np.ones(K)
    
    avg_l2_errors = []
    recovery_rates = []

    for L in L_list:
        iters = 500
        total_l2_error = 0
        total_recovered = 0
        
        for _ in range(iters):

            estimates = []
            
            for _ in range(L):

                hash_map = np.random.randint(0, B, size=K)

                bucket_vals = np.zeros(B)
                for i in range(K):
                    bucket_vals[hash_map[i]] += true_amplitudes[i]
                

                current_estimate = bucket_vals[hash_map]
                estimates.append(current_estimate)
            

            final_estimate = np.median(estimates, axis=0)

            error = np.sqrt(np.mean((true_amplitudes - final_estimate)**2))
            total_l2_error += error

            total_recovered += np.sum(np.abs(true_amplitudes - final_estimate) < 0.1)
            
        avg_l2_errors.append(total_l2_error / iters)
        recovery_rates.append((total_recovered / (K * iters)) * 100)

    plt.figure(figsize=(12, 5))

    plt.subplot(1, 2, 1)
    plt.plot(L_list, avg_l2_errors, 'r-o', linewidth=2, label='$L_2$ Reconstruction Error')
    plt.xlabel("Number of Iterations ($L$)")
    plt.ylabel("$L_2$ Error")
    plt.title("Error Convergence vs. Iterations")
    plt.grid(True, which='both', linestyle='--', alpha=0.5)
    plt.legend()

    plt.subplot(1, 2, 2)
    plt.plot(L_list, recovery_rates, 'g-s', linewidth=2, label='Peak Recovery Rate')
    plt.xlabel("Number of Iterations ($L$)")
    plt.ylabel("Recovery Rate (%)")
    plt.title("Success Rate vs. Iterations")
    plt.ylim(0, 105)
    plt.grid(True, which='both', linestyle='--', alpha=0.5)
    plt.legend()

    plt.tight_layout()
    plt.savefig('reconstruction_experiment_result.png', dpi=300)
    plt.show()

    print(f"Experimental Data for Section 4.3:")
    print(f"At L=1, Recovery Rate: {recovery_rates[0]:.2f}%, L2 Error: {avg_l2_errors[0]:.4f}")
    print(f"At L={L_list[-1]}, Recovery Rate: {recovery_rates[-1]:.2f}%, L2 Error: {avg_l2_errors[-1]:.4f}")

if __name__ == "__main__":
    run_reconstruction_experiment()