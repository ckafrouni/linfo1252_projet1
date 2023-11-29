import glob
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import argparse


def plot_data(input_dir, output_dir, file_category):
    input_files = glob.glob(f"{input_dir}/{file_category}/res_*_{file_category}.csv");
        
    for file in input_files:
        data = pd.read_csv(file)
        name = file.split('_')[-2].split('.')[0]
        plt.figure(figsize=(8, 6))
        sns.barplot(data=data, x="thread", y="time", errorbar='sd')
        plt.title(f"Time to process {name} application by number of threads.")
        plt.xlabel('Number of treads')
        plt.ylabel('Execution time (seconds)')
        plt.ylim(0)
        plt.grid(True, axis='y')
        
        plt.savefig(f"{output_dir}/{file_category}/{name}_{file_category}.pdf", format='pdf')

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate plot for philosophers application tests')
    parser.add_argument('input_dir', type=str, help='Directory to get data from')
    parser.add_argument('output_dir', type=str, help='Directory to save plot to')
    parser.add_argument('file_category', type=str, help='Category of files. Either "inginious" or "local".')
    args = parser.parse_args()

    input_dir = args.input_dir
    output_dir = args.output_dir
    file_category = args.file_category

    plot_data(input_dir, output_dir, file_category)