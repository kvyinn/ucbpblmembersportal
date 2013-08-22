javac -d . *.java
rm initial_schedule.csv
touch initial_schedule.csv

java tablingassigner.TablingAssignerTemp
java tablingassigner.TablingAssigner | cat >> initial_schedule.csv
cp members.csv ../ucbpbltabling/lib/tasks/data/
cp available_slots.csv ../ucbpbltabling/lib/tasks/data/tabling_slots.csv
cp initial_schedule.csv ../ucbpbltabling/lib/tasks/data/
