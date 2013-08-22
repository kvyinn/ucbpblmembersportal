package tablingassigner;

import java.io.*;
import java.util.*;

public class Tests {
    public static void main(String[] args) {
        Student s1 = new Student(22737599, "Keien Ohta", Position.EXEC);
        ScheduleReader reader = new ScheduleReader();
        TablingSlot slot1 = new TablingSlot(DayOfWeek.WEDNESDAY, 1200, 1230);
        String fileName = "members.csv";
        System.out.println("Testing Student deserialization with file " + fileName + ":");
        HashSet<Student> studentSet = null;
        studentSet = reader.processStudents(fileName);
        System.out.println("File deserialized, examining output:");
        for (Student student : studentSet) {
            System.out.println(student.name()
                    + ", Position: " + student.position());
        }

        System.out.println("\nTesting TimeConflict class:");
        TimeConflict tc1 = new TimeConflict("M-W--", 20130122, 20130514, 1400, 1530);
        System.out.println("Checking fields...");
        System.out.println("TimeConflict " + tc1.daysOfWeek() + ", " +
            tc1.startDate() + " to " + tc1.endDate() + "; " +
            tc1.startTime() + " to " + tc1.endTime());

        String tcFile = "test_schedules.csv";
        System.out.println("\nTesting TimeConflict deserialization with file " + tcFile + ":");
        HashMap tcMap = null;
        tcMap = reader.processTimeConflicts(tcFile);
        System.out.println("File deserialized, examining output:");
        for (Integer ssid : (Set<Integer>)(tcMap.keySet())) {
            System.out.println("Student " + ssid + " has the following conflicts:");
            for (TimeConflict tc : (HashSet<TimeConflict>)(tcMap.get(ssid))) {
            System.out.println("\t" + tc.daysOfWeek() + ", " +
                tc.startDate() + " to " + tc.endDate() + "; " +
                tc.startTime() + " to " + tc.endTime());
            }
        }
        System.out.println("\nTesting availableSlots for student " + s1.name());
        s1.getTimeConflicts(tcMap);
        HashSet<TablingSlot> tsSet = s1.availableSlots(0);
        System.out.println("Displaying all available TablingSlots for Student " + s1.SSID());
        for (TablingSlot ts : tsSet) {
          System.out.print(ts.dayOfWeek() + " from " + ts.startTime() + " to " + ts.endTime() + ", ");
        }
        System.out.println();

        // Testing Time class

        Time t1 = new Time(10, 30);
        Time t2 = new Time(1130);
        System.out.println(t1 + " " + t2);
        System.out.println(t1.getReal() + " " + t2.getReal());

        System.out.println(t1.add(t2));
        System.out.println(t1.add(t2.getLiteral()));
        System.out.println(t1.add(t2.getReal()));

        // Testing TablingSettings class
        HashSet<TablingSlot> tsSet2 = TablingSettings.enumerateTablingSlots();
        for (TablingSlot ts : tsSet2) {
            System.out.println(ts.dayOfWeek() + ", " + ts.startTime());
        }
    }
}
