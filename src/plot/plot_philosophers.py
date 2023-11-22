import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

data = pd.read_csv('./data/res_philosophers.csv')

sns.pointplot(data=data, x="thread", y="time", hue="build", markers=["s", "D"], linestyles=["-", "-"], errorbar='ci')

plt.title('Time to process algorithm by number of threads.')
plt.xlabel('Number of treads')
plt.ylabel('Time (ms)')
plt.grid(True, axis='y')
plt.legend(title="build type :")

plt.savefig('./plots/PHILOSOPHERS.pdf', format='pdf')