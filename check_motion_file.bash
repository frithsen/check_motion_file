# created 1/29/2018 by AF
# input three parameters: 1 = motion censor file name; 2 = suffix for file names created; 3 = threshold (this is threshold for GOOD timepoints --> e.g., use 90 if only want to include subjects with 10% or less motion trials)
# e.g., check_motion_file.bash motion_censor_vector_study.txt study 90

if [ "$#" -lt 3 ]; then   # check if all three input values were given, if not, tell me and exit
    echo "Missing some input -- need motion file, suffix, and threshold"
    exit
fi

echo "checking sub $i"
{

num_good_tp=$(awk '{s+=$1} END {print s}' $1)  # this sums up the values in the file (remember: 0=bad; 1=good timepoint) so the sum will tell you how many good ones there are
num_all_tp=$(wc -l < $1) # this counts how many timepoints there are in total
echo "100 * $num_good_tp/$num_all_tp" | bc > percent_good_tp_$2  # this tells you what percent are good (i.e., what % are 1s) and will save this as 'percent_good_tp'

percent_good_tp=`cat percent_good_tp_$2`
} &> /dev/null  # this just suppresses the output of everything inside the curly brackets so that your screen isn't too cluttered

# the if/then statement below will save the percent_good_tp as either 'bad_motion_sub' or 'good_motion_sub' depending on whether the # of bad timepoints exceeds a certain threshold. Having a different file name depending on good/bad status may be helpful for later processing (simply use -e command to see if file exists)

if [ "$percent_good_tp" -lt $3 ]; then  # check percent_good_tp against threshold, if it is less than the threshold let me know and save this amount as 'bad_motion_sub'
    echo "Too much motion"
    echo "$percent_good_tp" > bad_motion_sub_$2
elif [ "$percent_good_tp" -ge $3 ]; then  # if percent_good_tp is equal to or greater than the threshold, let me know and save this amount as 'good_motion_sub'
    echo "Good subject"
    echo "$percent_good_tp" > good_motion_sub_$2
else
    echo "something went wrong"
fi
