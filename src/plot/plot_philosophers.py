import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import argparse


def plot_philosophers_data(input_dir, output_dir):  
    data = pd.read_csv(f"{input_dir}/res_philosophers.csv")

    sns.boxplot(data=data, x="thread", y="time", errorbar='sd')

    plt.title('Time to process philosophers application by number of threads.')
    plt.xlabel('Number of treads')
    plt.ylabel('Execution time (seconds)')
    plt.ylim(0)
    plt.grid(True, axis='y')

    plt.savefig(f"{output_dir}/PHILOSOPHERS.pdf", format='pdf')



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate plot for philosophers application tests')
    parser.add_argument('input_dir', type=str, help='Directory to get data from')
    parser.add_argument('output_dir', type=str, help='Directory to save plot to')
    args = parser.parse_args()

    input_dir = args.input_dir
    output_dir = args.output_dir

    plot_philosophers_data(input_dir, output_dir)