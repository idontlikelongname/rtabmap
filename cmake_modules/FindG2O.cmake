#Pre-requisites: Look for csparse
FIND_PATH(CSPARSE_INCLUDE_DIR NAMES cs.h PATH_SUFFIXES suitesparse )
FIND_LIBRARY(CSPARSE_LIBRARY NAMES cxsparse)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CSPARSE DEFAULT_MSG CSPARSE_INCLUDE_DIR CSPARSE_LIBRARY)


# G2O: Find the header files

FIND_PATH(G2O_INCLUDE_DIR g2o/core/base_vertex.h)

# Macro to unify finding both the debug and release versions of the
# libraries; this is adapted from the OpenSceneGraph FIND_LIBRARY
# macro.

MACRO(FIND_G2O_LIBRARY MYLIBRARY MYLIBRARYNAME)

  FIND_LIBRARY("${MYLIBRARY}_DEBUG"
    NAMES "g2o_${MYLIBRARYNAME}_d"
    )
  
  FIND_LIBRARY(${MYLIBRARY}
    NAMES "g2o_${MYLIBRARYNAME}"
    )
  
  IF(NOT ${MYLIBRARY}_DEBUG)
    IF(MYLIBRARY)
      SET(${MYLIBRARY}_DEBUG ${MYLIBRARY})
    ENDIF(MYLIBRARY)
  ENDIF( NOT ${MYLIBRARY}_DEBUG)
  
ENDMACRO(FIND_G2O_LIBRARY LIBRARY LIBRARYNAME)

# Find the core elements
FIND_G2O_LIBRARY(G2O_STUFF_LIBRARY stuff)
FIND_G2O_LIBRARY(G2O_CORE_LIBRARY core)

# Find the CLI library
FIND_G2O_LIBRARY(G2O_CLI_LIBRARY cli)

# Find the pluggable solvers
FIND_G2O_LIBRARY(G2O_SOLVER_CHOLMOD solver_cholmod)
FIND_G2O_LIBRARY(G2O_SOLVER_CSPARSE solver_csparse)
FIND_G2O_LIBRARY(G2O_SOLVER_CSPARSE_EXTENSION csparse_extension)
FIND_G2O_LIBRARY(G2O_SOLVER_DENSE solver_dense)
FIND_G2O_LIBRARY(G2O_SOLVER_PCG solver_pcg)
FIND_G2O_LIBRARY(G2O_SOLVER_SLAM2D_LINEAR solver_slam2d_linear)
FIND_G2O_LIBRARY(G2O_SOLVER_STRUCTURE_ONLY solver_structure_only)
FIND_G2O_LIBRARY(G2O_SOLVER_EIGEN solver_eigen)

# Find the predefined types
FIND_G2O_LIBRARY(G2O_TYPES_DATA types_data)
FIND_G2O_LIBRARY(G2O_TYPES_ICP types_icp)
FIND_G2O_LIBRARY(G2O_TYPES_SBA types_sba)
FIND_G2O_LIBRARY(G2O_TYPES_SCLAM2D types_sclam2d)
FIND_G2O_LIBRARY(G2O_TYPES_SIM3 types_sim3)
FIND_G2O_LIBRARY(G2O_TYPES_SLAM2D types_slam2d)
FIND_G2O_LIBRARY(G2O_TYPES_SLAM3D types_slam3d)

# G2O solvers declared found if we found at least one solver
SET(G2O_SOLVERS_FOUND "NO")
IF(G2O_SOLVER_CHOLMOD OR G2O_SOLVER_CSPARSE OR G2O_SOLVER_DENSE OR G2O_SOLVER_PCG OR G2O_SOLVER_SLAM2D_LINEAR OR G2O_SOLVER_STRUCTURE_ONLY OR G2O_SOLVER_EIGEN)
  SET(G2O_SOLVERS_FOUND "YES")
ENDIF(G2O_SOLVER_CHOLMOD OR G2O_SOLVER_CSPARSE OR G2O_SOLVER_DENSE OR G2O_SOLVER_PCG OR G2O_SOLVER_SLAM2D_LINEAR OR G2O_SOLVER_STRUCTURE_ONLY OR G2O_SOLVER_EIGEN)

# G2O itself declared found if we found the core libraries and at least one solver
SET(G2O_FOUND "NO")
IF(G2O_STUFF_LIBRARY AND G2O_CORE_LIBRARY AND G2O_INCLUDE_DIR AND G2O_SOLVERS_FOUND AND CSPARSE_FOUND)
  SET(G2O_INCLUDE_DIRS ${G2O_INCLUDE_DIR} ${CSPARSE_INCLUDE_DIR})
  SET(G2O_LIBRARIES 
	${G2O_STUFF_LIBRARY} 
	${G2O_CORE_LIBRARY} 
	${G2O_SOLVER_CSPARSE} 
	${G2O_SOLVER_CSPARSE_EXTENSION}
	${G2O_TYPES_SLAM2D} 
	${G2O_TYPES_SLAM3D} 
	${CSPARSE_LIBRARY})
  SET(G2O_FOUND "YES")
ENDIF(G2O_STUFF_LIBRARY AND G2O_CORE_LIBRARY AND G2O_INCLUDE_DIR AND G2O_SOLVERS_FOUND AND CSPARSE_FOUND)
