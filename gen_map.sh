NAME="v536e" # Project name
SOURCE_PAR="test_system/v536e.par" # Path to binary file PARENT
PYTHON="python3" # Your python launch codeword version >=3
SOURCE_PDB="test_system/v536e.pdb"
SOURCE_SASA="test_system/resarea.xvg"

COVAR_MAP_OUTPUT=output/${NAME}/map/covar
SOURCE_DAT="test_system/covar.dat"
SOURCE_DIST_MAP="test_system/dist_map"

make clean
make

mkdir output &> /dev/null
mkdir output/${NAME} &> /dev/null
mkdir output/${NAME}/map/ &> /dev/null

bin/get_map -f ${SOURCE_PAR} -n ${NAME} # Obtaining a matrix of mutual information between residuals from a binary file

#bin/nonoise -f1 ${SOURCE_PAR} -f2 ${SOURCE_PAR} -dt0 1 -dt1 1 -dt2 2 -n ${NAME} # Filters matrix dt1 to matrix dt0 according to a linear law through noise dt2-dt1

${PYTHON} src/python/draw_map.py -n ${NAME} -nodiag -norm # A matrix of mutual information on the remains is drawn (You can zero out the diagonal with the -nodiag flag)

${PYTHON} src/python/filtration.py -n ${NAME} -strc ${SOURCE_PDB} -cutoff 0.3 # Filtering the Mutual Information Map by Residue Exposure with pymol

${PYTHON} src/python/sasa_filtration.py -n ${NAME} -strc ${SOURCE_PDB} -sasa ${SOURCE_SASA} -cutoff 0.3 # Filtering the Mutual Information Map by Residue Exposure using gmx sasa data

${PYTHON} src/python/pure_map.py -n ${NAME} -nodiag -norm # Removes small values from MP matrix

${PYTHON} src/python/mass_map.py -n ${NAME} -nodiag -norm # Calculates the mass product matrix

${PYTHON} src/python/charge_map.py -n ${NAME} -nodiag -norm # Calculates the charge product matrix

${PYTHON} src/python/covar_map.py -f ${SOURCE_DAT} -o ${COVAR_MAP_OUTPUT} -strc ${SOURCE_PDB} # Covariance matrix per remainder according to GROMACS data

${PYTHON} src/python/lin_reg_map.py -n ${NAME} -nodiag -dist ${SOURCE_DIST_MAP} # Builds a linear regression for the MI matrix on the matrices of masses, charges and distances

# All results are stored in the ./output/${NAME}/map/ directory
# If you do not need to execute any of the programs, then just comment out the corresponding line
