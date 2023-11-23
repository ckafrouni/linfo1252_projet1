import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

data = pd.read_csv('./data/res_philosophers.csv')

# TODO : errorbar should be = moyenne a l'ecart type
sns.pointplot(data=data, x="thread", y="time", errorbar='ci')

plt.title('Time to process philosophers application by number of threads.')
plt.xlabel('Number of treads')
# TODO : y should start at 0.
plt.ylabel('Execution time (ms)')
plt.grid(True, axis='y')
plt.legend(title="build type :")

plt.savefig('./plots/PHILOSOPHERS.pdf', format='pdf')