package tablingassigner;

import java.io.*;
import java.util.*;

/**
 *
 * @author Rohin Jethani, Keien Ohta
 */

public class ScheduleReader {

    /** Reads in a CSV file of student information to produce a HashSet of
     *  Students.
     *
     * @param inFile The name of the students CSV file
     */

    public static HashSet<Student> processStudents(String fileName) {
        File inFile = new File(fileName);
        BufferedReader reader = null;
        HashSet<Student> studentSet = null;
        try {
            reader = new BufferedReader(new FileReader(inFile));
            studentSet = new HashSet<Student>();


            String line = null;
            while ((line=reader.readLine()) != null) {

                // The members file should look like this: ssid,position

                String delimiter = ",";
                String[] fields = line.split(delimiter);
                int ssidIndex = 0;
                int nameIndex = 1;
                int posIndex = 2;

                // NOTE: tentative
                int CM = Position.CM.val();
                int CHAIR = Position.CHAIR.val();
                int EXEC = Position.EXEC.val();

                Position pos = null;
                if (fields[posIndex].equals(CM+"")) {
                    pos = Position.CM;
                }
                else if (fields[posIndex].equals(CHAIR+"")) {
                    pos = Position.CHAIR;
                }
                else if (fields[posIndex].equals(EXEC+"")) {
                    pos = Position.EXEC;
                }
                else {
                    //TODO: something that makes more sense
                    System.out.println("Something is wrong with the position field");
                }
                int ssid = Integer.parseInt(fields[ssidIndex]);
                String name = fields[nameIndex];
                Student student = new Student(ssid, name, pos);

                studentSet.add(student);
            }
        }
        catch (IOException e) {
            System.err.println(e);
            System.exit(1);
        }
        return studentSet;

    }

    /** Reads in a CSV file of student information to produce a HashSet of
     *  Students.
     *
     * @param inFile The name of the students CSV file
     */

    public static HashMap<Integer, HashSet<TimeConflict>> processTimeConflicts(String fileName) {
        File inFile = new File(fileName);
        BufferedReader reader = null;
        HashMap<Integer, HashSet<TimeConflict>> tcMap = null;
        try {
            reader = new BufferedReader(new FileReader(inFile));
            tcMap = new HashMap<Integer, HashSet<TimeConflict>>();

            String line = null;
            while ((line=reader.readLine()) != null) {
                String delimiter = ",";
                String[] fields = line.split(delimiter);
                int ssidIndex = 0;
                int dowIndex = 1;
                int startDateIndex = 2;
                int endDateIndex = 3;
                int startTimeIndex = 4;
                int endTimeIndex = 5;

                int ssid = Integer.parseInt(fields[ssidIndex]);
                String dow = fields[dowIndex];
                int startDate = Integer.parseInt(fields[startDateIndex]);
                int endDate = Integer.parseInt(fields[endDateIndex]);
                int startTime = Integer.parseInt(fields[startTimeIndex]);
                int endTime = Integer.parseInt(fields[endTimeIndex]);
                TimeConflict timeConflict = new TimeConflict(
                    dow, startDate, endDate, startTime, endTime);
                HashSet<TimeConflict> tcSet = tcMap.get(ssid);
                if (tcSet == null) {
                    tcSet = new HashSet<TimeConflict>();
                    tcSet.add(timeConflict);
                    tcMap.put(ssid, tcSet);
                }
                else {
                    tcSet.add(timeConflict);
                }
            }
        }
        catch (IOException e) {
            System.err.println(e);
            System.exit(1);
        }
        return tcMap;
    }
}

