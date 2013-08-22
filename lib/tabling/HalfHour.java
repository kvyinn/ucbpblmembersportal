/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package tablingassigner;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author hiralmehta
 */
public class HalfHour {
    
    private HalfHour(DayOfWeek dow, int startTime) {
        _dow = dow;
        _startTime = startTime;
        _assignedStudents = new HashSet<Student>();
    }
    
    public static Set<HalfHour> getHalfHours(TablingSlot ts) {
        Set<HalfHour> halfHours = new HashSet<HalfHour>();
        int startTime = ts.startTime();
        while(startTime < ts.endTime()) {
            halfHours.add(getHalfHour(ts.dayOfWeek(),startTime));
            startTime = nextHalfHour(startTime);
        }
        return halfHours;
    }
        
    private static HalfHour getHalfHour(DayOfWeek dow, int startTime) {
        if (_halfHourMap == null) {
            _halfHourMap = new HashMap<DayOfWeek, HashMap<Integer, HalfHour>>();
        }
        if (!_halfHourMap.containsKey(dow)) {    
            _halfHourMap.put(dow, new HashMap<Integer, HalfHour>());
        }
        
        if (!_halfHourMap.get(dow).containsKey(startTime)) {
            _halfHourMap.get(dow).put(startTime, new HalfHour(dow,startTime));
        }
        
        return _halfHourMap.get(dow).get(startTime);
    }
    
    public boolean assignStudent(Student student) {
        if (isFull()) {
            return false;
        }
        if (_assignedStudents.contains(student)) {
            return false;
        } else {
            _assignedStudents.add(student);
            return true;
        }
    }
    
    public boolean removeStudent(Student student) {
        return _assignedStudents.remove(student);
    }
   
    
    public Set<Student> assignedStudents() {
        return _assignedStudents; //TODO make this immutable.
    }
    
    public int numAssigned() {
        return _assignedStudents.size();
    }
    
    public int totalCapacity() {
//        if (_dow == DayOfWeek.TUESDAY || _dow == DayOfWeek.THURSDAY) {
//            return 4;
//        } else {
//            return 3;
//        }
        return 4;
    }
    
    public Student bestRemovalCandidate() {
        Student bestRemCand = null;
        int maxNumOfOtherOptions = Integer.MIN_VALUE;
        
        for (Student student : _assignedStudents) {
            int numOfOtherOptions = student.currentAvailableSlots(TablingAssigner.PREF_LEVEL).size();
            if (numOfOtherOptions > maxNumOfOtherOptions) {
                bestRemCand = student;
                maxNumOfOtherOptions = numOfOtherOptions;
            }
        }
        return bestRemCand;
    }
    
    public int remainingCapacity() {
        return totalCapacity() - numAssigned();
    }
    
    public boolean isFull() {
        return remainingCapacity() == 0;
    }
    
    public boolean containsStudent(Student student) {
        return _assignedStudents.contains(student);
    }
    
    
    
    /** Get the start time of the half hour following I.
     * @param i A time.
     * @return The time exactly a half hour after I.
     */
    public static int nextHalfHour(int i) {
        if (String.valueOf(i).matches("[0-9]*30")) {
            return i + 70;
        } else if (String.valueOf(i).matches("[0-9]*00")) {
            return i + 30;
        } else {
            throw new IllegalArgumentException("Invalid half hour start time.");
        }


    }
    
    
    private DayOfWeek _dow;
    private int _startTime;
    private Set<Student> _assignedStudents;
    
    private static HashMap<DayOfWeek, HashMap<Integer, HalfHour>> _halfHourMap;
    
    
}
