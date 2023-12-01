import glob
import pandas as pd
import argparse

def generate_file(input_dir, input_file_type, output_file):
    input_files = glob.glob(f"{input_dir}/res_{input_file_type}_*.csv");

    output_columns = ['index', 'thread', 'time', 'run_index', 'build_type']
    data = pd.DataFrame(columns=output_columns)
    idx_counter = 0 

    for file in input_files:
        df = pd.read_csv(file)
        build_type = file.split('_')[-1].split('.')[0]

        df['build_type'] = build_type

        df['index'] = range(idx_counter, idx_counter + len(df))
        idx_counter += len(df)
        df = df[['index', 'thread', 'time', 'run_index', 'build_type']]
        data = pd.concat([data, df], ignore_index=True)

    data.to_csv(f"{working_dir}/res_{input_file_type}.csv", index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Append data from multiple CSV files to cpu_temp.csv')
    parser.add_argument('working_dir', type=str, help='Directory in which files have to be merged')
    parser.add_argument('input_file_type', type=str, help='Files to merge data from')
    parser.add_argument('output_file', type=str, help='Output file path for cpu_temp.csv')
    args = parser.parse_args()

    working_dir = args.working_dir
    input_file_type = args.input_file_type
    output_file = args.output_file

    generate_file(working_dir, input_file_type)
