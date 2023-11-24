
# @ Preeti Agarwal
# Cite : Preeti Agarwal, Nityendra Shukla, Sahil Mahfooz*, Jitendra Narayan* **Comparative Genome Analysis Reveals Insights into Driving Forces behind Monkeypox Virus Evolution and Sheds Light on the Active Role of Trinucleotide Motif ATC** 2023
# Contact : prtgrwl8@gmail.com
# usage : python SSRmlcr.py 

import pandas as pd

# Read the data from the Excel file
df = pd.read_excel('excel_for_conserve_script.xlsx')

# Group by loci, motif, repeat and aggregate genome file numbers
grouped = df.groupby(['loci', 'motif', 'repeat'])['genome file no.'].agg([('unique genome files', lambda x: ','.join(map(str, set(x)))), ('count of unique files', 'nunique')])

# Reset index to get a DataFrame
result = grouped.reset_index()

# Write the result to a new Excel file
#result.to_excel('output_file.xlsx', index=False)

# Count occurrences of each unique value in 'count of unique files' column
count_values = result['count of unique files'].value_counts().reset_index()
count_values.columns = ['Unique File Count', 'Count']

# Write the count of occurrences to a new Excel file
count_values.to_excel('count_values_output.xlsx', index=False)
