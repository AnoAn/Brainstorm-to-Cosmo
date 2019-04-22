# Brainstorm_to_Cosmo

The script converts EEG epochs exported from Brainstorm (BS) into CoSMoMVPA format.
For the script to work you have to select the relevant epochs in BS, right click on them -> export to file, and choose the FieldTrip format.
The first file exported will be the reference file, which Cosmo will also need as part of the input.
The data from the other files will be attached to the first to form a 3D matrix and stored in a file named out.m.
