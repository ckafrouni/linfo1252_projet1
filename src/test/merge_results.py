import glob
import pandas as pd
import argparse

def generate_file(input_dir, problem_set, output_dir):
    input_files = glob.glob(f"{input_dir}/{problem_set}_*.csv");
    if not input_files:
        return

    output_columns = ['index', 'thread', 'time', 'run_index', 'build_type']
    data = None
    idx_counter = 0 

    
    for file in input_files:
        df = pd.read_csv(file)
        build_type = file.split('_')[-1].split('.')[0]

        df['build_type'] = build_type

        df['index'] = range(idx_counter, idx_counter + len(df))
        idx_counter += len(df)
        df = df[['index', 'thread', 'time', 'run_index', 'build_type']]

        if data is None:
            data = df
        else:
            data = pd.concat([data, df], ignore_index=True)
    
    data.to_csv(f"{output_dir}/{problem_set}.csv", index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Append data from multiple CSV files to cpu_temp.csv')
    parser.add_argument('input_directory', type=str, help='')
    parser.add_argument('output_directory', type=str, help='')
    parser.add_argument('problem_set', type=str, help='')
    args = parser.parse_args()

    generate_file(args.input_directory, args.problem_set, args.output_directory)
