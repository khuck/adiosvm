#spack load adios2@develop fftw

export FFTW_DIR=`which fftw-wisdom | xargs dirname | xargs dirname`
export ADIOS2_DIR=`adios2-config --prefix`