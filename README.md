# Brainstorm_to_Cosmo

The script converts EEG epochs exported from Brainstorm (BS) into CoSMoMVPA format.
Note that each epoch should represent a single run of a condition (the average of all the epochs of that condition in a single block of trials).

For the script to work you have to select the relevant averaged epochs of 2 conditions in the BS interface (hold Ctrl + click), then right click on them -> export to file, and choose the FieldTrip format.

The first file exported will be the reference file, which Cosmo will also need as part of the input.
The data from the other files will be attached to the first to form a 3D matrix and stored in a file named out.m.
