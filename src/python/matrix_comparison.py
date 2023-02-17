import sys
import json
import numpy as np
import pylab as plt
import seaborn as sns
import pandas as pd

diag = True

if not ("-f1" in sys.argv and "-f2" in sys.argv and "-o" in sys.argv and len(sys.argv) >= 7):
    print("USAGE:\n"+sys.argv[0]+" -f1 intensity1.json -f2 intensity2.json -o output -nodiag")
    exit()
    
for i in range(1, len(sys.argv)) :
    if sys.argv[i] == "-f1":
        f1 = sys.argv[i+1]
    if sys.argv[i] == "-o":
        out_path = sys.argv[i+1]
    if sys.argv[i] == "-f2":
        f2 = sys.argv[i+1]
    if sys.argv[i] == "-nodiag":
        diag = False

with open(f1) as json_file:
    data = json.load(json_file)

map_ = np.array(data['map'])
if not diag:
    map_ = map_ - np.diag(np.diag(map_))
names = np.array(data['names'])

with open(f2) as json_file:
    data = json.load(json_file)

your_map = np.array(data['map'])
if not diag:
    your_map = your_map - np.diag(np.diag(your_map))

if (np.shape(your_map) != np.shape(map_)):
    print('Error: matrices have different size (' + str(np.shape(map_)) +' and ' +str(np.shape(your_map)) + ')')
    exit()

frob1 = np.sqrt(sum(abs(map_.flatten())**2)) #Frobenius norm of a matrix
frob2 = np.sqrt(sum(abs(your_map.flatten())**2))

mat1 = map_/frob1
mat2 = your_map/frob2
mat = mat1-mat2

frob = np.sqrt(sum(abs(mat.flatten())**2))

print('The original matrices have Frobenius norms equal to', frob1, '(First matrix) and', frob2, '(Second matrix);')
print('The Frobenius norm of the difference of matrices is', frob, '.')

MAT = pd.DataFrame(data=mat[::-1, :], index=names[::-1], columns=names)

fig, axs = plt.subplots(figsize=(10,10), constrained_layout=True)

sns.heatmap(MAT, annot=False, cmap="bwr", center=0)

plt.title('Difference matrix of normalized matrices with norm ' + str(round(frob,3)), fontsize=20)
fig.savefig(out_path + '.pdf')

new_data = {}
new_data['first_matrix_norm'] = frob1
new_data['second_matrix_norm'] = frob2
new_data['diff_of_matrix_norm'] = frob
new_data['difference'] = mat.tolist()
with open(out_path + '.json', 'w') as outfile:
    json.dump(new_data, outfile)
