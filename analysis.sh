NAME="v536e" # Project name
PYTHON="python3" # Your python launch codeword version >=3
SOURCE_ACTIVE_SITE="test_system/v536e_groups.json" # Path to a json file with a list of active site amino acid residues in the PARENT order 
                                                        # (can be understood from a json file obtained from a binary file using the "names" and "real _numbers" lists)
SOURCE_ALLOSTERIC_SITE="test_system/v536e_groups.json" # Path to a json file with a list of allosteric site amino acid residues in the PARENT order 
SOURCE_PDB="test_system/v536e.pdb" # Path to pdb file with protein
ALLOSTERIC_SITE_NAME="allosteric_site" # List name in json file
ACTIVE_SITE_NAME="active_site" # List name in json file
OTHER_NAME="..."

mkdir output &> /dev/null
mkdir output/${NAME} &> /dev/null
mkdir output/${NAME}/analysis &> /dev/null

${PYTHON} src/python/allosteric_site_search.py -n ${NAME} -f ${SOURCE_ACTIVE_SITE} -asn ${ACTIVE_SITE_NAME} # Draws the intensity of association
#                                                         of amino acid residues with the active site (Set the -filt or -sasa_filt flag to use a filtered matrix)
#                                                                      (Add the -noseq flag to ignore the interaction of adjacent residues in sequence)

${PYTHON} src/python/allosteric_site_top10.py -n ${NAME} -f ${SOURCE_ACTIVE_SITE} -asn ${ACTIVE_SITE_NAME} # Draws top 10% intensity of association
#                                                of amino acid residues with the active site (Add the -noseq flag to ignore the interaction of adjacent residues in sequence)

${PYTHON} src/python/zscore.py -n ${NAME} -f ${SOURCE_ACTIVE_SITE} -asn ${ACTIVE_SITE_NAME} # Draws zscore of intensity of association
#                                                of amino acid residues with the active site (Add the -noseq flag to ignore the interaction of adjacent residues in sequence)

${PYTHON} src/python/critical_resid.py -n ${NAME} -noseq 2 # Draws the informational entropy of each residue and the mutual information of each residue with the entire protein

${PYTHON} src/python/allostery_paint_top10.py -strc ${SOURCE_PDB} -n ${NAME} -f_act ${SOURCE_ACTIVE_SITE} -asn ${ACTIVE_SITE_NAME} -allsn ${ALLOSTERIC_SITE_NAME} -f_all ${SOURCE_ALLOSTERIC_SITE} # Draws top 10% intensity of association of amino acid residues with the active site in a pymol session
#                                                 (Add the -noseq flag to ignore the interaction of adjacent residues in sequence)

${PYTHON} src/python/allostery_paint.py -strc ${SOURCE_PDB} -n ${NAME} -f_act ${SOURCE_ACTIVE_SITE} -asn ${ACTIVE_SITE_NAME} -allsn ${ALLOSTERIC_SITE_NAME} -f_all ${SOURCE_ALLOSTERIC_SITE}
#                  Draws the intensity of association of amino acid residues with the active site in a pymol session (Set the -filt or -sasa_filt flag to use a filtered matrix)
#                                                                      (Add the -noseq flag to ignore the interaction of adjacent residues in sequence)

${PYTHON} src/python/zscore_top.py -n ${NAME} -f_act ${SOURCE_ACTIVE_SITE} -asn ${ACTIVE_SITE_NAME} -allsn ${ALLOSTERIC_SITE_NAME} -f_all ${SOURCE_ALLOSTERIC_SITE}
#                                                   Builds a table with an analysis of the interaction between the active and allosteric sites in terms of zscore, 
#                               and also builds an overlap based on the remnants of the active site (Add the -noseq flag to ignore the interaction of adjacent residues in sequence)

${PYTHON} src/python/intensity_table.py -n ${NAME} -f_act ${SOURCE_ACTIVE_SITE} -asn ${ACTIVE_SITE_NAME} # Creates a table with intensities
#                                                 (Add the -noseq flag to ignore the interaction of adjacent residues in sequence)

${PYTHON} src/python/intensity_top.py -n ${NAME} -f_act ${SOURCE_ACTIVE_SITE} -asn ${ACTIVE_SITE_NAME} -allsn ${ALLOSTERIC_SITE_NAME} -f_all ${SOURCE_ALLOSTERIC_SITE}
#                                                   Builds a table with an analysis of the interaction between the active and allosteric sites in terms of zscore, 
#                               and also builds an overlap based on the remnants of the active site (Add the -noseq flag to ignore the interaction of adjacent residues in sequence)

${PYTHON} src/python/crit_resid.py -strc ${SOURCE_PDB} -n ${NAME} -f_act ${SOURCE_ACTIVE_SITE} -asn ${ACTIVE_SITE_NAME} -allsn ${ALLOSTERIC_SITE_NAME} -f_all ${SOURCE_ALLOSTERIC_SITE}
#                                                    Finding Critical Remnants of Allosteric Communication Between Sites

#${PYTHON} src/python/compare_systems.py -n1 ${NAME} -n2 ${OTHER_NAME} # Script to compare two systems

# All results are stored in the ./output/${NAME}/analysis/ directory
# If you do not need to execute any of the programs, then just comment out the corresponding line
