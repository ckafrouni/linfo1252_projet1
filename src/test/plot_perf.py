import glob
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import argparse


def plot_data(input_dir, output_dir, problem_set):
    file = f"{input_dir}/{problem_set}.csv"
    if not glob.glob(file):
        return
        
    # for file in input_files:
    data = pd.read_csv(file)

    plt.figure(figsize=(8, 6))
    sns.barplot(data=data, x="thread", y="time", hue="lock", errorbar='sd')
    plt.title(f"Time to process *{problem_set}* problem by number of threads.")
    plt.xlabel('Number of treads')
    plt.ylabel('Execution time (seconds)')
    plt.ylim(0)
    plt.grid(True, axis='y')
    
    plt.savefig(f"{output_dir}/{problem_set}.pdf", format='pdf')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate a plot from a problem-set')
    parser.add_argument('input_dir', type=str, help='Input directory')
    parser.add_argument('output_dir', type=str, help='Output directory')
    parser.add_argument('problem_set', type=str, help='')
    args = parser.parse_args()

    input_dir = args.input_dir
    output_dir = args.output_dir
    problem_set = args.problem_set

    plot_data(input_dir, output_dir, problem_set)